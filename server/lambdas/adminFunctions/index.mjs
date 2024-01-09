import { CognitoIdentityProviderClient, ListUsersCommand,AdminDeleteUserCommand } from "@aws-sdk/client-cognito-identity-provider";
const client = new CognitoIdentityProviderClient();

export const handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json",
  };
  
  var input;
  var command;
    

  try {
    switch (event.routeKey) {
      case "DELETE /users/{id}":
        input = { 
          UserPoolId: "eu-north-1_5mwqN2dXj", 
          Username: event.pathParameters.id,
        };
        command = new AdminDeleteUserCommand(input);
        body = await client.send(command);
        //body = `Deleted user ${event.pathParameters.id}`;
        break;
      case "GET /users":
        input = { 
          UserPoolId: "eu-north-1_5mwqN2dXj", // required
        };
        command = new ListUsersCommand(input);
        body = await client.send(command);
        body = body.Users;
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
