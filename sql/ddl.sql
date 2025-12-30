DROP TABLE IF EXISTS readings_queue_mv;
DROP TABLE IF EXISTS readings_queue;
DROP TABLE IF EXISTS readings;



CREATE TABLE readings_queue (
id UInt32,
transaction_time DateTime,
merch String,
cat_id String,
amount Float64,
name_1 String,
name_2 String,
gender  String,
street  String,
one_city  String,
us_state  String,
post_code UInt64,
lat Float64,
lon Float64,
population_city UInt64,
jobs String,
merchant_lat Float64,
merchant_lon Float64,
target Int64
) ENGINE = Kafka SETTINGS 
kafka_broker_list = 'kafka:29092', 
kafka_topic_list = 'hw3_topic',
kafka_group_name = 'hw3_topic_group',
kafka_num_consumers = 1,
kafka_skip_broken_messages = 1, 
kafka_format = 'JSONEachRow'
;


CREATE TABLE readings ( 
id UInt32,
transaction_time DateTime,
merch String,
cat_id String,
amount Float64,
name_1 String,
name_2 String,
gender  String,
street  String,
one_city  String,
us_state  String,
post_code UInt64,
lat Float64,
lon Float64,
population_city UInt64,
jobs String,
merchant_lat Float64,
merchant_lon Float64,
target Int64
) Engine = MergeTree ORDER BY id
;


CREATE MATERIALIZED VIEW
readings_queue_mv to readings
as
select * from readings_queue;