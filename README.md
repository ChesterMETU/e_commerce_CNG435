# e_commerce_CNG495
This capstone project is made for CNG495 cloud computing course at METU NCC.
# Introduction
This project aims to create an e-commerce application where users can conveniently list their products
by adding new items. AWS Cognito manages the authentications of each user and customer. Customers
can search and add products to their cart. Payment microservice is not included in this project.
This application solves the problem that is faced during listing. It can be listed as wrongly categorized
due to human error. Our application eliminates this problem by automatically choosing the category for
the product based on its image.
To achieve this, the application utilizes image recognition technology from Amazon Rekognition. When
users upload an image to add a new item, Amazon Rekognition automatically identifies the object and
selects the category for the product. This functionality streamlines the process of filling in item details
by automatically populating certain fields based on previously configured specifications of the
identified object
# Folder Structure
In the documents folder, you can find all the report 
You can find all the Lambda's implemented for the project's backend in the server folder.
In the UI folder, you can find our mobile application code.
