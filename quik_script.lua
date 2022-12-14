--Для Forts Это скрипт на Lua: 
--Lua Выдает Python читает:
---Файлы с котировками H1, (M1 для микровхода)   Si, Ri,…
---Файл со средней ценой последней реализации позиции каждого актива и временем/датой завершения сделки.

--Python Выдает, Lua Читает:
---Файл с количеством требуемой текущей позиции по каждому активу количество контрактов и с ценой(микровход) для заявки на каждый актив. Цену на микрохвод нужно писать регулярно каждую минуту.

--Программа исполнения и контроля ордеров:
--1) выставляет кумулятивную позицию по каждому активу c указанной ценой
--2) следит за исполнением ордера, после исполнения возвращает среднюю цену исполнения с датой исполнения ? Каждый период когда были сделки

--АЛГОРИТМ
--1) Создаем таблицу
--Столбцы:  |  ТИКЕР |  ТЕКУЩАЯ ПОЗИЦИЯ   |  УСТАВКА ТЕКУЩЕЙ ПОЗ ИЗ Python  | BUY_PRICE |  SELL_PRICE |  Close_H1[1]  | Close_H1[0]  |   Close_M1[1]  | Close_M1[0]  | 
--2) Считываем данные из файла от Python По торгуемым активам и требуемому значению контрактов, BUY_PRICE и SELL_PRICE, заносим в таблицу.
--3) По требуемым активам(из файла от Python) заносим котировки в файлы с именами активов часовые и минутные и делаем это раз в минуту( И часовые тоже)в котировках напротив цены обязательно время для дальнейшей коррекции в PYTHON.
--4) Снимаем активные заявки из предыдущего цикла. Пауза. Проверяем баланс и заносим в таблицу. Покупаем/ продаем по указанным ценам от PYTHON В зависимости от текущего баланса и заданной уставки от PYTHON.
--5) Устанавливает(снимает не актуальные) защитные стоп-ордера на расстоянии исходя из волатильности актива, рассчитанное по стандартному отклонению.
--6) При наступлении новой минуты, цикл повторяется с пункта 2

--Структура таблицы !!! Строки по активам
--Столбцы:  |  ТИКЕР |  ТЕКУЩАЯ ПОЗИЦИЯ   |  УСТАВКА ТЕКУЩЕЙ ПОЗ ИЗ Python  | BUY_PRICE |  SELL_PRICE | Close_H1[1]  | Close_H1[0]  |  Close_M1[1]  | Close_M1[0]  |
--Столбцы:  |  Ticker|  Current_Position  |  Set_Position                   | BUY_PRICE |  SELL_PRICE | Close_H1     | Close_H0     |  Close_M1     | Close_M0     |

--КАК НАСТРОИТЬ ТЕРМИНАЛ !!!
-- Нужно поставить метку на минутном графике цены Si "Si_m", на часовом графике соответсвенно метку "Si_h" и количество свече на графике не должно быть меньше num_candles, ставить 10000.

--Все лежит в папке на виртуальном диске винды С:\\lua_vps\

--в v4 добавил  запись таблицы сделок в таблиц csv,  сделки постоянно дописываются, если они отличаются по времени в большую сторону от предыдущих
--в v5 фиксим таблицу, она как-то неправильно отображает данные, переход только на минутки и надо бы ещё функцию сделать считывания котировок (Функцию пока не сделал !) остальное готово
--     Основное это то что цены на покупку и продажу передаются в текстовом виде, соответсвенно в таблице тип переменно поправлен на текстовый.
--в v6    Переходим на нормальную мультивалютность и делаем сохранение котировок функцией и в цикле по массиву. Что-то ещё ? Посмотрим что ещё добавить.
--в v6_1  Доработано в части записи сделок, доп условие по  trade_num при совпадении времени сделок и запись value - объем в деньгах (для  RTS в рублях уже) умножено на лоты.


