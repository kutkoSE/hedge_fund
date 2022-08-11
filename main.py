import os
import traceback
import pandas_datareader as pdr
import datetime
import time
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')
from my_module_vps import *

from bot import send_to_telegram

def run():
    # --------------------    MAIN   CYCLE   CODE  main.py   ------------------------
    # V2 будет отличаться от V1 мультивалютностью нормальной !  
    # V3 добавил функцию anal = anal_table_v1(py_table) для расчета текущего профита
    # V4 Добавлена защита от краша, авторестарт через 10 секунд и сообщение в телеграм бот(надо тест) !
    # V5 Добавлена функция расчета лотов относительно волы активов по стратегиям с учетом зааднных риск параметров 
    # и сигнализиция в телеграмм

    # Инициализация
    # Обнулим значения для проверки длин данных, при старте скрипта
    # Возможно с введением маркера необходимость в проверке отпадет.
    if os.path.exists('tickers.csv'):
        tickers = pd.read_csv('tickers.csv', sep=';') #, index_col=0
        tickers.loc[:, 'len_h'] = 0
        tickers.loc[:, 'len_m'] = 0
        tickers.to_csv('tickers.csv', sep=';',index=False)

    marker = pd.DataFrame(columns=['quotes_ready','py_table_ready'])
    marker.loc[0] = [0,0]


    i = 1
    while True:
        # Нужно дождаться 1 в quotes_ready в marker.dat идем дальше

    #     marker = pd.read_csv('marker.dat', sep=';')  # ,index_col=0
        try:
            marker_read = pd.read_csv('marker.dat',sep=';')  # ,index_col=0
        #except pd.io.common.EmptyDataError:
        except:
            print('marker ошибка чтения ')       
        if (marker_read.shape[0] == 1):
            marker = marker_read            
        quotes_ready = marker.loc[0, "quotes_ready"]

        print('marker.quotes_ready = ', quotes_ready)
        while (quotes_ready != 1):
            time.sleep(0.5) # Ебанутость исправлена! пауза вначале, потом чтение и сразу проверка !

            try:
                marker_read = pd.read_csv('marker.dat',sep=';')  # ,index_col=0
            #except pd.io.common.EmptyDataError:
            except:
                print('marker ошибка чтения ')       
            if (marker_read.shape[0] == 1):
                marker = marker_read 
            quotes_ready = marker.loc[0, "quotes_ready"]


        print('marker.quotes_ready = ', quotes_ready)

        ftime = time.time()  # Засекаем время
        tickers, strategy, py_table = strategy_cycle_v6()
        endtime = time.time() - ftime # Конец засекаемого времени

        # ставим флаг py_table_ready в 1-цу  (quotes_ready в 0) в marker.dat
        marker.loc[0, "py_table_ready"] = 1
        marker.loc[0, "quotes_ready"] = 0
        marker = marker.astype(np.int64) # Перевод всех значений в int. Работает !
        marker.to_csv('marker.dat', sep=';', index=False)
        #Для отладки

        print('CYCLE = ',i," Время цикла=",round(endtime,4)," секунд")

        # Счетчик циклов
        i = i + 1

        # Тут уже можно писать дополнительные вычисления, которые не будут тормозить скорость передачи данных в lua

        # Таблица с профитами
        anal = anal_table_v1(py_table)
        anal.to_csv('anal.csv', sep=';', index=False)
        print(anal)
        
        # Перерасчет лотов в стратегиях
        curr_date_time = datetime.datetime.now()
        # c 19:01 до 19:10 по Москве или с 21:01 по 21:10 по Перми Как раз после апдейта баланса.
        if (curr_date_time.hour >= 19) and (curr_date_time.hour < 20) and (curr_date_time.minute >= 1) and (curr_date_time.minute <= 10): 
            change_lots_risk_managment()
        #change_lots_risk_managment()
        time.sleep(1) #Задержка в секундах, сколько надо ставить ? ?

    # Предлагаю все сделки записывать в один csv супер лог файл. Сделки пишут уже lua в trades_py.dat
    # Продумать как вести анализ сделок.

def write_error(err, file='errors.txt'):
    now = datetime.datetime.now()
    str_now = now.strftime('%Y-%m-%d %H:%M:%S')
    
    sep = '----'*30
    text = f'{str_now}\n{sep}\n{err}\n{sep}\n\n\n\n'
    
    with open(file, 'a') as f:
        f.write(text)
        
def start():
    try:
        run()
    except Exception as err:
        track = traceback.format_exc()
        print(track) # печать ошибки надо добавить в файл с датой временем и предыдущие не затирать.
        write_error(track)
        send_to_telegram('упал')
        
        time.sleep(10)
        start() 

start()
