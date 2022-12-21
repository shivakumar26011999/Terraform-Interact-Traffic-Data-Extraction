import boto3
import pymysql
import os
import json


s3_client = boto3.client('s3')
rds_client = boto3.client('rds')
rds_endpoint = os.getenv('rdslink')
username = os.getenv('uname')
password = os.getenv('psd')
db_name = os.getenv('databasename')
conn = None

def rds_connect(bucket,json_file):
    try:
        conn = pymysql.connect(rds_endpoint, user=username,
                                passwd=password, db=db_name)
        print("success")
    except pymysql.MySQLError as e:
        print("ERROR: Unexpected error: Could not connect to MySQL instance.")

    cur = conn.cursor()
    cur.execute(
        "CREATE TABLE IF NOT EXISTS valuesignal(id varchar(100),area_name varchar(20), areatrn varchar(20), description varchar(100), date varchar(20), time varchar(20), pin varchar(6), temperature varchar(20), url varchar(255), primary key(id))")
    #cur.execute(
    #    "CREATE TABLE IF NOT EXISTS Url(id varchar(10), url varchar(255), foreign key(id) references Traffic_data(id))")
    print("table created")
    conn.commit()

    json_file_object = s3_client.get_object(Bucket=bucket, Key=json_file)
    json_file_reader = json_file_object['Body'].read()
    json_Dict = json.loads(json_file_reader)
    #json_Dict = json.loads(json_File_Reader)

    aid = json_Dict['Area_id']
    name = json_Dict['Name']
    temp = json_Dict['Temperature']
    trn = json_Dict['Trn']
    description = json_Dict['Description']
    date = json_Dict['Date']
    time = json_Dict['Time']
    pin = json_Dict['Pin']

    # code to store the data to the rds store
    cur.execute("INSERT INTO valuesignal (id, area_name, areatrn, description, date, time, pin, temperature) VALUES(%s, %s, %s, %s, %s, %s, %s, %s)",
                (aid, name, trn, description, date, time, pin, temp))
    print("data inserted")
    conn.commit()

def bucket_share(bucket,json_file):
    target_bucket = os.getenv('secondbucket') #"reverse-trigger"
    copy_source = {"Bucket": bucket, "Key": json_file}
    s3_client.copy_object(Bucket=target_bucket,
                            Key=json_file, CopySource=copy_source)
    print("image copied to other bucket")

def bucket_reverse_trigger(bucket, json_file):
    try:
        conn = pymysql.connect(rds_endpoint, user=username,
                                passwd=password, db=db_name)
        print("success")
    except pymysql.MySQLError as e:
        print("ERROR: Unexpected error: Could not connect to MySQL instance.")
    split_new = json_file.split(".")
    object_unique = split_new[0]
    
    location = s3_client.get_bucket_location(Bucket=bucket)['LocationConstraint']
    cur=conn.cursor()
    urll = "https://s3-%s.amazonaws.com/%s/%s" % (location,bucket,json_file)
    #cur.execute("INSERT INTO Url(id,url) values(%s, %s)",
    #             (object_unique, url))
    cur.execute("UPDATE valuesignal set url=%s WHERE id=%s", 
                   (urll,object_unique))
    print("url inserted")
    conn.commit()
    
    
    
def lambda_handler(event, context):
    # code to get the data from the json file
    bucket = event['Records'][0]['s3']['bucket']['name']
    json_file = event['Records'][0]['s3']['object']['key']
    split_list = json_file.split(".")
    print(event)
    
    if "jpg" in split_list and bucket==os.getenv('firstbucket'):
        bucket_share(bucket,json_file)
    elif "jpg" in split_list and bucket==os.getenv('secondbucket'):
        bucket_reverse_trigger(bucket,json_file)
    else:
        rds_connect(bucket,json_file)