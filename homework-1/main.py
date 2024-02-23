"""Скрипт для заполнения данными таблиц в БД Postgres."""
import csv
import psycopg2

path = ['north_data/customers_data.csv', 'north_data/employees_data.csv', 'north_data/orders_data.csv']
for pat in path:
    with open(pat, newline='', encoding='utf-8') as csvfile:
        file_reader = csv.reader(csvfile, delimiter=",")
        data_csv = []
        total = 0
        count = 0
        for row in file_reader:
            if total == 0:
                for q in row:
                    count += 1

            else:
                data_csv.append(tuple(row))
            total += 1

    conn = psycopg2.connect(host='localhost', database='north', user='postgres', password='1111')
    cur = conn.cursor()
    if count == 3:
        cur.executemany("INSERT INTO customers VALUES(%s,%s,%s)", data_csv)
        cur.execute("SELECT * FROM customers ")
        conn.commit()
    if count == 6:
        cur.executemany("INSERT INTO employees VALUES(%s,%s,%s,%s,%s,%s)", data_csv)
        cur.execute("SELECT * FROM employees ")
        conn.commit()
    if count == 5:
        cur.executemany("INSERT INTO orders VALUES(%s,%s,%s,%s,%s)", data_csv)
        cur.execute("SELECT * FROM orders ")
        conn.commit()

    rows = cur.fetchall()
    for i in rows:
        pass
        # print(i)

    cur.close()
    conn.close()