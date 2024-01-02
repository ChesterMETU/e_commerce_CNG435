import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  GetCommand,
  DeleteCommand,
  UpdateCommand,
} from "@aws-sdk/lib-dynamodb";
import { S3Client,PutObjectCommand } from "@aws-sdk/client-s3"
const S3 = new S3Client({});

const client = new DynamoDBClient({});

const dynamo = DynamoDBDocumentClient.from(client);

const tableName = "item_table";

export const handler = async (event) => {
  let requestJSON = JSON.parse(event.body);
  let body = "Complete";
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json",
  };
  let error = 0;
  
  async function asyncForEachGet(items,callback) {
    for(let i = 0;i<items.length;i++) {
      let data;
      data = await dynamo.send(
      new GetCommand({
          TableName: tableName,
          Key: {
            item_ID: items[i].id,
          },
        })
      );

      data = data.Item;
      if(data.piece < items[i].piece) {
        error = 1;
        body = 'The ${data.name} does not meet the quantity you selected';
      } 
    }
  }
  
  async function asyncForEachGetOp(items) {
    for(let i = 0;i<items.length;i++) {
      let data = await dynamo.send(
          new GetCommand({
            TableName: tableName,
            Key: {
              item_ID: items[i].id,
            },
          })
        );
        data = data.Item;
        if(data.piece === items[i].piece) {
        
          await dynamo.send(
            new DeleteCommand({
              TableName: tableName,
              Key: {
                item_ID: items[i].id,
              },
            })
          );
        } else {
          
          await dynamo.send(
            new UpdateCommand({
              TableName: tableName,
              Key: {"item_ID": items[i].id},
              ExpressionAttributeNames: {
                  '#P': 'piece',
              },
              ExpressionAttributeValues: {
                  ':p': data.piece - items[i].piece
              },
              UpdateExpression: 'SET #P = :p',
              ReturnValues: "UPDATED_NEW",
            })  
          );
        }
    }
  }
  
  try {
    await asyncForEachGet(requestJSON.items);

    
    if(error != 1) {
      
      await asyncForEachGetOp(requestJSON.items);
      
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