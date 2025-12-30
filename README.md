# Kafka -> ClickHouse Transaction Analytics

## Описание

В рамках данного проекта реализован пайплайн загрузки данных из CSV-файла в Kafka и последующей обработки данных в ClickHouse.
Проект демонстрирует работу с Kafka, ClickHouse, написание SQL-запросов и оптимизацию хранения данных для ускорения аналитических запросов.

Данные используются из соревнования Kaggle:
https://www.kaggle.com/competitions/teta-ml-1-2025/data?select=train.csv

## Архитектура

### 1. Kafka Producer
- Загружает данные из CSV-файла `train.csv`
- Отправляет каждую строку CSV как отдельное JSON-сообщение в Kafka-топик `hw3_topic`

### 2. Kafka Infrastructure
- Автоматическое создание топика
- Сервис AKHQ для просмотра сообщений в Kafka

### 3. ClickHouse
- Таблица `readings` хранит данные для аналитических запросов
- Использование `LowCardinality(String)` для колонок с небольшим числом уникальных значений
- Партиционирование по месяцу
- Ключ сортировки `ORDER BY (us_state, amount)` для ускорения аналитических запросов

## Структура репозитория

```
hw3/
├── data/
│   └──                  		  # Данные
│
├── scripts/
│   └── load_kafka.py             # Python-скрипт загрузки CSV -> Kafka     
│
├── sql/
│   ├── ddl.sql                   # Базовый DDL 
│   ├── optimized_ddl.sql         # Оптимизированный DDL 
│   └── query.sql                 # SQL-запрос
│
├── docker-compose.yml             
├── requirements.txt               
└── README.md     
```                 

## Запуск

Требования:
- Docker 20.10+
- Docker Compose 2.0+
- Python 3.10+

Клонируем репозиторий:

```bash
git clone https://github.com/htutb/mts_mlops25_hw3
cd mts_mlops25_hw3
```

Запускаем инфраструктуру:
```bash
docker compose up -d
```

Создаем таблицы:

1) Базовая
```bash
docker exec -i clickhouse clickhouse-client -u click --password click < sql/ddl.sql
```

2) Оптимизированная
```bash
docker exec -i clickhouse clickhouse-client -u click --password click < sql/optimized_ddl.sql
```

!!! Поместите файл train.csv в папку data перед запуском скрипта !!!

Загружаем данные в Kafka
```bash
pip install -r requirements.txt
python3 scripts/load_kafka.py
```

Выполняем SQL-запрос с сохранением .csv
```bash
docker exec -i clickhouse clickhouse-client -u click --password click --query "$(cat sql/query.sql)" --format CSVWithNames > result.csv
```