dofile (getScriptPath() .. "\\func.lua") --ХЗ, навернео это от родного каталога идет отсчет, да так и есть. Вот бы и остальные также суметь

local bit = require("bit")

do_main=true

function OnStop()
   -- данная функция вызывается при нажатии кнопки остановить  
   do_main=false     
   
   DestroyTable(t_id1)  --закрытие таблицы при остановке скрипта     
end

function OnInit()

--инициализируем здесь глобальные переменные/константы
	Prev_min = 120 --чтобы полюбому сразу запускалось new_interval() А ниже сделаем условие, чтобы не запускалось, а ждало начала новой минуты
	Num      = 10
	TRANS_ID = 0     --FUNC PLACE_ORDER	  НУЖНО используется в функции SEND_ORDER_V3, хз зачем может бы тьпотом переписать её и переделать.
	
--ВНИМАНИЕ !!! Для путей ХОТЕЛОСЬ БЫ ПРОПИСАТЬ КАКОЙ-НИБУДЬ каталог чтобы не было кучи бепорядочных файлов в одной куче.!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

--Исходные данные 
	--Path_Table  = "d:\\Forts\Lua\My_projects\table_tr.dat" --хз не пашет
	Path_Table  = "\\lua_vps\\table_py.dat"    --Основная таблица --Столбцы:  |  Ticker|  Current_Position  |  Set_Position                   | BUY_PRICE |  SELL_PRICE | Close_H1     | Close_H0     |  Close_M1     | Close_M0     |
	Path_marker = "\\lua_vps\\marker.dat"      --файл marker(quotes_ready,py_table_ready)	
	
--v5	Path_Si_m   = "\\lua_vps\\Si_m.dat"        --Файл с минуткными котировками, с графика quik
--v5	Path_RI_m   = "\\lua_vps\\RI_m.dat"        --Файл с минуткными котировками, с графика quik

--v5	Si_m_label  = "Si_m"              --Метка на минутном графике в quik для цены
--v5	RI_m_label  = "RI_m"              --Метка на минутном графике в quik для цены
	
	quotes = {"Si_m","RI_m","SR_m","MM_m","GZ_m"}  -- Имена тикеров на графиках (метки на графиках quik эти же имена у файлов с котровками .dat), в том же порядке в каком и таблица py_table.dat и из не и формируется основная Lua таблица  table_py.dat
	Path_quotes    = "\\lua_vps\\quotes\\"     --Путь куда будут сохраняться котировки, все папки предвартельно необходимо создать.		
	
	Path_py_table  = "\\lua_vps\\py_table.dat" --Только чтение, таблица с информацией от PYTHON Столбцы: |  Ticker | Set_Position | BUY_PRICE |  SELL_PRICE |
	Path_trades_py = "\\lua_vps\\trades_py.csv"--Файл копия информации из таблицы сделок для анализа в PYTHON, в который постоянно дозаписываются только новые исполненные заявки
	Path_Log    = "\\lua_vps\\log.txt"
	Path_Log_Bal= "\\lua_vps\\log_balance.txt"
	Path_Log_Tbl= "\\lua_vps\\log_table.txt"
	--ACCOUNT     = "SPBFUT0037W"
	ACCOUNT     = "410037W"
	CLIENT_CODE = ""          --это коммент к сделке
	MARKET      = "SPBFUT"    --Рынок срочный, фьючерсы
--v4 уже нах не нужен тут т.к. имена тикеров прилетают из питона  TICKER      = "SiM9"      --рубль/бакс фьюч СУКА УЕБАН БЛЯТЬ ПРАВИЛЬНО ТИКЕР НАДО ПИСАТЬ !!! TICKER      = "SiU5" "SiZ5" "SiH6" "SiM9"
	num_candles   = 4000      --количество свечей, запрашиваемое с графика

--Присвоим начальные значения в таблицу---------ЕСЛИ ТАБЛИЦЫ НЕТУ !!! 
	Init_Table_if_not_exist_Python_v1() 
