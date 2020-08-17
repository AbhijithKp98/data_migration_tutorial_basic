# Postman_test
Repartition &amp; parallel Data ingestion

## Steps :
1. Click on this link :
https://community.cloud.databricks.com/?o=6506936770137036#notebook/539490126404107
   Login : abhijithkumarkp@gmail.com ( This role is for the Postman_team with limited permissions)
   password : Postman_team_20
Redircts you to a databricks notebook which contains the code & dependancies written.
2. Click on "Run all"
3. You will be able to see the sample results towards the end of the notebook

### Solution Architecture
   
   ![alt text](https://github.com/AbhijithKp98/Postman_test/blob/master/postman_test_architecture.png?raw=true)   

### Optional Additional steps:

1. Source data available in s3 (IAM role for s3 console access):-
   link: https://491526205224.signin.aws.amazon.com/console
   ID : postman_team;
   Password: postman_team_20

2. Target MPP DataWarehouse - SNOWFLAKE:
   link: yxa46258.us-east-1.snowflakecomputing.com/
   ID : postman_team
   Password: postman_team_20

### About the Data ingested to Snowflake:

##### i.   Database - Postman_DB
##### ii.  Schema - POC
##### iii. Data ingested Table - PRODUCTS (500k rows)
           primary key - sku
           clustered by - sku
##### iv.  Aggregated Table - AGG_TABLE (222,024 rows)
           An aggregated table on above rows with `name` and `no. of products` as the columns

Creating the product table in snowflake :
CREATE TABLE PRODUCTS ( NAME VARCHAR(), SKU VARCHAR() NOT NULL, DESCRIPTION VARCHAR(), PRIMARY KEY (SKU) ) CLUSTER BY (SKU))

### Points Achieved 
##### 1. Code Follows OOPS concepts 
   Used Classes to build the solution and modularized, so that end consumer can just run the query without any issues due to dependancy 
##### 2. Non - blocking parallel data ingestion into DB
   Snowflake - A Massively Parallel Processing Entreprise level Datawarehouse which supports parallel data ingestion.
   The data ingestion happens in less than 7 secs i.e., Spark dataframe to Table on Snowflake
   Note : Writing the csv from s3 stage to snowflake is further more efficient
#### 3. Support for updating existing products in the table based on `sku` as the primary key
   Created the table on Snowflake keeping SKU as both primary key & the cluster by key, 
   so that any DML operation is supported & is computationaly efficient
#### 4. All the product details are to be ingested into a single table on Snowflake - PRODUCTS 
#### 5. An aggregated table on above rows with `name` and `no. of products` as the columns
    The source data is loaded into a Spark dataframe & the aggregation is done on Spark.
    It is written directly into snowflake & it creates a table with specified name,
    automatically on the specified database & schema

#### Sample Output:
##### 1. Data Ingested in snowflake

   ![alt text](https://github.com/AbhijithKp98/Postman_test/blob/master/Ingested_data_SNOWFLAKE.png?raw=true)

##### 2. Aggregated table output

   ![alt text](https://github.com/AbhijithKp98/Postman_test/blob/master/Agg_tabl_op_SNOWFLAKE.png?raw=true)

#### Scope for Improvment  
   Implemented the solution in this architecture due to time & resource contraints
   Incase of additional time availability, Enhancements would be
###### 1. Architecture 
          The initial Architecture I came up was with these services :
          1. AWS S3 - Data Staging (home for csv file)
          2. AWS EMR - Compute Engine
          3. Airflow - Automating the process with this Orchestration tool & 
                       hosting it on AWS EC2
          4. AWS Redshift - Target DW
          5. Apache Spark - Distributed computing

###### 2. Secrets Manager for all the credentials
          Would have added the AWS KMS to manage all the credentials but Databricks Community edition doesn't support the same 
          (Workaround used :  creating an IAM role with limited access)
