class ETL:
    def __init__(self, s3_source, sfUrl, sfUser, sfPassword, sfDatabase, sfSchema, sfWarehouse):
        self.data_to_be_ingested=None
        self.create_agg_table
        self.s3_source = s3_source
        self.sfOptions = {
          "sfURL": sfUrl,
          "sfUser": sfUser,
          "sfPassword": sfPassword,
          "sfDatabase": sfDatabase,
          "sfSchema": sfSchema,
          "sfWarehouse": sfWarehouse,
          "parallelism": 8,
          "dbtable": ''
          }

    def data_ingest(self,table_name, write_mode):

        global path, SNOWFLAKE_SOURCE_NAME
        self.data_to_be_ingested = spark.read.csv(path+self.s3_source,
                                                  escape='"',
                                                  multiLine=True,
                                                  inferSchema=False,
                                                  header=True)
 
        self.sfOptions["dbtable"] = table_name
        self.data_to_be_ingested.write\
              .format(SNOWFLAKE_SOURCE_NAME)\
              .options(**self.sfOptions)\
          .mode(write_mode).save()
        return

    def create_agg_table(self, table_name, write_mode):

        global path, SNOWFLAKE_SOURCE_NAME
        self.create_agg_table = self.data_to_be_ingested.\
                                groupBy("name").count().\
                                withColumnRenamed("count", "product_count")

        self.sfOptions["dbtable"] = table_name
        self.create_agg_table.write\
              .format(SNOWFLAKE_SOURCE_NAME)\
              .options(**self.sfOptions)\
          .mode(write_mode).save()
        return
      
path = "dbfs:/mnt/aws_s3_postman/"
SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

data_setup = ETL("products.csv" , 'yxa46258.us-east-1.snowflakecomputing.com/','data_migration_tutorial','*********',"test_db",'POC',"COMPUTE_WH")
data_setup.data_ingest('products','overwrite')
data_setup.create_agg_table('agg_table','overwrite')