-- считаем таблицу, если она была
	t = table.read(Path_Table) 	
--Создание таблицы и вывод ее на экран из считанной из файла	
	Create_Table_on_screen_Python_v1()  	
	
	Cycle = 0 --Счетчик циклов с момента старта скрипта	
	Log_Balance_flag = 3000
end

function main() --Разрешать работу этого цикла только на время торгов с 9:55 до 23:55
	while do_main do
   
		if (isConnected()==1 and getInfoParam("SERVERTIME")~="" ) then  --Условия запуска скрипта по времени и т.д. и по соединению
      
		Time_tst = tostring(getInfoParam("SERVERTIME")) --HH:MM:SS

		--message(" ServerTime "..getInfoParam("SERVERTIME").." LEN= "..string.len(Time_tst),1)    --Отладка   
		-- !!! Если часов меньше 10 значит тратится один знак, поэтому необходимо смещение иначе жопа, а если больше то Time_shift = 1
		Time_shift = 0 
			if(string.len(Time_tst) == 7) then Time_shift = 0 end
			if(string.len(Time_tst) == 8) then Time_shift = 1 end

		Current_hour = tonumber(string.sub(Time_tst, 1           , 1+Time_shift)) + 0
		Current_min  = tonumber(string.sub(Time_tst, 3+Time_shift, 4+Time_shift)) + 0
		Current_sec  = tonumber(string.sub(Time_tst, 6+Time_shift, 7+Time_shift)) + 0
		--message(" Sec "..Current_sec.." Min "..Current_min.. " Hour "..Current_hour,1)    --Отладка

			--Идея весь цикл запускать только во время торгов и не более
			--!!! ВНИМАНИЕ !!! ДУМАЮ НУЖНО ДОБАВИТЬ ЕЩЁ КЛИРИНГ ВЕЧЕРНИЙ с 18:45 до 19:00 по МСК вроде !!!
			if( ( Current_hour <= 23 ) and ( (( Current_hour == 7 ) and (Current_min >= 0)) or ( Current_hour >= 8 ) ) )then   
			--message(" Sec "..Current_sec.." Min "..Current_min.. " Hour "..Current_hour,1)    --Отладка
			
			---------------------------------------НАДО ПЕРЕДЕЛАТЬ --------------- ЧАЩЕ ЗАПУСКАТЬ ВЕСЬ СУПЕРЦИКЛ.---ВАЩЕ УБРАТЬ УСЛОВИЕ ЗАПУСКАТЬ КАЖДУЮ МИНУТУ !!!!
			---- НЕТ надо запускать каждую минуту(НАПРИМЕР ТОЛЬКО 4) ПУНКТ), чтобы заявка при микровходе стояла минуту, а чаще можно только читать данные из таблицы, либо каждую минуту только торговый цикл запускать ?
				--if ( Current_min ~= Prev_min ) then --Запускается каждую новую минуту 1 раз !	Может быть отставание на минуту, т.к. отировки ещё не загрузились и питон не отработал их !!!			
					--Вот здесь все этапы, которые в цикле должны быть.

					--3) По требуемым активам(из файла от Python) заносим котировки в файлы с именами активов часовые и минутные и делаем это раз в минуту( И часовые тоже)в котировках напротив цены обязательно время для дальнейшей коррекции в PYTHON.
						--пока думаю просто тупо Si, Ri и т.д. гнать и не париться, хотя бы Si для начала. 
						--20200122 Отлажено, работает, потом переписать в виде функции для компактности.
						
