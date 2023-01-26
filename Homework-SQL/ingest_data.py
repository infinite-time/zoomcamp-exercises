import requests
import argparse
import gzip
import pandas as pd
from time import time
from sqlalchemy import create_engine

def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url

    csv_name = "output_green.csv"

    response = requests.get(url)
    file_content = gzip.decompress(response.content)
    with open(csv_name, "wb") as f:
        f.write(file_content)

    engine = create_engine(f"postgresql://{user}:{password}@localhost:{port}/{db}")

    df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)

    df = next(df_iter)

    df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

    df.head(n=0).to_sql(name=table_name , if_exists='replace', con=engine)

    df.to_sql(name=table_name, if_exists='append', con=engine)


    while True:
        t_start = time()
        
        df = next(df_iter)
        df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
        df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
        df.to_sql(name='green_taxi_trips', con=engine, if_exists='append')

        t_end = time()

        print('inserted another chunk, took %.3f second' % (t_end - t_start))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'Ingest csv data to progress')
    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='database name for postgres')
    parser.add_argument('--table_name', help='name of the table where we write the results to')
    parser.add_argument('--url', help='url of the csv file')

    args = parser.parse_args()

    main(args)
    
    

