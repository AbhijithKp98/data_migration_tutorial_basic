# Data Migration Tutorial 
Repartition &amp; parallel Data ingestion; Cloud services;

### Pre Requisties:

1. Consider source data is in a file system kinda storage (I used S3) : You'll need an AWS account (Free tier works)
2. Using an MPP to manage Big Data seamlessly. So the target MPP DataWarehouse - SNOWFLAKE (Free tier works)
3. Databricks account for running Spark jobs(

So this will project will help you migrate data from a normal file system-ish storage : AWS s3 to a Massively Parallel Processing DataWarehouse - Snowflake
Learnings: 
   - Touchbase on AWS services & using S3 for source data storage
   - Understand Parallel data ingestion
   - Usage of basic Spark command ( I've used Pyspark here )
   - Databricks - Hands on Cluster computing (It's free & very handy : Best part, you can run it on your mobile as well! yayyy)
   - Finally one of my Fav DataWarehouse - Snowflake 
   - Also some classes, data structures and not-so-shitty code :D 

## Steps :
1. Click on this link :
https://accounts.cloud.databricks.com/registration.html
Redircts you to the sign up page of databricks.
2. Set it up 
3. Install dependencies as mentioned in the code & run em : data_ingest_and_aggregate.py (https://github.com/AbhijithKp98/Postman_test/blob/master/data_ingest_and_aggregate.py)

### Solution Architecture
   
   ![alt text](https://github.com/AbhijithKp98/Postman_test/blob/master/images/postman_test_architecture.png?raw=true)   


### About the Data ingested to Snowflake:

##### i.   Database - Test_DB
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

   ![alt text](https://github.com/AbhijithKp98/Postman_test/blob/master/images/Ingested_data_SNOWFLAKE.png?raw=true)

##### 2. Aggregated table output

   ![alt text](https://github.com/AbhijithKp98/Postman_test/blob/master/images/Agg_tabl_op_SNOWFLAKE.png?raw=true)

#### Scope for Improvment  
   Implemented the solution in this architecture as I had time & resource contraints
   Incase of additional time availability, Enhancements would be
###### 1. Automate the process with Architecture that would consist of
          1. AWS S3 - Data Staging (home for csv file)
          2. AWS EMR - Compute Engine
          3. Airflow - Automating the process with this Orchestration tool & 
                       hosting it on AWS EC2
          4. AWS Redshift - Target DW
          5. Apache Spark - Distributed computing
          6. Deployment - Would package the Tasks & dependancies on Docker and host it on Kuberenetes.
  These architecture would make it an Enterprise level solution & pretty long term.  

###### 2. Secrets Manager for all the credentials
          Would have added the AWS KMS to manage all the credentials but Databricks Community edition doesn't support the same Tasks
          (Workaround used :  creating an IAM role with limited access)