--СДЕЛАТЬ ЗАПИСЬ ДАННЫХ С ПЕРЕДАЧЕЙ МАРКЕРА ПИТОНУ и тот берет маркер только на время считывания. так бороться с коллизиями.
-- Ну и предлагается делать это раз в минуту при наступлении новой минуты, 
-- при этом уточнить на сколько точно будут передаваться данные последней свечи(для этого нужно определить из масиива время послденей свечи, чтобы он совпадало с предыдущей минутой)
-- При наступлении новой минуты, брать маркер себе и выждать паузу например 500 - 1000 мс и только потом делать запись данных в котировки.
-- Предлагаю ещё записывать в маркер после окончания записи данных дополнительно и время последней действующей минуты, т.н. Prev_min для последуюей обработки в python.
-- После этого, по маркеру запускается питон-цикл, после считывания данных и всех расчетов записывает новый маркер для запуска в Lua считывания расчитанных данных от питона и выставления/перевыставления заявок
-- Тут ещё с часовиками усложняется нужно одельное время на часовую свечку слать, чтобы не было сдвига, поэтому есть предложение сразу преейти на 1-минутковые варианты систем и осчитывать последовательно часовики.

-- файл marker(quotes_ready,py_table_ready)
--Итак аклоритм такой
--11) Скрипт Lua ждет наступления новой минуты и записываем котировки в файл и ставим флаг quotes_ready в 1-цу 
	-- а что мешает сделать проверку здесь ? НИЧЕГО ! минута последней котировки не должна быть равна Current_min, если равна то её не шлём .
--22) Python-скрипт дождавшись 1 в quotes_ready, считывает котировки(ставим флаг quotes_ready в 0 тут в идеале, или потом после расчетов) и 
	--запускает расчеты, и производит запись расчитанных данных в файл  py_table.dat, и ставит флаг py_table_ready в 1-цу  (quotes_ready в 0)
--33) Скрипт Lua ждет py_table_ready в 1 и после этого считывает данные из py_table, записывает все нули в маркер py_table_ready далее запускается цикл выставления/снятия заявок 
	

					--if ( ( Current_min ~= Prev_min ) and ( Prev_min ~= 120 ) ) then --Запускается каждую новую минуту 1 раз !	Может быть отставание на минуту, т.к. отировки ещё не загрузились и питон не отработал их !!!	Это поправил в алгоритме и сделал проверку ниже		НИХУЯ НЕ ПАШЕТ !!! условие ~=120
					if ( Current_min ~= Prev_min ) then --Запускается каждую новую минуту 1 раз !	Может быть отставание на минуту, т.к. котировки ещё не загрузились и питон не отработал их !!!	
					
						-- Все тикеры закинуть из массива выщелкиваются по ходу цикла						
						for i = 1, #quotes do     --Перебор всех наименований тикеров в массиве quotes
							--message(i.." quotes i =  "..quotes[i],1) --Отладка
							Close_M0,Close_M1 = write_quotes(quotes[i], num_candles,Path_quotes..quotes[i]..".dat" )
							t.Close_M0[i]  =  Close_M0  --текущее значение, динамически меняется - последняя минута на графике
							t.Close_M1[i]  =  Close_M1  --предыдущее значение, не меняется  - предпоследняя полностью завершенная	
						end

