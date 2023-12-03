import re
from unicodedata import normalize
import argparse
import logging
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, to_date, broadcast

logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s - %(levelname)s - %(message)s")

PROJECT_ID = 'retail-engine'
TMP_BUCKET = 'abinbev-tmp'
SQL_PATH = "sql/"
CREDENTIALS = ""
GCS_DEST = "gs://dest"

factor = None
parser = argparse.ArgumentParser()
parser.add_argument(
    "--factor",
    required=False)


def normalize_string(s):
    removed = normalize('NFKD', s).encode(
        'ASCII', 'ignore').decode('ASCII')
    removed = re.sub(r'[^\w\s]', ' ', removed)
    normalized_words = removed.split()
    normalized_string = '_'.join(normalized_words)
    return normalized_string.upper()


def main(factor):

    FILE_PATH_CHANNEL = (
        "/mnt/cifs_shared/source/abi_bus_case1_beverage_channel_group_20210726.csv")
    FILE_PATH_SALES = (
        f"/mnt/cifs_shared/source/{factor}x_sales")

    spark = SparkSession.builder.appName("Create stage") \
        .config("spark.hadoop.fs.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem") \
        .config("spark.hadoop.google.cloud.auth.service.account.json.keyfile", CREDENTIALS) \
        .getOrCreate()

    # NOTE: The files differ in encoding and delimiter
    channel = spark.read \
        .option("sep", ",") \
        .option("inferSchema", True) \
        .option("header", "true") \
        .option("encoding", "utf-8") \
        .option("multiline", "true") \
        .csv(f"{FILE_PATH_CHANNEL}")

    sales = spark.read \
        .option("basePath", f"{FILE_PATH_SALES}") \
        .option('sep', '\t') \
        .option("inferSchema", True) \
        .option('header', 'true') \
        .option('encoding', 'UTF-16') \
        .option('multiline', 'true') \
        .csv(f"{FILE_PATH_SALES}/*")

    stage = sales.join(broadcast(channel), on="TRADE_CHNL_DESC", how='left')

    # NOTE: The columns have spaces and special characters
    for column in stage.columns:
        stage = stage.withColumnRenamed(
            column, normalize_string(column))

    stage = stage.withColumn("DATE", to_date(col("DATE"), "M/d/yyyy"))

    stage.repartition("DATE") \
        .write \
        .format("csv") \
        .mode("overwrite") \
        .partitionBy("DATE") \
        .save(f"{GCS_DEST}")

if __name__ == "__main__":

    args = parser.parse_args()
    args_dict = vars(args)
    factor = args_dict.get('factor')
    main(factor)
