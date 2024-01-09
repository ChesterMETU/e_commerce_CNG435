import { DynamoDBClient ,CreateBackupCommand, ListBackupsCommand, DeleteBackupCommand} from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
} from "@aws-sdk/lib-dynamodb";
import { S3Client,PutObjectCommand } from "@aws-sdk/client-s3"

const client = new DynamoDBClient({});

const dynamo = DynamoDBDocumentClient.from(client);

const tableName = "item_table";
const counterTable = "itemID_counter";

var input;
var command;

export const handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json",
  };
    

  try {
    switch (event.routeKey) {
      case "GET /backupDb":
        input = {
          TableName: tableName,
          BackupName: "Item_table_backup", 
        };
        command = new CreateBackupCommand(input);
        body = await client.send(command);
        
        input = {
          TableName: counterTable,
          BackupName: "Item_table_backup", 
        };
        command = new CreateBackupCommand(input);
        await client.send(command);
        break;
      case "GET /listBackupDb":
        input = {};
        command = new ListBackupsCommand(input);
        body = await client.send(command);
        body = body.BackupSummaries;
        break;
      case "DELETE /backupDb":
        let requestJSON = JSON.parse(event.body);
        input = { 
          BackupArn: requestJSON.id,
        }
        command = new DeleteBackupCommand(input);
        await client.send(command);
        body = "Backup deleted";
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