----------------------------------------------END DATA QUOTES FROM QUIK ---------------------------------------------
						sleep(100) -- Для подстраховки, пусть данные запишутся до конца, а то мало ли что
					-- Запись файл marker(quotes_ready,py_table_ready) ставим флаг quotes_ready в 1-цу 
						file = io.open(Path_marker,"w")								
						file:write("quotes_ready",";","py_table_ready","\n")		
						file:write(string.format("%s;%s",1,0),"\n")									
						file:close()						
						
						--22) Python-скрипт дождавшись 1 в quotes_ready, считывает котировки(ставим флаг quotes_ready в 0 тут в идеале, или потом после расчетов) и 
						--запускает расчеты, и производит запись расчитанных данных в файл  py_table.dat, и ставит флаг py_table_ready в 1-цу  (quotes_ready в 0)
						-- засыпаем на 1 секунду или любое другое время
						
						--33) Скрипт Lua ждет py_table_ready в 1 и после этого считывает данные из py_table, записывает все нули в маркер py_table_ready далее запускается цикл выставления/снятия заявок 
						
						quotes_ready, py_table_ready = File_Read(Path_marker) -- через жопу и с хуем пополам, но поборол. Данные доступны так quotes_ready[1] py_table_ready[1]
						--
						while tonumber(py_table_ready[1]) ~= 1+0 do
						--if (py_table_ready[1] ~= 1) then
							sleep(500)	
							quotes_ready, py_table_ready = File_Read(Path_marker) 
							--message("IN WHILE Cycle = "..Cycle.." quotes_ready = "..quotes_ready[1].." py_table_ready = "..py_table_ready[1],1)    --Отладка
						end
						
						message(" OUT WHILE Cycle = "..Cycle.." quotes_ready = "..quotes_ready[1].." py_table_ready = "..py_table_ready[1],1)    --Отладка
						--Cчитываем данные из py_table
						
						-- Запись файл marker(quotes_ready,py_table_ready) ставим флаг py_table_ready в 0, после того как мы его считали. 
						-- А quotes_ready д.б. 0 после Pythona запишем то что считали
						file = io.open(Path_marker,"w")								
						file:write("quotes_ready",";","py_table_ready","\n")		
						file:write(string.format("%s;%s",0,0),"\n")									
						file:close()
						
						--sleep(1500)
						--Операцию считывания py_table, либо осуществить её, только после того как будут выданы файлы вообще.
						--тогда зажержку цикла целесообразно сюда и перенести, за время этой зажержки должен успеть прокрутиться цикл программы на python
					--2) Считываем данные из файла от Python По торгуемым активам и требуемому значению контрактов, BUY_PRICE и SELL_PRICE, заносим в таблицу t.И тут же определяем надо ли обновлять заявку и снимать ордер ? или потом ?					
						py_table = table.read(Path_py_table) --Формат таблицы такой --|  Ticker|  Set_Position  | BUY_PRICE |  SELL_PRICE |						
						for i = 1, #py_table.Ticker do -- Нужно вычислить количество строк и сделать цикл до него
							t.Ticker[i]        = py_table.Ticker[i]       
							t.Set_Position[i]  = py_table.Set_Position[i] 
							t.BUY_PRICE[i]     = py_table.BUY_PRICE[i]     
							t.SELL_PRICE[i]	   = py_table.SELL_PRICE[i]    					
						end
										
					
					--4) Снимаем активные заявки из предыдущего цикла. Пауза. Проверяем баланс и заносим в таблицу. Покупаем/ продаем по указанным ценам от PYTHON В зависимости от текущего баланса и заданной уставки от PYTHON.
						KILL_ALL_ORDERS() --снимает все активные заявки !!! пашет !!! --REAL_TRADE - откомментить 	
						--ДАДАДА !!!! Потом можно доработать и не снимать те заявки которые по уровню цены соответсвуют новому уровню. и по количеству лотов совпадает !!!
						sleep(1500)	      --Может сделать и побольше (было 500)
						--Столбцы таблицы t:  |  Ticker|  Current_Position  |  Set_Position |BUY_PRICE |  SELL_PRICE |  Close_H1  | Close_H0  |  Close_M1  | Close_M0 |						
						--Проверяем баланс и заносим в таблицу.
						
						--Вначале определим перебором Current_Position, а потом в случае несоответсвия запустим цикл
						if getNumberOf("futures_client_holding") > 0 then --А если мы начинаем и у нас вообще там нет ?
							for i = 1, getNumberOf("futures_client_holding") do     --Перебор всех инструментов в таблице "Позиции по клиентским счетам FORTS"
								for j = 1, #py_table.Ticker do                      --перебор всех тикеров	из py_table.Ticker[i]
									if getItem("futures_client_holding",i-1).sec_code == py_table.Ticker[j] then    --Проверка на соответствие инструмента
										t.Current_Position[j] = getItem("futures_client_holding",i-1).totalnet      --Присваиваем Текущие чистые позиции по совпавшему инструменту --был ноль заменил на i-1										
									end
								end
							end
						end
						
						--Теперь в цикле преребираем t.Current_Position[j] ~= t.Set_Position[j] в случае несоответсвия торгуем.
						
						for j = 1, #py_table.Ticker do                      --перебор всех тикеров	из py_table.Ticker[i]													
							if (t.Current_Position[j] ~= t.Set_Position[j]) then							
										--(TICKER_,BUY_PRICE,SELL_PRICE,QUANTITY) --работает на входе числа делаем +0 иначе не фурычет, потом все-равно тустринг идет
											SEND_ORDER_V3(py_table.Ticker[j],t.BUY_PRICE[j],t.SELL_PRICE[j],t.Set_Position[j] - t.Current_Position[j]) --Не тестировал, но надеюсь на успех
											message(" Ticker "..py_table.Ticker[j].." BUY_PRICE "..t.BUY_PRICE[j].." SELL_PRICE "..t.SELL_PRICE[j].." QTY "..t.Set_Position[j] - t.Current_Position[j],1)    --Отладка	
											--sleep(3500)--ждем пока устаканится заявка и лимиты отыграют(ПОТОМ ПРИ БОЛШОМ КОЛИЧЕСТВЕ ИНСТРУМЕНТОВ НАДО ПЕРЕДЕЛАТЬ иначе слишком долго можно ждать)
							end
						end
						Prev_min = Current_min
					end		
					
					
					--5) ПОКА МОЖНО НЕ ДЕЛАТЬ. Запускается при выровненом балансе(все заявки уже отыграли) Устанавливает(снимает не актуальные) защитные стоп-ордера на расстоянии исходя из волатильности актива, рассчитанное по стандартному отклонению.
						--Условие, что баланс отыграли,поэтому переписываем таблицу сделок в файл, для дальнейшего анализа в PYTHON
						Flag_done = 0
						for i = 1, Num do								
							if (t.Set_Position[i] ~= t.Current_Position[i]) then 
							Flag_done = 1
							end  					
						end
						if Flag_done == 1 then -- Если есть какое-то неравенство значит выше по алгоритму были выставлены заявки и надо чтобы лимиты отыграли.
							sleep(500)-- 3500 ждем пока устаканится заявка и лимиты отыграют, хм, зачем ? ну ладно, чтобы повторную не ляпнуть подряд
						end
						
						if Flag_done == 0 then --переписываем таблицу сделок в файл, для дальнейшего анализа в PYTHON, когда все заявки исполнены.
						--Здесь в закинем информацию из таблицы сделок в файл	
						
						-- Предлагаю доработать, каждую новую сделку ДОписывать в файл, т.о. нужно проверять записаны данные уже или нет ?
						-- переписываемая заявка должна быть уже неактивна (проверка нулевого бита он должен быть равен нулю), или переписывать заявки в конце торговой сессии
						-- Предлагается дополнительно записывать сразу значение покупки / продажи выделив бит
						-- Нужно делать проверку по времени записанной последней заявки и записывать только те которые старше по времени/дате.
						-- Когда записывать ? это вопрос
						-- При инициализации предлагается считать из файла сделок время/дату последней заявки, и хранить в переменной, а потом сравнивать с ней 
						-- Даты/время заявок из таблицы заявок чтобы дозаписать их в таблицу.
					
							-- РАБОТАЕТ !!!!!!
							-- КОГДА-НИБУДЬ ПЕРЕДЕЛАТЬ !!! ТИПА СРАЗУ В ПОСЛЕДЮЮ СТРОКУ file:seek("end",-7) ЧТОБЫ НЕ ПЕРЕБИРАТЬ ВСЁ
							-- пока идет обработка всех строк файла
							-- Ввести проверку на наличие файла. Введено !!!
							-- Также нужно наверное ввести синхронизацию с маркером, возможно уже после того как python ответит, чтобы не замедлять реакцию.
								

							-- НАЧАЛО ЗАПИСИ ЗАЯВОК ИЗ ТАБЛИЦЫ СДЕЛОК В ФАЙЛ v6_1----------------------------------------------------------------------
							-- Найдем последнее значение в таблице сделок значение Last_Line_DateTime
							Last_Line_DateTime = "0" -- инициализация
							Last_trade_num = "0" -- инициализация
							if io.open(Path_trades_py,"r") == nil  then --Если файла ещё нет, то мы создадим его и запишем заголовок
								file = io.open(Path_trades_py,"w")
								file:write("trade_num",";","sec_code",";","date",";","time",";","price",";","flags",";","operation",";","qty",";","value","\n") --Если файла нет, то запишем в него такой заголовок.
								file:close()
							else 			
								for line in io.lines(Path_trades_py) do 	
								last_line = line
								end
								--Если таблица сделок пустая то выдает ошибку, проверку на nil ?
								if last_line ~= nil then
									myTable = last_line:split(";") --Преобразование из строки с разделителями в таблицу lua
									-- myTable[3] ГГГГММДД
									-- myTable[4] ЧЧ:ММ:СС
									if myTable[4] ~= nil then
										START_TIME = myTable[4]:split(":")
										if ( START_TIME[1] ~= nil ) and ( START_TIME[2] ~= nil ) and ( START_TIME[3] ~= nil ) then
											TIME = START_TIME[1]..START_TIME[2]..START_TIME[3]
											Last_Line_DateTime = myTable[3]..TIME
										end
									end
									if myTable[1] ~= nil then
										Last_trade_num = myTable[1]
									end
								end
							end
							-- В Last_Line_DateTime  последняя строка с датой/временем из файла
							--message(" Last_trade_num "..Last_trade_num,1)    --Отладка
							-- РАБОТАЕТ !!!!!!
							
							file = io.open(Path_trades_py,"a")
							for i = 0, getNumberOf("trades")-1 do --Перебор всех сделок в "Таблице сделок" !!!
								if not CheckBit(getItem("trades",i).flags,0) then   -- Проверка активная заявка или нет ! Работаем только с неактивными, когда сделка закрылась до конца.
								--Нужно ещё как-то учитывать снятые заявки, если фильтр таблицы заявок это делает, то хорошо !!!
								--ТЫ ЧО ВАСССЕ ПАПУТАЛ В НАТУРЕ !?!? Это таблица сделок, а не заявок !!!
									if CheckBit(getItem("trades",i).flags,2) then   -- Определяем покупка или продажа.
										operation =-1
									else
										operation = 1
									end
									-- Найдем текущее значение Curr_Line_DateTime
									Curr_Line_DateTime = string.format("%04d%02d%02d%02d%02d%02d",getItem("trades",i).datetime.year,getItem("trades",i).datetime.month,getItem("trades",i).datetime.day,getItem("trades",i).datetime.hour,getItem("trades",i).datetime.min,getItem("trades",i).datetime.sec)			
									-- Нужно потом добавить ещё такую проверку, если время одинаковое, а тикеры разные то тоже переписывать
									-- Ну и ваще то если время одинаковое и тикеры одинаковые тоже как-то надо разрулить по id видимо ? Надо добавить условие ! trade_num Номер сделки в торговой системе
									-- Нужно ещё скачивать и объем ! т.к. для RTS и других аналогичных контрактов оно в рублях будет ! капец ! )))
									-- Всё это добавлено !!!
									if (tonumber(Last_Line_DateTime) < tonumber(Curr_Line_DateTime)) or ( (tonumber(Last_Line_DateTime) == tonumber(Curr_Line_DateTime)) and (tonumber(Last_trade_num) < tonumber(getItem("trades",i).trade_num)) ) then 
										file:write(string.format("%s;%s;%04d%02d%02d;%02d:%02d:%02d;%s;%s;%s;%s;%s",getItem("trades",i).trade_num,getItem("trades",i).sec_code,getItem("trades",i).datetime.year,getItem("trades",i).datetime.month,getItem("trades",i).datetime.day,getItem("trades",i).datetime.hour,getItem("trades",i).datetime.min,getItem("trades",i).datetime.sec,getItem("trades",i).price,getItem("trades",i).flags,operation,getItem("trades",i).qty,getItem("trades",i).value),"\n")				
									end
								end	
							end
							file:close()							
							-- КОНЕЦ ЗАПИСИ ЗАЯВОК ИЗ ТАБЛИЦЫ СДЕЛОК В ФАЙЛ v6_1--------------------------------------------------------------------------- 	

							
						end
						  --ВНИМАНИЕ !!! ЗДЕСЬ ДОБАВИТЬ КУПЛЯ ИЛИ ПРОДАЖА СТОЛБЦ !!! А ТО НЕ ПОНЯТНО НИЧЕГО.	ДОБАВИЛ !!!
						  -- Набор битовых флагов  (NUMBER) flags в столбце "operation", в итоге потом в обработке нам нужно выделять бит 2, это будет покупка или продажа, вот так через жопу.
						  -- бит 0 (0x1)    Заявка активна, иначе – не активна  
						  -- бит 1 (0x2)    Заявка снята. Если флаг не установлен и значение бита «0» равно «0», то заявка исполнена  
						  -- бит 2 (0x4)    Заявка на продажу - 1, иначе – на покупку - "0". Данный флаг для сделок и сделок для исполнения определяет направление сделки (BUY/SELL)  
						  -- бит 3 (0x8)    Заявка лимитированная, иначе – рыночная  
						  -- бит 4 (0x10)   Разрешить / запретить сделки по разным ценам  
						  -- бит 5 (0x20)   Исполнить заявку немедленно или снять (FILL OR KILL)  
						  -- бит 6 (0x40)   Заявка маркет-мейкера. Для адресных заявок – заявка отправлена контрагенту  
						  -- бит 7 (0x80)   Для адресных заявок – заявка получена от контрагента  
						  -- бит 8 (0x100)  Снять остаток  
						  -- бит 9 (0x200)  Айсберг-заявка 
						  
						-- Вертушка цикла			
						if (Cycle % 2 == 1) then
							t.Ticker[10] = Cycle						
						end
						
					--6) При наступлении новой минуты, цикл повторяется с пункта 2
						Refresh_Table_Python_v1() -- Обновим значения в таблице
						Cycle = Cycle + 1
						sleep(1000)
						
						--Забыл писать и читать таблицу !
						table.save(t,Path_Table)                                   -- пишем       
						t = table.read(Path_Table)                                 -- читаем

						-------------Дата и время сервера---------------------- тоже их забыл !!!
						local d=getTradeDate() -- текущая дата
						YYYYMMDD=100*(100*d.year+d.month)+d.day
						Date = YYYYMMDD
						Time = getInfoParam("SERVERTIME")--HH:MM:SS
						-------------Дата и время сервера----------------------  
						
						--Забыл писать логи
							if Log_Balance_flag~=Date	then  --Пишем логи баланса раз в день в заданное время 19:00  
								if((Current_hour == 19)) then  
									if( (getItem("futures_client_limits",0).cbplimit~=nil)) then		
								Log_Balance_flag = Date
								Write_Log_Balance()		
									end
								end
							end	
							 	 									
			else--if( ( Current_hour <= 23 ) and ( (( Current_hour == 10 ) and (Current_min >= 3)) or ( Current_hour >= 11 ) ) )then   --Идея весь цикл запускать только во время торгов и не более		
				sleep(1000) --Эта пауза, чтобы скрипт не перегружал проц, когда время торгов не наступило для оптимальности пропишем через  else
			end
		else --Эта пауза, чтобы скрипт не перегружал проц, когда терминал не приконнечен. для оптимальности пропишем через  else
			sleep(1000) 
		end --Условия запуска скрипта по времени и т.д. и по соединению

	end --бесконечный цикл while
end