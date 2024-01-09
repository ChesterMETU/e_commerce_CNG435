import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
  GetCommand,
  DeleteCommand,
  QueryCommand,
  UpdateCommand
} from "@aws-sdk/lib-dynamodb";
import { S3Client,PutObjectCommand } from "@aws-sdk/client-s3"
const S3 = new S3Client({});

const client = new DynamoDBClient({});

const dynamo = DynamoDBDocumentClient.from(client);

const tableName = "item_table";
const counterTable = "itemID_counter";

export const handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json",
  };
    

  try {
    switch (event.routeKey) {
      case "GET /itemsByUser/{id}":
        body = await dynamo.send(
          new ScanCommand({ 
            TableName: tableName ,
            FilterExpression : 'creator_id = :id',
            ExpressionAttributeValues : {':id' : event.pathParameters.id}})
        );
        body = body.Items
        break;
      case "DELETE /items/{id}":
        await dynamo.send(
          new DeleteCommand({
            TableName: tableName,
            Key: {
              item_ID: event.pathParameters.id,
            },
          })
        );
        body = `Deleted item ${event.pathParameters.id}`;
        break;
      case "GET /items/{id}":
        body = await dynamo.send(
          new GetCommand({
            TableName: tableName,
            Key: {
              item_ID: event.pathParameters.id,
            },
          })
        );
        body = body.Item;
        break;
      case "GET /items":
        body = await dynamo.send(
          new ScanCommand({ TableName: tableName })
        );
        body = body.Items;
        break;
      case "PUT /items":
        let requestJSON = JSON.parse(event.body);
        
        
        var IDcounter =  await dynamo.send(
          new GetCommand({
            TableName: counterTable,
            Key: {
              counter: "1",
            },
          })
        );
        
        IDcounter = IDcounter.Item.counterID;
        
        await dynamo.send(
          new UpdateCommand({
            TableName: counterTable,
            Key: {
              counter: "1"
            },
            UpdateExpression: 'set #c = :x',
            ExpressionAttributeNames: {'#c' : 'counterID'},
            ExpressionAttributeValues: {
              ':x' : IDcounter + 1,
            }
          })  
        );
        
        await dynamo.send(
          new PutCommand({
            TableName: tableName,
            Item: {
              item_ID: `${IDcounter}`,
              price: requestJSON.price,
              piece: requestJSON.piece,
              name: requestJSON.name,
              creator_id: requestJSON.creator_id,
              image: requestJSON.file,
              description: requestJSON.product_description,
              category: "unknown"
            },
          })
        );
        
        
        const base64Image = requestJSON.file;
        const decodedImage = Buffer.from(base64Image,"base64");
        const command = new PutObjectCommand({
          Bucket: "rekonimage",
          Key: `${IDcounter}`,
          Body: decodedImage,
          ContentType: "image/jpeg"
        });
        const response = await S3.send(command);
        body = requestJSON.file;
        break;
      case "GET /itemsbycategory/{category}":
        const data = await dynamo.send(
          new ScanCommand({
            TableName: tableName,
            ExpressionAttributeNames: {
                '#C': 'category',
            },
            ExpressionAttributeValues: {
              ':category': event.pathParameters.category,
            },
            FilterExpression: '#C = :category',
          })
        );
        body = data.Items;
        break;
      case "GET /itemcategorys":
        var items = await dynamo.send(
          new ScanCommand({ TableName: tableName })
        );
        items = items.Items;
        const distinctValues = {};

        items.forEach(item => {
          
          const attributeValue = item["category"];
          distinctValues[attributeValue] = true;
        });
        
        body = Object.keys(distinctValues);
        break;
      default:
        throw new Error(`Unsupported route: "${event.routeKey}"`);
    }
  } catch (err) {
    statusCode = 400;
    body = err.message;
  } finally {
    body = JSON.stringify(body);
  }

  return {
    statusCode,
    body,
    headers,
  };
};
