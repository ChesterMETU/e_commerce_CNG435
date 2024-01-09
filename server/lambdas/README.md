# Admin Function
This lambda has two functionalities:
  Deleting user by user id.
  Getting all the users from the Cognito user pool.

# db Function
This lambda functions are created for Admin to have control over database. Has the following functionalities:
    Backuping All Databases
  To create a backup for all databases, we created a lambda function that is triggered by making a GET
  request to the following API endpoint: https://5q3rsscxvf.execute-api.eu-central1.amazonaws.com/backupDb
    Getting All The Created Backups of Databases
  To get all backups, we created a lambda function that is triggered by making a GET request to the
  following API endpoint: https://5q3rsscxvf.execute-api.eu-central-1.amazonaws.com/listBackupDb
    Deleting A Backup By ID
  To delete a backup, we created a lambda function that is triggered by making a DELETE request to the
  following API endpoint: https://5q3rsscxvf.execute-api.eu-central-1.amazonaws.com/backupDb

# Inventory Function
In the application, there is no payment requirements. Therefore, relevant functionalities are not
implemented and to simulate the purchase we created lambda function. It is triggered by making a
POST request to the following API endpoint: https://6v11idz44b.execute-api.eu-central1.amazonaws.com/completepurchase

# Items Function
  Adding An Item
To add an item, we created a lambda function that is triggered by making a PUT request to the
following API endpoint: https://4151wpvtqb.execute-api.eu-central-1.amazonaws.com/items
  Getting All Items
To get all items from the database, we created a lambda function that is triggered by making a GET
request to the following API endpoint: https://4151wpvtqb.execute-api.eu-central-1.amazonaws.com/items
  Getting Items by User ID
To get items for a specific user, we created a lambda function that is triggered by making a GET request
to the following API endpoint: https://4151wpvtqb.execute-api.eu-central1.amazonaws.com/itemsByUser/{id}
  Getting An Item by ID
To get an item from the database, we created a lambda function that is triggered by making a GET
request to the following API endpoint: https://4151wpvtqb.execute-api.eu-central1.amazonaws.com/items/{id}
  Deleting An Item by ID
To delete an item from the database, we created a lambda function that is triggered by making a
DELETE request to the following API endpoint: https://4151wpvtqb.execute-api.eu-central1.amazonaws.com/items/{id}
  Getting Item Categories
To get all the item categories from the database, we created a lambda function that is triggered by
making a GET request to the following API endpoint: https://4151wpvtqb.execute-api.eu-central1.amazonaws.com/itemcategorys


# RekonObject Function
To decide the item category of an item, we created a lambda function that is triggered whenever an item
is put into the S3 Bucket called rekonimage. First, the function gets bucket name and key of the item
from the event header. Using those parameters, the function gets the image from S3 Bucket and then it
is sent to AWS Rekognition. AWS Rekognition returns the data that we can get the item category from.
Then, the function updates the item category in the database by sending update command with the table
name which is item_table and key which is S3 item key.

