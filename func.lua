function write_quotes(quote_label, num_candles,Path_quote)
	local count_candles = 0
	local first_candle  = 0
	local Close_M0,Close_M1 = 0
	
	--������ ������ ����������� �����, �����������-���������� ����������. Si_m
	if (getNumCandles(quote_label) < num_candles) then
		count_candles = getNumCandles(quote_label)
		first_candle = 0
	else 
		count_candles = num_candles
		first_candle  = getNumCandles(quote_label)-num_candles							
	end

	if (getCandlesByIndex(quote_label,0, first_candle,count_candles) ~= nil) then
	tt,nn,ii = getCandlesByIndex(quote_label,0, first_candle,count_candles)
		if ( tt~= nil and #tt>0) then --#tt>0 ��� ��� ������ ? ����� ! ������� !!! # �������� ����� �������.
			--������� �������� ��������� �����, ���������� �� ��� �� ����������� �������� �������� � Current_min, ������ ���� Prev_min
			shift_candle = 2
			-- ���� �� ���������� � ����� ����� �� ������ ��������������, �� shift_candle = 1
			if(Prev_min == tt[count_candles - 1].datetime.min)  then --���� ��������� ����� � ������� ��������� ���������, ������ ��� � ����� ����� Prev_min
				shift_candle = 1
			end							
			--����� � ������� ���������� � �������� � ����													
			file = io.open(Path_quote,"w")								
			file:write("date",";","time",";","open",";","high",";","low",";","close",";","vol","\n")								
			for i = 1, count_candles-shift_candle do									
				file:write(string.format("%04d%02d%02d;%02d:%02d;%s;%s;%s;%s;%s",tt[i].datetime.year,tt[i].datetime.month,tt[i].datetime.day,tt[i].datetime.hour,tt[i].datetime.min,tt[i].open,tt[i].high,tt[i].low,tt[i].close,tt[i].volume),"\n")									
			end
			file:close()

			--t.Close_M0[1]  =  tt[count_candles - 1].close  --������� ��������, ����������� �������� - ��������� ������ �� �������
			--t.Close_M1[1]  =  tt[count_candles - 2].close  --���������� ��������, �� ��������  - ������������� ��������� �����������
			
			Close_M0 =  tt[count_candles - 1].close  --������� ��������, ����������� �������� - ��������� ������ �� �������
			Close_M1 =  tt[count_candles - 2].close  --���������� ��������, �� ��������  - ������������� ��������� �����������
			--��� �� ����� !?! ���� ���-�� �������� � � ������� ���������� ���-�� ������ !!!!
		end
	end	
	
	return Close_M0,Close_M1
end

--��������� ������ � ��������� ������������, � ���������� ��� � lua �������
--local myString = "XXX,YYY,ZZZ"
--local myTable = myString:split(",")
function string:split( inSplitPattern, outResults )
   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

-- ������� ��������� ���������� ���, ��� ��� (���������� true, ��� false)
CheckBit = function(flags, _bit)
   -- ���������, ��� ���������� ��������� �������� �������
   if type(flags) ~= "number" then error("������!!! Checkbit: 1-� �������� �� �����!") end
   if type(_bit) ~= "number" then error("������!!! Checkbit: 2-� �������� �� �����!") end
 
   if _bit == 0 then _bit = 0x1
   elseif _bit == 1 then _bit = 0x2
   elseif _bit == 2 then _bit = 0x4
   elseif _bit == 3 then _bit  = 0x8
   elseif _bit == 4 then _bit = 0x10
   elseif _bit == 5 then _bit = 0x20
   elseif _bit == 6 then _bit = 0x40
   elseif _bit == 7 then _bit  = 0x80
   elseif _bit == 8 then _bit = 0x100
   elseif _bit == 9 then _bit = 0x200
   elseif _bit == 10 then _bit = 0x400
   elseif _bit == 11 then _bit = 0x800
   elseif _bit == 12 then _bit  = 0x1000
   elseif _bit == 13 then _bit = 0x2000
   elseif _bit == 14 then _bit  = 0x4000
   elseif _bit == 15 then _bit  = 0x8000
   elseif _bit == 16 then _bit = 0x10000
   elseif _bit == 17 then _bit = 0x20000
   elseif _bit == 18 then _bit = 0x40000
   elseif _bit == 19 then _bit = 0x80000
   elseif _bit == 20 then _bit = 0x100000
   end
 
   if bit.band(flags,_bit ) == _bit then return true
   else return false end
end


		
function Indicator_Micro_Elder_v5() --������ ����������� �� �����-�������� ����������  EMA_L, EMA_H, Donch_L, Donch_H
-----------------------micro enter data-------------------------------
if (getCandlesByIndex("EMA_L",0, getNumCandles("EMA_L")-2,2) ~= nil) then
m,o,p = getCandlesByIndex("EMA_L",0, getNumCandles("EMA_L")-2,2)
if ( m~= nil and #m>0) then --#t>0 ��� ��� ������ ? ����� ! ������� !!! 
--EMA_L = (m[1].close +0) --������� ��������, ����������� ��������
EMA_L = (m[0].close +0) --���������� ��������, �� ��������
end
end

if (getCandlesByIndex("EMA_H",0, getNumCandles("EMA_H")-2,2) ~= nil) then
mm,oo,pp = getCandlesByIndex("EMA_H",0, getNumCandles("EMA_H")-2,2)
if ( mm~= nil and #mm>0) then --#t>0 ��� ��� ������ ? ����� ! ������� !!! 
--EMA_H = (mm[1].close +0) --������� ��������, ����������� ��������
EMA_H = (mm[0].close +0) --���������� ��������, �� ��������
end
end

if (getCandlesByIndex("Donch_SI",2, getNumCandles("Donch_SI")-2,2) ~= nil) then --��� ��� ���� ��������� ��� Lo ��� Hi
mmm,ooo,ppp = getCandlesByIndex("Donch_SI",2, getNumCandles("Donch_SI")-2,2)
if ( mmm~= nil and #mmm>0) then --#t>0 ��� ��� ������ ? ����� ! ������� !!! 
--Donch_L  = (mmm[1].close +0) --������� ��������, ����������� ��������
Donch_L  = (mmm[0].close +0) --���������� ��������, �� ��������
end
end

if (getCandlesByIndex("Donch_SI",0, getNumCandles("Donch_SI")-2,2) ~= nil) then --��� ��� ���� ��������� ��� Lo ��� Hi
mmmm,oooo,pppp = getCandlesByIndex("Donch_SI",0, getNumCandles("Donch_SI")-2,2)
if ( mmmm~= nil and #mmmm>0) then --#t>0 ��� ��� ������ ? ����� ! ������� !!! 
--Donch_H  = (mmmm[1].close +0) --������� ��������, ����������� ��������
Donch_H  = (mmmm[0].close +0) --���������� ��������, �� ��������
end
end

if (getCandlesByIndex("PRICE",0, getNumCandles("PRICE")-2,2) ~= nil) then
mmmmm,ooooo,ppppp = getCandlesByIndex("PRICE",0, getNumCandles("PRICE")-2,2)
if ( mmmmm~= nil and #mmmmm>0) then --#t>0 ��� ��� ������ ? ����� ! ������� !!! 
High = (mmmmm[1].high +0) --������� ��������, ����������� ��������
Low  = (mmmmm[1].low  +0) --������� ��������, ����������� ��������
--High = (mmmmm[0].close +0) --���������� ��������, �� ��������
end
end

		Donch_Sell = math.floor(Donch_H - (0.2*(Donch_H-Donch_L)) +0 )
		Donch_Buy  = math.floor(Donch_L + (0.2*(Donch_H-Donch_L)) +0 )
end

function Indicator_Macro_Elder_v5() --������ ����������� �� ������� ����������, �������� �� ��������� MACD1,2; MACD_S1,2; MACD_H_mini1,2; DEV
	
if (getCandlesByIndex("MACD_SI",0, getNumCandles("MACD_SI")-2,2) ~= nil) then
tttt,nnnn,iiii = getCandlesByIndex("MACD_SI",0, getNumCandles("MACD_SI")-2,2)
if ( tttt~= nil and #tttt>0) then --#t>0 ��� ��� ������ ? ����� ! ������� !!! 
--Donch_Middle = math.floor(t[1].close +0)--������� ��������, ����������� ��������
MACD1 = (tttt[1].close +0) --������� ��������, ����������� ��������
MACD2 = (tttt[0].close +0) --���������� ��������, �� ��������
end
end

if (getCandlesByIndex("MACD_SI",1, getNumCandles("MACD_SI")-2,2) ~= nil) then
tt,nn,ii = getCandlesByIndex("MACD_SI",1, getNumCandles("MACD_SI")-2,2)
if ( tt~= nil and #tt>0) then --#tt>0 ��� ��� ������ ? ����� ! ������� !!! 
--Donch_Middle = math.floor(tt[1].close +0)--������� ��������, ����������� ��������
MACD_S1 = (tt[1].close +0) --������� ��������, ����������� ��������
MACD_S2 = (tt[0].close +0) --���������� ��������, �� ��������
end
end

--MACD_H1 = MACD1 - MACD_S1 + 0  --������ ��� ���� ��� ����������
--MACD_H2 = MACD2 - MACD_S2 + 0  --������ ��� ���� ��� ����������

if (getCandlesByIndex("HIST_SI",0, getNumCandles("HIST_SI")-32,32) ~= nil) then
ttt,nnn,iii = getCandlesByIndex("HIST_SI",0, getNumCandles("HIST_SI")-32,32)
if ( ttt~= nil and #ttt>0) then --#ttt>0 ��� ��� ������ ? ����� ! ������� !!! 
--Donch_Middle = math.floor(ttt[1].close +0)--������� ��������, ����������� ��������
MACD_H_mini1 = (ttt[31].close +0) --������� ��������, ����������� ��������
MACD_H_mini2 = (ttt[30].close +0) --���������� ��������, �� ��������

--c 30 �� 1 ��� ������ ������������ ����������
-------------------------DEV 30-------------------
       --������� ��������� ������� ��������.------
	   MIDD = 0
       for i = 1, 30 do
	   MIDD = MIDD + ttt[i].close
	   end
	   MIDD = MIDD/30;
	   --������ ����� ������� ���������-----------
	   SUMM_SQR = 0
	   for i = 1, 30 do
	   SUMM_SQR = SUMM_SQR + (ttt[i].close - MIDD)^2
	   end
	   
	   DEV = (SUMM_SQR/(30-1))^0.5 + 0
-------------------------DEVV 15------------------
	   --������� ��������� ������� ��������.------ 
	   MIDDD = 0
       for i = 16, 30 do
	   MIDDD = MIDDD + ttt[i].close
	   end
	   MIDDD = MIDDD/15;
	   --������ ����� ������� ���������-----------
	   SUMM_SQRR = 0
	   for i = 16, 30 do
	   SUMM_SQRR = SUMM_SQRR + (ttt[i].close - MIDDD)^2
	   end
	   
	   DEVV = (SUMM_SQRR/(15-1))^0.5 + 0
	   
	   DEV = (DEV + DEVV)/2   
end
end


end

function Set_Safety_Stop_Order_KAMA() --����� ����� !!!
------������� �������, ������� ������ ����-������ �� ���������� �������� ������� �� ���������� STOP_PRICE+-3*LVL  �� ������� ���� ��� ��������� ����������

--���������� ����-����� �� Current_Position . ���� Current_Position > 0 �� ����-������ �� ������� �� ���� BID\ASK +-(Num+2)*LVL ?
--�� ���� ! ������������� ��� �������  t.Price[i] ��� Current_Position > 0 ���� ����������� t.Price[i] � �������� . ��� ����� ���������� ��� 3*LVL �� ������ !


--��������� ��� ��������� Current_Position !!!
if ( Current_Position ~= STOP_POSITION  ) then 
STOP_PRICE = 0
--if Current_Position ~= 
    if Current_Position > 0 then
		    if STOP_PRICE == 0 then --��������� �� ������ ���� ����� ����
			STOP_PRICE = BID		 
		    end
		 --������� ����-������
		 KILL_ALL_STOP_ORDERS() --����� ����� !!!
		 --������������� ��� ������������ ����-������ �� ������� �� ����-���� STOP_PRICE-3*LVL � ���� STOP_PRICE-3*LVL-SLIPPAGE
		 SEND_STOP_ORDER("S",STOP_PRICE-LVL-SLIPPAGE,STOP_PRICE-LVL,math.abs(Current_Position))
	end
	
	if Current_Position < 0 then	 
		   	if STOP_PRICE == 0 then --��������� �� ������ ���� ����� ����
			STOP_PRICE = ASK		 
		    end
		 --������� ����-������
		 KILL_ALL_STOP_ORDERS() --����� ����� !!!
		 --������������� ��� ������������ ����-������ �� ������� �� ����-���� STOP_PRICE+3*LVL � ���� STOP_PRICE+3*LVL+SLIPPAGE
		 SEND_STOP_ORDER("B",STOP_PRICE+LVL+SLIPPAGE,STOP_PRICE+LVL,math.abs(Current_Position))
	end
	-- ���� ���������� ����� ����� �� ������� � ��� Current_Position == 0
	if Current_Position == 0 then
	    --������� ����-������
		KILL_ALL_STOP_ORDERS()
	end
end	 
STOP_POSITION = Current_Position

end

function Set_Safety_Stop_Order() --����� ����� !!!
------������� �������, ������� ������ ����-������ �� ���������� �������� ������� �� ���������� STOP_PRICE+-3*LVL  �� ������� ���� ��� ��������� ����������

--���������� ����-����� �� Current_Position . ���� Current_Position > 0 �� ����-������ �� ������� �� ���� BID\ASK +-(Num+2)*LVL ?
--�� ���� ! ������������� ��� �������  t.Price[i] ��� Current_Position > 0 ���� ����������� t.Price[i] � �������� . ��� ����� ���������� ��� 3*LVL �� ������ !


--��������� ��� ��������� Current_Position !!!
if ( Current_Position ~= STOP_POSITION  ) then 
STOP_PRICE = 0
--if Current_Position ~= 
     if Current_Position > 0 then
	     STOP_PRICE = t.Price[1]  -- init
	     for i = 1, Num do
		    if t.Price[i] < STOP_PRICE then
			STOP_PRICE = t.Price[i]
			end		 
		 end	 
		    if STOP_PRICE == 0 then --��������� �� ������ ���� ����� ����
			STOP_PRICE = BID		 
		    end
		 --������� ����-������
		 KILL_ALL_STOP_ORDERS() --����� ����� !!!
		 --������������� ��� ������������ ����-������ �� ������� �� ����-���� STOP_PRICE-3*LVL � ���� STOP_PRICE-3*LVL-SLIPPAGE
		 SEND_STOP_ORDER("S",STOP_PRICE-3*LVL-SLIPPAGE,STOP_PRICE-3*LVL,math.abs(Current_Position))
	 end
	 
	 if Current_Position < 0 then
	     STOP_PRICE = t.Price[1]  -- init ���� ��� ������, �� ������
	     for i = 1, Num do
		    if t.Price[i] > STOP_PRICE then
			STOP_PRICE = t.Price[i]
			end		 
		 end	 
		   	if STOP_PRICE == 0 then --��������� �� ������ ���� ����� ����
			STOP_PRICE = ASK		 
		    end
		 --������� ����-������
		 KILL_ALL_STOP_ORDERS() --����� ����� !!!
		 --������������� ��� ������������ ����-������ �� ������� �� ����-���� STOP_PRICE+3*LVL � ���� STOP_PRICE+3*LVL+SLIPPAGE
		 SEND_STOP_ORDER("B",STOP_PRICE+3*LVL+SLIPPAGE,STOP_PRICE+3*LVL,math.abs(Current_Position))
	 end
STOP_POSITION = Current_Position

end

if(Current_Position == 0) then
KILL_ALL_STOP_ORDERS() --����� ����� !!!
end
------������� �������, ������� ������ ����-������ �� ���������� �������� ������� �� ���������� STOP_PRICE+-3*LVL �� ������� ���� ��� ��������� ����������
--SEND_STOP_ORDER(OPERATION,PRICE,STOP_PRICE,QUANTITY) --��������
--SEND_STOP_ORDER("B",35976,35976,math.abs(-10)) --��������
--KILL_ALL_STOP_ORDERS()
end

function Profit_Count() ---Last_Status   
	     if  (t.Price_Enter[1] ~=  0)  then  -- �������, ��� ���� ����� ��� ������������
		     if (  Last_Status ==  1)  then  --�������� ������� �������
			 t.Price_Profit[1] = t.Price_Exit[1] - t.Price_Enter[1] - t.Price_Slippage[1]
			 end
			 if (  Last_Status == -1)  then --�������� �������� �������
			 t.Price_Profit[1] = t.Price_Enter[1] - t.Price_Exit[1] - t.Price_Slippage[1]
			 end		 
		 end
end

function Current_Profit_Count_Elder_v4()
	     if  (t.Price_Enter[1] ~=  0)  then  -- �������, ��� ���� ����� ��� ������������
		     if (  t.Status[1] ==  1)  then  --�������� ������� �������
			 t.Price_Profit[1] = BID - t.Price_Enter[1] - t.Price_Slippage[1]
			 end
			 if (  t.Status[1] == -1)  then --�������� �������� �������
			 t.Price_Profit[1] = t.Price_Enter[1] - ASK - t.Price_Slippage[1]
			 end		 
		 end    
end

function Current_Profit_Count()
    for i = 1, Num do
	     if  (t.Price_Enter[i] ~=  0)  then  -- �������, ��� ���� ����� ��� ������������
		     if (  t.Status[i] ==  1)  then  --�������� ������� �������
			 t.Price_Profit[i] = BID - t.Price_Enter[i] - t.Price_Slippage[i]
			 end
			 if (  t.Status[i] == -1)   then --�������� �������� �������
			 t.Price_Profit[i] = t.Price_Enter[i] - ASK - t.Price_Slippage[i]
			 end		 
		 end
    end
end

function Current_Profit_Count_KAMA()
    --for i = 1, Num do
	t.Price_Enter[1] = t.Price_Exit[2] -- KAMA ��� �������� ������-�����������
	i = 1
	     if  (t.Price_Enter[i] ~=  0)  then  -- �������, ��� ���� ����� ��� ������������
		     if (  t.Status[i] ==  1)  then  --�������� ������� �������
			 t.Price_Profit[i] = BID - t.Price_Enter[i] - t.Price_Slippage[i]
			 end
			 if (  t.Status[i] == -1)   then --�������� �������� �������
			 t.Price_Profit[i] = t.Price_Enter[i] - ASK - t.Price_Slippage[i]
			 end		 
		 end
    --end
end

function Real_Price_Exit_Count()
--��� ������� �������� ���� ������ ������ � ����. ������, ������� ����. t.Price_Exit[i] t.Price_Slippage[i] �������� t.Status_Change[i] = 0 �������� Last_Status
		--��� ������� �������� ���� �����  ��� ����� ����. �������� !
		--����� ����, ���������� ���������� ����� �� ������� ������ � Trades_Prev � ������������� !!!
						
	Trades_Curr = getNumberOf("trades")
		--��� ������� �������� ���� ����� ���������� ��������� �� ������� ������ ������� Trades_Prev ~= Trades_Curr
		--� ����� ����� ������ �������� ���� ����� ��������� ������������ ������ ��� ��������� � ������ � ������� ����������� �������� Price_Enter
		
	if(Trades_Prev ~= Trades_Curr) then
		-- Trades_Curr-Trades_Prev - ����� ����� ����������� ��������� � ������� ������
		    Summ_Price   = 0
			Summ_lot     = 0
			Middle_Price = 0
            -- ��������� ����� ��� !!!
		    for i = ( getNumberOf("trades")-(Trades_Curr-Trades_Prev) ), getNumberOf("trades")-1 do --������� ���� ������ � "������� ������"
			-- ��������� � ����� ������� ��� ���� ������ ���������� �� ���� � �������� ��������� ����
			Summ_Price = Summ_Price + ( getItem("trades",i).price*getItem("trades",i).qty )
			Summ_lot   = Summ_lot   +   getItem("trades",i).qty			
			--message(" �������� ������� "..i.." Summ_Price "..Summ_Price.." Summ_lot "..Summ_lot,1)
		    end
			-- ��������� ������� ���� ����� ����� ������ ���������� �� ���� ����� �� ����� �����					
			Middle_Price = tonumber(Summ_Price/Summ_lot)
			--message(" �������� ������� Summ_Price "..Summ_Price.." Summ_lot "..Summ_lot.." Middle_Price "..Middle_Price,1)
		-- ������� � ������� t.Price_Enter[i] � �� ������ � ������� ��������� t.Status[i]( ���������� �� t.Status_Change[i] � 1 � ����� �������� ���)
		--for i = 1, Num do		    
			if (t.Status_Change[1] == 1) then	
			t.Price_Exit[1] = Middle_Price+0
						 
			   if( Last_Status ==  1)  then --������� ���������� ���� ������� ��� �������
			    t.Price_Slippage[1]= t.Price_Slippage[1]+(t.Price_Exit[1]-Middle_Price) --��������������� - ������
				t.Status_Change[1] = 0 -- �������� ���� ����� �������, ����� ������������� ���������
			   end
			   
			   if( Last_Status == -1)  then --������� ���������� ���� ������� ��� �������
			    t.Price_Slippage[1]= t.Price_Slippage[1]+(Middle_Price-t.Price_Exit[1]) --��������������� - ������
				t.Status_Change[1] = 0 -- �������� ���� ����� �������, ����� ������������� ���������
			   end
			   
			end		
		--end	--for					
		Trades_Prev=Trades_Curr -- ��������� �� � �������� Trades_Prev
	end
end

function Real_Price_Enter_Count() --��� !!! ����������, ������ �������� �������� ������ ������ !!!
--��� ������� �������� ���� ����� ������ � ����. ������, ������� ����. t.Price_Enter[i] t.Price_Slippage[i] �������� t.Status_Change[i] = 0
		--��� ������� �������� ���� �����  ��� ����� ����. �������� !
		--����� ����, ���������� ���������� ����� �� ������� ������ � Trades_Prev � ������������� !!!
						
	Trades_Curr = getNumberOf("trades")
		--��� ������� �������� ���� ����� ���������� ��������� �� ������� ������ ������� Trades_Prev ~= Trades_Curr
		--� ����� ����� ������ �������� ���� ����� ��������� ������������ ������ ��� ��������� � ������ � ������� ����������� �������� Price_Enter
		
	if(Trades_Prev ~= Trades_Curr) then
		-- Trades_Curr-Trades_Prev - ����� ����� ����������� ��������� � ������� ������
		    Summ_Price   = 0
			Summ_lot     = 0
			Middle_Price = 0
            -- ��������� ����� ��� !!!
		    for i = ( getNumberOf("trades")-(Trades_Curr-Trades_Prev) ), getNumberOf("trades")-1 do --������� ���� ������ � "������� ������"
			-- ��������� � ����� ������� ��� ���� ������ ���������� �� ���� � �������� ��������� ����
			Summ_Price = Summ_Price + ( getItem("trades",i).price*getItem("trades",i).qty )
			Summ_lot   = Summ_lot   +   getItem("trades",i).qty			
			--message(" �������� ������� "..i.." Summ_Price "..Summ_Price.." Summ_lot "..Summ_lot,1)
		    end
			-- ��������� ������� ���� ����� ����� ������ ���������� �� ���� ����� �� ����� �����					
			Middle_Price = tonumber(Summ_Price/Summ_lot)
			--message(" �������� ������� Summ_Price "..Summ_Price.." Summ_lot "..Summ_lot.." Middle_Price "..Middle_Price,1)
		-- ������� � ������� t.Price_Enter[i] � �� ������ � ������� ��������� t.Status[i]( ���������� �� t.Status_Change[i] � 1 � ����� �������� ���)
		for i = 1, Num do		    
			if (t.Status_Change[i] == 1) then
			   t.Price_Enter[i] = Middle_Price+0
			 
			   if( t.Status[i] ==  1)  then --������� ���������� ���� ������� ��� �������
			    t.Price_Slippage[i]= t.Price_Slippage[i]+(t.Price_Enter[i]-t.Price_LVL[i]) --��������������� - ������
				t.Status_Change[i] = 0 -- �������� ���� ����� �������, ����� ������������� ���������
			   end
			   
			   if( t.Status[i] == -1)  then --������� ���������� ���� ������� ��� �������
			    t.Price_Slippage[i]= t.Price_Slippage[i]+(t.Price_LVL[i]-t.Price_Enter[i]) --��������������� - ������
				t.Status_Change[i] = 0 -- �������� ���� ����� �������, ����� ������������� ���������
			   end
			   
			end		
		end						
		Trades_Prev=Trades_Curr -- ��������� �� � �������� Trades_Prev
	end
end

function Real_Price_Enter_Count_KAMA() --��� !!! ����������, ������ �������� �������� ������ ������ !!!
--��� ������� �������� ���� ����� ������ � ����. ������, ������� ����. t.Price_Enter[i] t.Price_Slippage[i] �������� t.Status_Change[i] = 0
		--��� ������� �������� ���� �����  ��� ����� ����. �������� !
		--����� ����, ���������� ���������� ����� �� ������� ������ � Trades_Prev � ������������� !!!
						
	Trades_Curr = getNumberOf("trades")
		--��� ������� �������� ���� ����� ���������� ��������� �� ������� ������ ������� Trades_Prev ~= Trades_Curr
		--� ����� ����� ������ �������� ���� ����� ��������� ������������ ������ ��� ��������� � ������ � ������� ����������� �������� Price_Enter
		
	if(Trades_Prev ~= Trades_Curr) then
		-- Trades_Curr-Trades_Prev - ����� ����� ����������� ��������� � ������� ������
		    Summ_Price   = 0
			Summ_lot     = 0
			Middle_Price = 0
            -- ��������� ����� ��� !!!
		    for i = ( getNumberOf("trades")-(Trades_Curr-Trades_Prev) ), getNumberOf("trades")-1 do --������� ���� ������ � "������� ������"
			-- ��������� � ����� ������� ��� ���� ������ ���������� �� ���� � �������� ��������� ����
			Summ_Price = Summ_Price + ( getItem("trades",i).price*getItem("trades",i).qty )
			Summ_lot   = Summ_lot   +   getItem("trades",i).qty			
			--message(" �������� ������� "..i.." Summ_Price "..Summ_Price.." Summ_lot "..Summ_lot,1)
		    end
			-- ��������� ������� ���� ����� ����� ������ ���������� �� ���� ����� �� ����� �����					
			Middle_Price = tonumber(Summ_Price/Summ_lot) --
			--message(" �������� ������� Summ_Price "..Summ_Price.." Summ_lot "..Summ_lot.." Middle_Price "..Middle_Price,1)
		-- ������� � ������� t.Price_Enter[i] � �� ������ � ������� ��������� t.Status[i]( ���������� �� t.Status_Change[i] � 1 � ����� �������� ���)
		--for i = 1, Num do		
        i = 1		-- ��� ���� �������� ������ ����� ���
			if (t.Status_Change[i] == 1) then
			   t.Price_Enter[i] = Middle_Price+0
			 
			   if( t.Status[i] ==  1)  then --������� ���������� ���� ������� ��� �������
			    t.Price_Slippage[i]= 0 --t.Price_Slippage[i]+(t.Price_Enter[i]-BID) --��������������� - ������
				t.Status_Change[i] = 0 -- �������� ���� ����� �������, ����� ������������� ���������
			   end
			   
			   if( t.Status[i] == -1)  then --������� ���������� ���� ������� ��� �������
			    t.Price_Slippage[i]= 0 --t.Price_Slippage[i]+(ASK-t.Price_Enter[i]) --��������������� - ������
				t.Status_Change[i] = 0 -- �������� ���� ����� �������, ����� ������������� ���������
			   end
			   
			end		
		--end						
		Trades_Prev=Trades_Curr -- ��������� �� � �������� Trades_Prev
	end
end

function Trade_Ops() -- ������� ����������� ���������
        --����� ����� ��������� BID ASK, ����� ���� ������������ � ����-�����
	    BID =  getParamEx(MARKET,TICKER,"BID").param_value   --������� ����� !!! ASK > BID  ����� �������� �� Low  ������� ����� !!!!
	    ASK =  getParamEx(MARKET,TICKER,"OFFER").param_value --������� ����� !!! ASK > BID  ����� �������� �� high ������� ����� !!!!
		--������ ���������� ���������� ������������ � ����� � �������� ��
		Total_Size = -(Current_Position-POSITION*SIZE)+0   --���������� ����� ��� ������������� ������� ���� +- ���������� ������� ��� ������
		     if     Total_Size < 0 then                 --������� ������ ��� ������� �� ����
			 SEND_ORDER_V2(BID+0,Total_Size+0)			  --REAL_TRADE - ������������ ���� �� ����			 
			 
			 Log(" Date "..Date.." Time "..Time.." State "..State.." S "..BID.." Total_Size "..Total_Size.." Current_Position "..Current_Position.." POSITION "..POSITION)        --������� ������
			 sleep(3500)--���� ���� ����������� ������ � ������ ��������
			 
			 elseif Total_Size > 0 then                 --������� ����� ������ ��� ������� �� ���� BUY_PRICE+0 � ����� ASK+0
			 SEND_ORDER_V2(ASK+0,Total_Size+0)            --REAL_TRADE - ������������ ���� �� ����			 

			 Log(" Date "..Date.." Time "..Time.." State "..State.." B "..ASK.." Total_Size "..Total_Size.." Current_Position "..Current_Position.." POSITION "..POSITION)        --������� ������
			 sleep(3500)--���� ���� ����������� ������ � ������ ��������
			 
			 end
			 --Current_Position=POSITION                  --������� ������  REAL_TRADE - ������������
end

function Trade_Ops_DAY_Trend() -- ������� ����������� ���������
        --����� ����� ��������� BID ASK, ����� ���� ������������ � ����-�����
	    --BID =  getParamEx(MARKET,TICKER,"BID").param_value   --������� ����� !!! ASK > BID  ����� �������� �� Low  ������� ����� !!!!
	    --ASK =  getParamEx(MARKET,TICKER,"OFFER").param_value --������� ����� !!! ASK > BID  ����� �������� �� high ������� ����� !!!!
		
		
		--������ ���������� ���������� ������������ � ����� � �������� ��
		Total_Size = -(Current_Position-POSITION*SIZE)+0   --���������� ����� ��� ������������� ������� ���� +- ���������� ������� ��� ������
		     if     Total_Size < 0 then                 --������� ������ ��� ������� �� ����
			 SEND_ORDER_V2(Donch_Middle+0,Total_Size+0)			  --REAL_TRADE - ������������ ���� �� ����			 
			 
			 Log(" Date "..Date.." Time "..Time.." State "..State.." S "..Donch_Middle.." Total_Size "..Total_Size.." Current_Position "..Current_Position.." POSITION "..POSITION)        --������� ������
			 sleep(3500)--���� ���� ����������� ������ � ������ ��������
			 
			 elseif Total_Size > 0 then                 --������� ����� ������ ��� ������� �� ���� BUY_PRICE+0 � ����� ASK+0
			 SEND_ORDER_V2(Donch_Middle+0,Total_Size+0)            --REAL_TRADE - ������������ ���� �� ����			 

			 Log(" Date "..Date.." Time "..Time.." State "..State.." B "..Donch_Middle.." Total_Size "..Total_Size.." Current_Position "..Current_Position.." POSITION "..POSITION)        --������� ������
			 sleep(3500)--���� ���� ����������� ������ � ������ ��������
			 
			 end
			 --Current_Position=POSITION                  --������� ������  REAL_TRADE - ������������
end

function Trade_Ops_Elder_v3() -- ������� ����������� ���������
        --����� ����� ��������� BID ASK, ����� ���� ������������ � ����-�����
	    --BID =  getParamEx(MARKET,TICKER,"BID").param_value   --������� ����� !!! ASK > BID  ����� �������� �� Low  ������� ����� !!!!
	    --ASK =  getParamEx(MARKET,TICKER,"OFFER").param_value --������� ����� !!! ASK > BID  ����� �������� �� high ������� ����� !!!!
		--���������� ��������  Donch_Sell Donch_Buy
		--Donch_Sell = math.floor(Donch_H - (0.1*(Donch_H-Donch_L)) +0 )
		--Donch_Buy  = math.floor(Donch_L + (0.1*(Donch_H-Donch_L)) +0 )
		
		--������ ���������� ���������� ������������ � ����� � �������� ��
		Total_Size = -(Current_Position-POSITION*SIZE)+0   --���������� ����� ��� ������������� ������� ���� +- ���������� ������� ��� ������
		     if     Total_Size < 0 then                 --������� 
			 SEND_ORDER_V2(Donch_Sell+0,Total_Size+0)			  --REAL_TRADE - ������������ ���� �� ����			 
			 
			 Log(" Date "..Date.." Time "..Time.." State "..State.." S "..Donch_Sell.." Total_Size "..Total_Size.." Current_Position "..Current_Position.." POSITION "..POSITION)        --������� ������
			 sleep(3500)--���� ���� ����������� ������ � ������ ��������
			 
			 elseif Total_Size > 0 then                 --������� 
			 SEND_ORDER_V2(Donch_Buy+0,Total_Size+0)            --REAL_TRADE - ������������ ���� �� ����			 

			 Log(" Date "..Date.." Time "..Time.." State "..State.." B "..Donch_Buy.." Total_Size "..Total_Size.." Current_Position "..Current_Position.." POSITION "..POSITION)        --������� ������
			 sleep(3500)--���� ���� ����������� ������ � ������ ��������
			 
			 end
			 --Current_Position=POSITION                  --������� ������  REAL_TRADE - ������������
end

function Trade_Ops_DAY_Trend_Mul(Strategy_Num) -- ������� �������� ���������� ������ � ����������� ��, �� ������ ���������.

       --�������� ��� ������� ������ � ������ Status_Change[i]==1, ����� � ������� ����� �������.

       --1) ����������� TRANS_ID = MUL_TRANS_ID[Strategy_Num]
	   --2) ����� �������� ������ �� TRANS_ID ��� �������� ���������
	   --���� �� �������� ������ � ��������� TRANS_ID (Strategy_Num*1000 ; (Strategy_Num+1)*1000 )
	   --���� ����, �� ����� � ����� � ��������� ����� ������ � ��������
	   --���� �������� ������ ��� � t.Status[Strategy_Num] != POSITION[Strategy_Num], 
	   --�� ��������� ������� ����-�� � ����������� � ����������� �� ��������� t.Status[Strategy_Num] POSITION[Strategy_Num],
	   --����� ����������� ������ �� ���� Donch_Middle[Strategy_Num],  t.Status[i]=POSITION[i]. 
	   --����� ����� ������ ������ �������������� ���������� ���� ������.
	   
	     TRANS_ID = MUL_TRANS_ID[Strategy_Num]	   	   	   
	   
	   		 for i = 0, getNumberOf("orders")-1 do --������� ���� ������ � "������� ������"
		        if bit_set(getItem("orders",i).flags,0)  then      --������� �������� ������

			       if( (getItem("orders",i).trans_id >= Strategy_Num*1000) and (getItem("orders",i).trans_id < (Strategy_Num+1)*1000) ) then     --������� �������� TRANS_ID
				     --TRANS_ID = MUL_ALLIGNMENT_TRANS_ID                --������� ID ������ ��� ��������� ������������.
				     balance =  --�������, ���� ������ ���� �� ��������� ���������
			         KILL_ORDER(getItem("orders",i).order_num)         --�������� ������� !!!
				     --MUL_ALLIGNMENT_TRANS_ID = TRANS_ID                --��������������� �������� TRANS_ID ����� ���������� ����������(����������)
				   end	
                end				   
			 end	
	     MUL_TRANS_ID[Strategy_Num] = TRANS_ID 

end

function Log(text) -- Log ��������
local f = io.open(Path_Log,"a+") --�������������� ���� ��� �����
      f:write(text .. '\n')
      f:close()            --��������� �������
end
function Write_Log_Balance() --����� ���� ������� ��� � ���� 
local ff = io.open(Path_Log_Bal,"a+") --�������������� ���� ��� ����� �������
      ff:write(" Date "..Date.." Time "..Time.." Balance "..getItem("futures_client_limits",0).cbplimit.. '\n')
      ff:close()                      --��������� ������� �������
end
function Write_Log_Table_DAY_Trend_Mul() --����� ���� ������� ������ ��� ��� ����� ������ �������� � ��� ������ ������ � ���� price ! ����������, �������� ���� � ������ ��� � �������
local fff = io.open(Path_Log_Tbl,"a+") --�������������� ���� ��� �����  ������� 
      for i = 1, Num do --��������� ��� ��������     
	  fff:write(" Date "..t.Date[i].." Time "..t.Time[i].." State "..t.State[i].." G_T_P "..t.G_T_P[i].." ASK "..t.ASK[i].." BID "..t.BID[i].." Donch_Middle "..t.Donch_Middle[i].." SAR1 "..t.SAR1[i].." SAR2 "..t.SAR2[i].." SAR2 "..t.SAR3[i].." Status "..t.Status[i].." Status_Change "..t.Status_Change[i].. '\n')
	  end
      fff:close()                      --��������� ������� �������
end
function Write_Log_Table_DAY_Trend() --����� ���� ������� ������ ��� ��� ����� ������ �������� � ��� ������ ������ � ���� price ! ����������, �������� ���� � ������ ��� � �������
local fff = io.open(Path_Log_Tbl,"a+") --�������������� ���� ��� �����  �������      
	  fff:write(" Date "..t.Date[1].." Time "..t.Time[1].." State "..t.State[1].." G_T_P "..t.G_T_P[1].." MAX_Target "..t.MAX_Target[1].." MIN_Target "..t.MIN_Target[1].." Donch_Middle "..t.Donch_Middle[1].." SAR1 "..t.SAR1[1].." SAR2 "..t.SAR2[1].." Status "..t.Status[1].." Status_Change "..t.Status_Change[1].. '\n')
      fff:close()                      --��������� ������� �������
end
function Write_Log_Table_KAMA() --����� ���� ������� ������ ��� ��� ����� ������ �������� � ��� ������ ������ � ���� price ! ����������, �������� ���� � ������ ��� � �������
local fff = io.open(Path_Log_Tbl,"a+") --�������������� ���� ��� �����  �������      
	  fff:write(" Date "..t.Date[1].." Time "..t.Time[1].." State "..t.State[1].." G_T_P "..t.G_T_P[1].." M_T_P "..t.M_T_P[1].." KAMA1_1 "..t.KAMA1_1[1].." KAMA1_2 "..t.KAMA1_2[1].." KAMA2_1 "..t.KAMA2_1[1].." KAMA2_2 "..t.KAMA2_2[1].." KAMA3_1 "..t.KAMA3_1[1].." KAMA3_2 "..t.KAMA3_2[1].." Price_Enter "..t.Price_Enter[1].." Price_Exit "..t.Price_Exit[1].." Price_Slippage "..t.Price_Slippage[1].." Price_Profit "..t.Price_Profit[1].." Status "..t.Status[1].." Status_Change "..t.Status_Change[1].. '\n')--" Price "..t.Price[1].." Price_Enter "..t.Price_Enter[1].." Price_Exit "..t.Price_Exit[1].." Price_Slippage "..t.Price_Slippage[1].." t.Price_Profit "..t.Price_Profit[1].." Status "..t.Status[1].." t.Status_Change "..t.Status_Change[1].. '\n')       
      fff:close()                      --��������� ������� �������
end

function Write_Log_Table_Elder() --����� ���� ������� ������ ��� ��� ����� ������ �������� � ��� ������ ������ � ���� price ! ����������, �������� ���� � ������ ��� � �������
local fff = io.open(Path_Log_Tbl,"a+") --�������������� ���� ��� �����  �������      
	  fff:write(" Date "..t.Date[1].." Time "..t.Time[1].." State "..t.State[1].." G_T_P "..t.G_T_P[1].." M_T_P "..t.M_T_P[1].." MACD1 "..t.MACD1[1].." MACD2 "..t.MACD2[1].." MACD_S1 "..t.MACD_S1[1].." MACD_S2 "..t.MACD_S2[1].." MACD_H1 "..t.MACD_H1[1].." MACD_H2 "..t.MACD_H2[1].." MACD_H_mini1 "..t.MACD_H_mini1[1].." MACD_H_mini2 "..t.MACD_H_mini2[1].." DEV "..t.DEV[1].." Price_Enter "..t.Price_Enter[1].." Price_Exit "..t.Price_Exit[1].." Price_Slippage "..t.Price_Slippage[1].." Price_Profit "..t.Price_Profit[1].." Status "..t.Status[1].." Status_Change "..t.Status_Change[1].. '\n')--" Price "..t.Price[1].." Price_Enter "..t.Price_Enter[1].." Price_Exit "..t.Price_Exit[1].." Price_Slippage "..t.Price_Slippage[1].." t.Price_Profit "..t.Price_Profit[1].." Status "..t.Status[1].." t.Status_Change "..t.Status_Change[1].. '\n')       
      fff:close()                      --��������� ������� �������
end

function Write_Log_Table_Elder_v3() --����� ���� ������� ������ ��� ��� ����� ������ �������� � ��� ������ ������ � ���� price ! ����������, �������� ���� � ������ ��� � �������
local fff = io.open(Path_Log_Tbl,"a+") --�������������� ���� ��� �����  �������      
	  fff:write(" Date "..t.Date[1].." Time "..t.Time[1].." State "..t.State[1].." G_T_P "..t.G_T_P[1].." M_T_P "..t.M_T_P[1].." MACD1 "..t.MACD1[1].." MACD2 "..t.MACD2[1].." MACD_S1 "..t.MACD_S1[1].." MACD_S2 "..t.MACD_S2[1].." MACD_H_mini1 "..t.MACD_H_mini1[1].." MACD_H_mini2 "..t.MACD_H_mini2[1].." DEV "..t.DEV[1].." EMA_L "..t.EMA_L[1].." EMA_H "..t.EMA_H[1].." Donch_L "..t.Donch_L[1].." Donch_H "..t.Donch_H[1].." Price_Enter "..t.Price_Enter[1].." Price_Exit "..t.Price_Exit[1].." Price_Slippage "..t.Price_Slippage[1].." Price_Profit "..t.Price_Profit[1].." Status "..t.Status[1].." Status_Change "..t.Status_Change[1].. '\n')--" Price "..t.Price[1].." Price_Enter "..t.Price_Enter[1].." Price_Exit "..t.Price_Exit[1].." Price_Slippage "..t.Price_Slippage[1].." t.Price_Profit "..t.Price_Profit[1].." Status "..t.Status[1].." t.Status_Change "..t.Status_Change[1].. '\n')       
      fff:close()                      --��������� ������� �������
end

function Write_Log_Table() --����� ���� ������� ������ ��� ��� ����� ������ �������� � ��� 
local fff = io.open(Path_Log_Tbl,"a+") --�������������� ���� ��� �����  �������      
	  fff:write(" Date "..t.Date[1].." Time "..t.Time[1].." Price "..t.Price[1].." Price_LVL "..t.Price_LVL[1].." Price_Enter "..t.Price_Enter[1].." Price_Exit "..t.Price_Exit[1].." Price_Slippage "..t.Price_Slippage[1].." t.Price_Profit "..t.Price_Profit[1].." Status "..t.Status[1].." t.Status_Change "..t.Status_Change[1].. '\n')       
      fff:close()                      --��������� ������� �������
end

--������� ���������� true, ���� ��� [index] ���������� � 1
function bit_set( flags, index )
        local n=1
        n=bit.lshift(1, index)
        if bit.band(flags, n) ~=0 then
                return true
        else
                return false
        end
end
function Check_Current_position()
        --message("getNumberOf(futures_client_holding)= "..getItem("futures_client_holding",0).totalnet,1)-- 
		--message("getNumberOf(futures_client_holding)= "..getItem("futures_client_holding",0).sec_code,1)-- ��� ����������� ��������� �����
		--message("getNumberOf(futures_client_holding)= "..getNumberOf("futures_client_holding"),1)-- 
		if getNumberOf("futures_client_holding") > 0 then
		for i = 1, getNumberOf("futures_client_holding") do                   --������� ���� ������������ � ������� "������� �� ���������� ������ FORTS"	

	    
		    if getItem("futures_client_holding",i-1).sec_code == TICKER then    --�������� �� ������������ �����������
			Current_Position = getItem("futures_client_holding",i-1).totalnet   --����������� ������� ������ ������� �� ���������� ����������� --��� ���� ������� �� i-1
			end		
		end
		end
end
function Check_Count_position()
		-------------------��������� ��������� ������� �� ����� t.Status[i]-------------------------
		POSITION = 0;
		for i = 1, Num do
		POSITION = POSITION + t.Status[i]		
		end
end

function Check_Enter_condition() --��������� ��� ������� �� ������� ���������� �������� ������ LVL � ������������� ��������������� t.Status[i]
--����� ������ ���������� ��������� ���� ���������� +LVL+1 BUY_PRICE -����������� �� ������� � ������� ������ SELL_PRICE-������������ �� ������� � ������� ������
--������������� ����������
BUY_PRICE  = 10000000
SELL_PRICE = 0
 for i = 1, Num do
		    if            (t.Price[i]+0 < (tonumber(ASK)-LVL)) and (t.Price[i]+0 > 0) then  --��������� ������� �� �������, ���� ���� ����, ������ ������ � ��������� ������� �� ������
			     if t.Status[i]~=1 then
				 t.Status_Change[i]=1; --������������� ������� ������ ��� ��������� ��������� �������					 
				     if t.Price[i]+LVL+PIP < BUY_PRICE then --���������� ����������� ���� �� ������� ���������� ������
				     BUY_PRICE = t.Price[i]+LVL+PIP         --������� �� � BUY_PRICE � � t.Price_Enter[i]
				     end					 
				 end
				 if t.Status[i]==-1 then --��� ��������� ������� ������� � t.Price_Reverse[i] + 2*LVL
				 t.Price_Reverse[i] = t.Price_Reverse[i] + 2*LVL
				 end
			     t.Status[i]=1;
			

			t.Price_LVL[i] = t.Price[i]+LVL+PIP      --������� ���� ������ �����	
			end
			if            (t.Price[i]+0 > (tonumber(BID)+LVL)) and (t.Price[i]+0 > 0) then  --��������� ������� �� �������, ���� ���� ����, ������ ������ � ��������� ������� �� ������
				 if t.Status[i]~=-1 then				 
				 t.Status_Change[i]=1; --������������� ������� ������ ��� ��������� ��������� �������
				     if t.Price[i]-LVL-PIP > SELL_PRICE then --���������� ������������ ���� �� ������� ���������� ������
				     SELL_PRICE = t.Price[i]-LVL-PIP --������� �� � BUY_PRICE
				     end	 				 
				 end
				 if t.Status[i]==1 then --��� ��������� ������� ������� � t.Price_Reverse[i] + 2*LVL
				 t.Price_Reverse[i] = t.Price_Reverse[i] + 2*LVL
				 end
			     t.Status[i]=-1;	
				 		
			t.Price_LVL[i] = t.Price[i]-LVL-PIP --������� ���� ������ �����				
			end	
			
		 end
    if BUY_PRICE  == 10000000 then  -- ���� ������ ��� � �� ���������, �� �������� ������ ASK, ����� �� ���� ������ ��� ������������ �������
	BUY_PRICE = ASK
	end
	if SELL_PRICE == 0        then  -- ���� ������ ��� � �� ���������, �� �������� ������ BID, ����� �� ���� ������ ��� ������������ �������
	SELL_PRICE = BID
	end
		 
end

function Refresh_Table()	  --���������� �������
		for i = 1, Num do
		local row = DeleteRow(t_id1,i)
		local row = InsertRow(t_id1,i)
		
		SetCell(t_id1, row, 1, tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2, tostring(t.Time[i]))	
		SetCell(t_id1, row, 3, tostring(t.Price[i]),           t.Price[i]) 
		SetCell(t_id1, row, 4, tostring(t.Price_LVL[i]),       t.Price_LVL[i]) 
		SetCell(t_id1, row, 5, tostring(t.Price_Enter[i]),     t.Price_Enter[i]) 
		SetCell(t_id1, row, 6, tostring(t.Price_Exit[i]),      t.Price_Exit[i]) 
		SetCell(t_id1, row, 7, tostring(t.Price_Slippage[i]),  t.Price_Slippage[i]) 
		SetCell(t_id1, row, 8, tostring(t.Price_Reverse[i]),   t.Price_Reverse[i])
		SetCell(t_id1, row, 9, tostring(t.Price_Profit[i]),    t.Price_Profit[i]) 
		SetCell(t_id1, row, 10,tostring(t.Status[i]),          t.Status[i]) 
		SetCell(t_id1, row, 11,tostring(t.Status_Change[i]),   t.Status_Change[i])

		end
end

function Refresh_Table_KAMA()	  --���������� �������
		for i = 1, Num do
		local row = DeleteRow(t_id1,i)
		local row = InsertRow(t_id1,i)
		
		SetCell(t_id1, row, 1, tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2, tostring(t.Time[i]))	
		SetCell(t_id1, row, 3, tostring(t.State[i]),           t.State[i]) 
		
		--Global_Trend_Position Mini_Trend_Position
		SetCell(t_id1, row, 4, tostring(t.G_T_P[i]),           t.G_T_P[i]) 
		SetCell(t_id1, row, 5, tostring(t.M_T_P[i]),           t.M_T_P[i]) 
	
		
		SetCell(t_id1, row, 6, tostring(t.KAMA1_1[i]),         t.KAMA1_1[i]) 
		SetCell(t_id1, row, 7, tostring(t.KAMA1_2[i]),         t.KAMA1_2[i]) 
		SetCell(t_id1, row, 8, tostring(t.KAMA2_1[i]),         t.KAMA2_1[i]) 
		SetCell(t_id1, row, 9, tostring(t.KAMA2_2[i]),         t.KAMA2_2[i]) 		
		SetCell(t_id1, row, 10, tostring(t.KAMA3_1[i]),         t.KAMA3_1[i]) 
		SetCell(t_id1, row, 11, tostring(t.KAMA3_2[i]),         t.KAMA3_2[i]) 		
		
		SetCell(t_id1, row, 12, tostring(t.Price_Enter[i]),    t.Price_Enter[i]) 
		SetCell(t_id1, row, 13, tostring(t.Price_Exit[i]),     t.Price_Exit[i])
		SetCell(t_id1, row, 14, tostring(t.Price_Slippage[i]), t.Price_Slippage[i]) 
		SetCell(t_id1, row, 15, tostring(t.Price_Profit[i]),   t.Price_Profit[i])
		SetCell(t_id1, row, 16, tostring(t.Status[i]),         t.Status[i]) 
		SetCell(t_id1, row, 17, tostring(t.Status_Change[i]),  t.Status_Change[i])

		end
end

function Refresh_Table_DAY_Trend()	  --���������� �������
		for i = 1, Num do
		local row = DeleteRow(t_id1,i)
		local row = InsertRow(t_id1,i)
		
		SetCell(t_id1, row, 1, tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2, tostring(t.Time[i]))	
		SetCell(t_id1, row, 3, tostring(t.State[i]),            t.State[i]) 
		
		--Global_Trend_Position Mini_Trend_Position
		SetCell(t_id1, row, 4, tostring(t.G_T_P[i]),            t.G_T_P[i]) 
		
	
		
		SetCell(t_id1, row, 5, tostring(t.MAX_Target[i]),         t.MAX_Target[i]) 
		SetCell(t_id1, row, 6, tostring(t.MIN_Target[i]),       t.MIN_Target[i]) 
		SetCell(t_id1, row, 7, tostring(t.Donch_Middle[i]),     t.Donch_Middle[i]) 
		SetCell(t_id1, row, 8, tostring(t.SAR1[i]),             t.SAR1[i]) 		
		SetCell(t_id1, row, 9, tostring(t.SAR2[i]),             t.SAR2[i]) 
		
		SetCell(t_id1, row, 10, tostring(t.Status[i]),          t.Status[i]) 
		SetCell(t_id1, row, 11, tostring(t.Status_Change[i]),   t.Status_Change[i])

		end
end

function Refresh_Table_Elder()	  --���������� �������
		for i = 1, Num do
		local row = DeleteRow(t_id1,i)
		local row = InsertRow(t_id1,i)
		
		SetCell(t_id1, row, 1, tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2, tostring(t.Time[i]))	
		SetCell(t_id1, row, 3, tostring(t.State[i]),           t.State[i]) 
		
		--Global_Trend_Position Mini_Trend_Position
		SetCell(t_id1, row, 4, tostring(t.G_T_P[i]),           t.G_T_P[i]) 
		SetCell(t_id1, row, 5, tostring(t.M_T_P[i]),           t.M_T_P[i]) 
			
		SetCell(t_id1, row, 6 , tostring(t.MACD1[i]),          t.MACD1[i]) 
		SetCell(t_id1, row, 7 , tostring(t.MACD2[i]),          t.MACD2[i]) 
		SetCell(t_id1, row, 8 , tostring(t.MACD_S1[i]),        t.MACD_S1[i]) 
		SetCell(t_id1, row, 9 , tostring(t.MACD_S2[i]),        t.MACD_S2[i]) 		
		SetCell(t_id1, row, 10, tostring(t.MACD_H1[i]),        t.MACD_H1[i]) 
		SetCell(t_id1, row, 11, tostring(t.MACD_H2[i]),        t.MACD_H2[i]) 	
		SetCell(t_id1, row, 12, tostring(t.MACD_H_mini1[i]),   t.MACD_H_mini1[i]) 		
		SetCell(t_id1, row, 13, tostring(t.MACD_H_mini2[i]),   t.MACD_H_mini2[i]) 
		SetCell(t_id1, row, 14, tostring(t.DEV[i]),            t.DEV[i]) 	
		
	  
		SetCell(t_id1, row, 15, tostring(t.Price_Enter[i]),    t.Price_Enter[i]) 
		SetCell(t_id1, row, 16, tostring(t.Price_Exit[i]),     t.Price_Exit[i])
		SetCell(t_id1, row, 17, tostring(t.Price_Slippage[i]), t.Price_Slippage[i]) 
		SetCell(t_id1, row, 18, tostring(t.Price_Profit[i]),   t.Price_Profit[i])
		SetCell(t_id1, row, 19, tostring(t.Status[i]),         t.Status[i]) 
		SetCell(t_id1, row, 20, tostring(t.Status_Change[i]),  t.Status_Change[i])

		end
end



function Refresh_Table_Elder_v3()	  --���������� �������
		for i = 1, Num do
		local row = DeleteRow(t_id1,i)
		local row = InsertRow(t_id1,i)
		
		SetCell(t_id1, row, 1, tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2, tostring(t.Time[i]))	
		SetCell(t_id1, row, 3, tostring(t.State[i]),           t.State[i]) 
		
		--Global_Trend_Position Mini_Trend_Position
		SetCell(t_id1, row, 4, tostring(t.G_T_P[i]),           t.G_T_P[i]) 
		SetCell(t_id1, row, 5, tostring(t.M_T_P[i]),           t.M_T_P[i]) 
			
		SetCell(t_id1, row, 6 , tostring(t.MACD1[i]),          t.MACD1[i]) 
		SetCell(t_id1, row, 7 , tostring(t.MACD2[i]),          t.MACD2[i]) 
		SetCell(t_id1, row, 8 , tostring(t.MACD_S1[i]),        t.MACD_S1[i]) 
		SetCell(t_id1, row, 9 , tostring(t.MACD_S2[i]),        t.MACD_S2[i]) 		
		--SetCell(t_id1, row, 10, tostring(t.MACD_H1[i]),        t.MACD_H1[i]) 
		--SetCell(t_id1, row, 11, tostring(t.MACD_H2[i]),        t.MACD_H2[i]) 	
		SetCell(t_id1, row, 10, tostring(t.MACD_H_mini1[i]),   t.MACD_H_mini1[i]) 		
		SetCell(t_id1, row, 11, tostring(t.MACD_H_mini2[i]),   t.MACD_H_mini2[i]) 
		SetCell(t_id1, row, 12, tostring(t.DEV[i]),            t.DEV[i]) 	
		
		SetCell(t_id1, row, 13, tostring(t.EMA_L[i]),          t.EMA_L[i]) 
		SetCell(t_id1, row, 14, tostring(t.EMA_H[i]),          t.EMA_H[i])
		SetCell(t_id1, row, 15, tostring(t.Donch_L[i]),        t.Donch_L[i]) 
		SetCell(t_id1, row, 16, tostring(t.Donch_H[i]),        t.Donch_H[i])
		
		SetCell(t_id1, row, 17, tostring(t.Price_Enter[i]),    t.Price_Enter[i]) 
		SetCell(t_id1, row, 18, tostring(t.Price_Exit[i]),     t.Price_Exit[i])
		SetCell(t_id1, row, 19, tostring(t.Price_Slippage[i]), t.Price_Slippage[i]) 
		SetCell(t_id1, row, 20, tostring(t.Price_Profit[i]),   t.Price_Profit[i])
		SetCell(t_id1, row, 21, tostring(t.Status[i]),         t.Status[i]) 
		SetCell(t_id1, row, 22, tostring(t.Status_Change[i]),  t.Status_Change[i])
		
		end
end

--�������:  |  Ticker|  Current_Position  |  Set_Position                   | BUY_PRICE |  SELL_PRICE |  Close_H1     | Close_H0     |  Close_M1     | Close_M0     |
function Refresh_Table_Python_v1()	  --���������� �������
		for i = 1, Num do
		local row = DeleteRow(t_id1,i)
		local row = InsertRow(t_id1,i)

		SetCell(t_id1, row, 1 , tostring(t.Ticker[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		
		SetCell(t_id1, row, 2 , tostring(t.Current_Position[i]),    t.Current_Position[i]) 
		SetCell(t_id1, row, 3 , tostring(t.Set_Position[i]),        t.Set_Position[i])

		--SetCell(t_id1, row, 4 , tostring(t.BUY_PRICE[i]),           t.BUY_PRICE[i])
		--SetCell(t_id1, row, 5 , tostring(t.SELL_PRICE[i]),          t.SELL_PRICE[i])
		
		SetCell(t_id1, row, 4 , tostring(t.BUY_PRICE[i]))
		SetCell(t_id1, row, 5 , tostring(t.SELL_PRICE[i]))
		
		SetCell(t_id1, row, 6 , tostring(t.Close_H1[i]),            t.Close_H1[i])
		SetCell(t_id1, row, 7 , tostring(t.Close_H0[i]),            t.Close_H0[i])
		SetCell(t_id1, row, 8 , tostring(t.Close_M1[i]),            t.Close_M1[i])
		SetCell(t_id1, row, 9 , tostring(t.Close_M0[i]),            t.Close_M0[i])			
		
		end
end

function Create_Table_on_screen() --�������� ������� � ����� �� �� �����
	  	t_id1 = AllocTable()
		AddColumn(t_id1, 1, "Date",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 2, "Time",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 3, "Price",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 4, "P_LVL",           true, QTABLE_DOUBLE_TYPE, Num)		
		AddColumn(t_id1, 5, "P_Enter",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 6, "P_Exit",          true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 7, "P_Slippage",      true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 8, "P_Reverse",       true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 9, "Profit",          true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 10,"Status",          true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 11,"Status_Change",   true, QTABLE_DOUBLE_TYPE, Num)
		
		CreateWindow(t_id1)
		SetWindowCaption(t_id1, "Table of the current state")
		t = table.read(Path_Table)                                 -- ������ ��������� �������
        --t = {Date = {"20005555","20005555","20005555","20005555","20005555",},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, Price = {1,2,3,4,5}, Status = {11,22,33,44,55} }
		for i = 1, Num do
		
		local row = InsertRow(t_id1, -1)
		SetCell(t_id1, row, 1, tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2, tostring(t.Time[i]))	
		SetCell(t_id1, row, 3, tostring(t.Price[i]),           t.Price[i]) 
		SetCell(t_id1, row, 4, tostring(t.Price_LVL[i]),       t.Price_LVL[i]) 
		SetCell(t_id1, row, 5, tostring(t.Price_Enter[i]),     t.Price_Enter[i]) 
		SetCell(t_id1, row, 6, tostring(t.Price_Exit[i]),      t.Price_Exit[i])
		SetCell(t_id1, row, 7, tostring(t.Price_Slippage[i]),  t.Price_Slippage[i]) 
		SetCell(t_id1, row, 8, tostring(t.Price_Reverse[i]),   t.Price_Reverse[i])
		SetCell(t_id1, row, 9, tostring(t.Price_Profit[i]),    t.Price_Profit[i])
		SetCell(t_id1, row,10, tostring(t.Status[i]),          t.Status[i]) 
		SetCell(t_id1, row,11, tostring(t.Status_Change[i]),   t.Status_Change[i])
		end
end

function Create_Table_on_screen_KAMA() --�������� ������� � ����� �� �� �����
	  	t_id1 = AllocTable()
		AddColumn(t_id1, 1, "Date",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 2, "Time",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 3, "State",           true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 4, "G_T_P",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 5, "M_T_P",           true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 6, "KAMA1_1",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 7, "KAMA1_2",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 8, "KAMA2_1",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 9, "KAMA2_2",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 10,"KAMA3_1",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 11,"KAMA3_2",         true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 12, "P_Enter",        true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 13, "P_Exit",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 14, "P_Slippage",     true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 15, "Profit",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 16, "Status",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 17, "Status_Change",  true, QTABLE_DOUBLE_TYPE, Num)
		
		CreateWindow(t_id1)
		SetWindowCaption(t_id1, "Table of the current state")
		t = table.read(Path_Table)                                 -- ������ ��������� �������
        --t = {Date = {"20005555","20005555","20005555","20005555","20005555",},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, Price = {1,2,3,4,5}, Status = {11,22,33,44,55} }
		for i = 1, Num do
		
		local row = InsertRow(t_id1, -1)
		SetCell(t_id1, row, 1, tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2, tostring(t.Time[i]))	
		SetCell(t_id1, row, 3, tostring(t.State[i]),           t.State[i]) 
		
		SetCell(t_id1, row, 4, tostring(t.G_T_P[i]),           t.G_T_P[i]) 
		SetCell(t_id1, row, 5, tostring(t.M_T_P[i]),           t.M_T_P[i]) 
			
		SetCell(t_id1, row, 6, tostring(t.KAMA1_1[i]),         t.KAMA1_1[i]) 
		SetCell(t_id1, row, 7, tostring(t.KAMA1_2[i]),         t.KAMA1_2[i]) 
		SetCell(t_id1, row, 8, tostring(t.KAMA2_1[i]),         t.KAMA2_1[i]) 
		SetCell(t_id1, row, 9, tostring(t.KAMA2_2[i]),         t.KAMA2_2[i]) 		
		SetCell(t_id1, row, 10, tostring(t.KAMA3_1[i]),         t.KAMA3_1[i]) 
		SetCell(t_id1, row, 11, tostring(t.KAMA3_2[i]),         t.KAMA3_2[i]) 		
		
		SetCell(t_id1, row, 12, tostring(t.Price_Enter[i]),    t.Price_Enter[i]) 
		SetCell(t_id1, row, 13, tostring(t.Price_Exit[i]),     t.Price_Exit[i])
		SetCell(t_id1, row, 14, tostring(t.Price_Slippage[i]), t.Price_Slippage[i]) 
		SetCell(t_id1, row, 15, tostring(t.Price_Profit[i]),   t.Price_Profit[i])
		SetCell(t_id1, row, 16, tostring(t.Status[i]),         t.Status[i]) 
		SetCell(t_id1, row, 17, tostring(t.Status_Change[i]),  t.Status_Change[i])
		end
end

function Create_Table_on_screen_DAY_Trend() --�������� ������� � ����� �� �� �����
	  	t_id1 = AllocTable()
		AddColumn(t_id1, 1, "Date",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 2, "Time",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 3, "State",           true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 4, "G_T_P",           true, QTABLE_DOUBLE_TYPE, Num)

		
		AddColumn(t_id1, 5, "MAX_Target",        true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 6, "MIN_Target",      true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 7, "Donch_Middle",    true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 8, "SAR1",            true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 9, "SAR2",            true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 10, "Status",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 11, "Status_Change",  true, QTABLE_DOUBLE_TYPE, Num)
		
		CreateWindow(t_id1)
		SetWindowCaption(t_id1, "Table of the current state")
		t = table.read(Path_Table)                                 -- ������ ��������� �������
        --t = {Date = {"20005555","20005555","20005555","20005555","20005555",},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, Price = {1,2,3,4,5}, Status = {11,22,33,44,55} }
		for i = 1, Num do
		
		local row = InsertRow(t_id1, -1)
		SetCell(t_id1, row, 1, tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2, tostring(t.Time[i]))	
		SetCell(t_id1, row, 3, tostring(t.State[i]),            t.State[i]) 
		
		SetCell(t_id1, row, 4, tostring(t.G_T_P[i]),            t.G_T_P[i]) 
			
		SetCell(t_id1, row, 5, tostring(t.MAX_Target[i]),         t.MAX_Target[i]) 
		SetCell(t_id1, row, 6, tostring(t.MIN_Target[i]),       t.MIN_Target[i]) 
		SetCell(t_id1, row, 7, tostring(t.Donch_Middle[i]),     t.Donch_Middle[i]) 
		SetCell(t_id1, row, 8, tostring(t.SAR1[i]),             t.SAR1[i]) 		
		SetCell(t_id1, row, 9, tostring(t.SAR2[i]),             t.SAR2[i]) 
			
		SetCell(t_id1, row, 10, tostring(t.Status[i]),         t.Status[i]) 
		SetCell(t_id1, row, 11, tostring(t.Status_Change[i]),  t.Status_Change[i])
		end
end

function Create_Table_on_screen_DAY_Trend_Mul() --�������� ������� � ����� �� �� �����
	  	t_id1 = AllocTable()
		AddColumn(t_id1, 1, "Date",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 2, "Time",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 3, "State",           true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 4, "G_T_P",           true, QTABLE_DOUBLE_TYPE, Num)

		
		AddColumn(t_id1, 5, "ASK",             true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 6, "BID",             true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 7, "Donch_Middle",    true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 8, "SAR1",            true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 9, "SAR2",            true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 10,"SAR3",            true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 11, "Status",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 12, "Status_Change",  true, QTABLE_DOUBLE_TYPE, Num)
		
		CreateWindow(t_id1)
		SetWindowCaption(t_id1, "Table of the current state")
		t = table.read(Path_Table)                                 -- ������ ��������� �������
        --t = {Date = {"20005555","20005555","20005555","20005555","20005555",},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, Price = {1,2,3,4,5}, Status = {11,22,33,44,55} }
		for i = 1, Num do
		
		local row = InsertRow(t_id1, -1)
		SetCell(t_id1, row, 1, tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2, tostring(t.Time[i]))	
		SetCell(t_id1, row, 3, tostring(t.State[i]),            t.State[i]) 
		
		SetCell(t_id1, row, 4, tostring(t.G_T_P[i]),            t.G_T_P[i]) 
			
		SetCell(t_id1, row, 5, tostring(t.ASK[i]),              t.MAX_Target[i]) 
		SetCell(t_id1, row, 6, tostring(t.BID[i]),              t.MIN_Target[i]) 
		SetCell(t_id1, row, 7, tostring(t.Donch_Middle[i]),     t.Donch_Middle[i]) 
		SetCell(t_id1, row, 8, tostring(t.SAR1[i]),             t.SAR1[i]) 		
		SetCell(t_id1, row, 9, tostring(t.SAR2[i]),             t.SAR2[i]) 
		SetCell(t_id1, row, 10, tostring(t.SAR3[i]),            t.SAR3[i]) 
			
		SetCell(t_id1, row, 11, tostring(t.Status[i]),          t.Status[i]) 
		SetCell(t_id1, row, 12, tostring(t.Status_Change[i]),   t.Status_Change[i])
		end
end

function Create_Table_on_screen_Elder() --�������� ������� � ����� �� �� �����
	  	t_id1 = AllocTable()
		AddColumn(t_id1, 1, "Date",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 2, "Time",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 3, "State",           true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 4, "G_T_P",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 5, "M_T_P",           true, QTABLE_DOUBLE_TYPE, Num)
		
	  
		AddColumn(t_id1, 6, "MACD1",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 7, "MACD2",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 8, "MACD_S1",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 9, "MACD_S2",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 10,"MACD_H1",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 11,"MACD_H2",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 12,"H_mini1",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 13,"H_mini2",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 14,"DEV",             true, QTABLE_DOUBLE_TYPE, Num)
			
		AddColumn(t_id1, 15, "P_Enter",        true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 16, "P_Exit",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 17, "P_Slippage",     true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 18, "Profit",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 19, "Status",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 20, "Status_Change",  true, QTABLE_DOUBLE_TYPE, Num)
		
		CreateWindow(t_id1)
		SetWindowCaption(t_id1, "Table of the current state")
		t = table.read(Path_Table)                                 -- ������ ��������� �������
        --t = {Date = {"20005555","20005555","20005555","20005555","20005555",},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, Price = {1,2,3,4,5}, Status = {11,22,33,44,55} }
		for i = 1, Num do
		
		local row = InsertRow(t_id1, -1)
		SetCell(t_id1, row, 1 , tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2 , tostring(t.Time[i]))	
		SetCell(t_id1, row, 3 , tostring(t.State[i]),          t.State[i]) 
		
		SetCell(t_id1, row, 4 , tostring(t.G_T_P[i]),          t.G_T_P[i]) 
		SetCell(t_id1, row, 5 , tostring(t.M_T_P[i]),          t.M_T_P[i]) 
			
		SetCell(t_id1, row, 6 , tostring(t.MACD1[i]),          t.MACD1[i]) 
		SetCell(t_id1, row, 7 , tostring(t.MACD2[i]),          t.MACD2[i]) 
		SetCell(t_id1, row, 8 , tostring(t.MACD_S1[i]),        t.MACD_S1[i]) 
		SetCell(t_id1, row, 9 , tostring(t.MACD_S2[i]),        t.MACD_S2[i]) 		
		SetCell(t_id1, row, 10, tostring(t.MACD_H1[i]),        t.MACD_H1[i]) 
		SetCell(t_id1, row, 11, tostring(t.MACD_H2[i]),        t.MACD_H2[i]) 	
		SetCell(t_id1, row, 12, tostring(t.MACD_H_mini1[i]),   t.MACD_H_mini1[i]) 		
		SetCell(t_id1, row, 13, tostring(t.MACD_H_mini2[i]),   t.MACD_H_mini2[i]) 
		SetCell(t_id1, row, 14, tostring(t.DEV[i]),            t.DEV[i]) 	
		
	  
		SetCell(t_id1, row, 15, tostring(t.Price_Enter[i]),    t.Price_Enter[i]) 
		SetCell(t_id1, row, 16, tostring(t.Price_Exit[i]),     t.Price_Exit[i])
		SetCell(t_id1, row, 17, tostring(t.Price_Slippage[i]), t.Price_Slippage[i]) 
		SetCell(t_id1, row, 18, tostring(t.Price_Profit[i]),   t.Price_Profit[i])
		SetCell(t_id1, row, 19, tostring(t.Status[i]),         t.Status[i]) 
		SetCell(t_id1, row, 20, tostring(t.Status_Change[i]),  t.Status_Change[i])
		end
end


function Create_Table_on_screen_Elder_v3() --�������� ������� � ����� �� �� �����
	  	t_id1 = AllocTable()
		AddColumn(t_id1, 1, "Date",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 2, "Time",            true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 3, "State",           true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 4, "G_T_P",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 5, "M_T_P",           true, QTABLE_DOUBLE_TYPE, Num)
		
	  
		AddColumn(t_id1, 6, "MACD1",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 7, "MACD2",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 8, "MACD_S1",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 9, "MACD_S2",         true, QTABLE_DOUBLE_TYPE, Num)
		--AddColumn(t_id1, 10,"MACD_H1",         true, QTABLE_DOUBLE_TYPE, Num)
		--AddColumn(t_id1, 11,"MACD_H2",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 10,"H_mini1",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 11,"H_mini2",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 12,"DEV",             true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 13,"EMA_L",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 14,"EMA_H",           true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 15,"Donch_L",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 16,"Donch_H",         true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 17, "P_Enter",        true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 18, "P_Exit",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 19, "P_Slippage",     true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 20, "Profit",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 21, "Status",         true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 22, "Status_Change",  true, QTABLE_DOUBLE_TYPE, Num)
		
		CreateWindow(t_id1)
		SetWindowCaption(t_id1, "Table of the current state")
		t = table.read(Path_Table)                                 -- ������ ��������� �������
        --t = {Date = {"20005555","20005555","20005555","20005555","20005555",},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, Price = {1,2,3,4,5}, Status = {11,22,33,44,55} }
		for i = 1, Num do
		
		local row = InsertRow(t_id1, -1)
		SetCell(t_id1, row, 1 , tostring(t.Date[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		SetCell(t_id1, row, 2 , tostring(t.Time[i]))	
		SetCell(t_id1, row, 3 , tostring(t.State[i]),          t.State[i]) 
		
		SetCell(t_id1, row, 4 , tostring(t.G_T_P[i]),          t.G_T_P[i]) 
		SetCell(t_id1, row, 5 , tostring(t.M_T_P[i]),          t.M_T_P[i]) 
			
		SetCell(t_id1, row, 6 , tostring(t.MACD1[i]),          t.MACD1[i]) 
		SetCell(t_id1, row, 7 , tostring(t.MACD2[i]),          t.MACD2[i]) 
		SetCell(t_id1, row, 8 , tostring(t.MACD_S1[i]),        t.MACD_S1[i]) 
		SetCell(t_id1, row, 9 , tostring(t.MACD_S2[i]),        t.MACD_S2[i]) 		
		--SetCell(t_id1, row, 10, tostring(t.MACD_H1[i]),        t.MACD_H1[i]) 
		--SetCell(t_id1, row, 11, tostring(t.MACD_H2[i]),        t.MACD_H2[i]) 	
		SetCell(t_id1, row, 10, tostring(t.MACD_H_mini1[i]),   t.MACD_H_mini1[i]) 		
		SetCell(t_id1, row, 11, tostring(t.MACD_H_mini2[i]),   t.MACD_H_mini2[i]) 
		SetCell(t_id1, row, 12, tostring(t.DEV[i]),            t.DEV[i]) 	
		
		SetCell(t_id1, row, 13, tostring(t.EMA_L[i]),          t.EMA_L[i]) 
		SetCell(t_id1, row, 14, tostring(t.EMA_H[i]),          t.EMA_H[i])
		SetCell(t_id1, row, 15, tostring(t.Donch_L[i]),        t.Donch_L[i]) 
		SetCell(t_id1, row, 16, tostring(t.Donch_H[i]),        t.Donch_H[i])
		
		SetCell(t_id1, row, 17, tostring(t.Price_Enter[i]),    t.Price_Enter[i]) 
		SetCell(t_id1, row, 18, tostring(t.Price_Exit[i]),     t.Price_Exit[i])
		SetCell(t_id1, row, 19, tostring(t.Price_Slippage[i]), t.Price_Slippage[i]) 
		SetCell(t_id1, row, 20, tostring(t.Price_Profit[i]),   t.Price_Profit[i])
		SetCell(t_id1, row, 21, tostring(t.Status[i]),         t.Status[i]) 
		SetCell(t_id1, row, 22, tostring(t.Status_Change[i]),  t.Status_Change[i])
		end
end


--�������:  |  Ticker|  Current_Position  |  Set_Position                   |BUY_PRICE |  SELL_PRICE |  Close_H1     | Close_H0     |  Close_M1     | Close_M0     |
function Create_Table_on_screen_Python_v1() --�������� ������� � ����� �� �� �����
	  	t_id1 = AllocTable()
		AddColumn(t_id1, 1, "Ticker",          true, QTABLE_STRING_TYPE, Num)
		
		AddColumn(t_id1, 2, "Current_Position",true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 3, "Set_Position",    true, QTABLE_DOUBLE_TYPE, Num)
		
		AddColumn(t_id1, 4, "BUY_PRICE",       true, QTABLE_STRING_TYPE, Num)
		AddColumn(t_id1, 5, "SELL_PRICE",      true, QTABLE_STRING_TYPE, Num)
		
		AddColumn(t_id1, 6, "Close_H1",        true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 7, "Close_H0",        true, QTABLE_DOUBLE_TYPE, Num)		  
		AddColumn(t_id1, 8, "Close_M1",        true, QTABLE_DOUBLE_TYPE, Num)
		AddColumn(t_id1, 9, "Close_M0",        true, QTABLE_DOUBLE_TYPE, Num)
		
		CreateWindow(t_id1)
		SetWindowCaption(t_id1, "Table of the current state")
		t = table.read(Path_Table)                                 -- ������ ��������� �������
 
		for i = 1, Num do
		
		local row = InsertRow(t_id1, -1)
		SetCell(t_id1, row, 1 , tostring(t.Ticker[i])) --��� �������� �� ���������� ������ ������ �������� �value� �� ��������.
		
		SetCell(t_id1, row, 2 , tostring(t.Current_Position[i]),    t.Current_Position[i]) 
		SetCell(t_id1, row, 3 , tostring(t.Set_Position[i]),        t.Set_Position[i])

		--SetCell(t_id1, row, 4 , tostring(t.BUY_PRICE[i]),           t.BUY_PRICE[i])
		--SetCell(t_id1, row, 5 , tostring(t.SELL_PRICE[i]),          t.SELL_PRICE[i])
		
		SetCell(t_id1, row, 4 , tostring(t.BUY_PRICE[i]))
		SetCell(t_id1, row, 5 , tostring(t.SELL_PRICE[i]))
		
		SetCell(t_id1, row, 6 , tostring(t.Close_H1[i]),            t.Close_H1[i])
		SetCell(t_id1, row, 7 , tostring(t.Close_H0[i]),            t.Close_H0[i])
		SetCell(t_id1, row, 8 , tostring(t.Close_M1[i]),            t.Close_M1[i])
		SetCell(t_id1, row, 9 , tostring(t.Close_M0[i]),            t.Close_M0[i])		

		end
end


function Init_Table_if_not_exist() --�������� ��������� �������� � �������--���� ������� ���� !!!
    if io.open(Path_Table,"r") == nil then
        --��� ������������� �������
        t = {Date = {"20005555","20005555","20005555","20005555","20005555",},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, Price = {1,2,3,4,5}, Price_LVL = {1,2,3,4,5}, Price_Enter = {1,2,3,4,5}, Price_Exit = {1,2,3,4,5}, Price_Slippage = {1,2,3,4,5}, Price_Reverse = {1,2,3,4,5}, Price_Profit = {1,2,3,4,5}, Status = {11,22,33,44,55}, Status_Change = {11,22,33,44,55} } 
		 for i = 1, Num do
		 t.Date[i]            = "20141111"
		 t.Time[i]            = "00:00:00"		 
		 t.Price[i]           = 0 --���� �������� ��������� �����, �� ������� ���� ������
		 t.Price_LVL[i]       = 0 --������� ������� ������������ ����, ������������ ����� ������������ Status[i]=1,-1 ��� Status[i]=0 Price_LVL[i]=0
		 t.Price_Enter[i]     = 0 --����������� �������� ���� ����� �� ����������� �������, ���������� ����� ���������� ������
		 t.Price_Exit[i]      = 0 --����������� �������� ���� ������ �� ����������� �������, ���������� ����� ���������� ������
		 t.Price_Slippage[i]  = 0 --��������������� ������������� ����������� ��� ��������� ������������� ��� abs(Price_LVL[i]+PIP - Price_Enter[i])
		 t.Price_Reverse[i]   = 0 --���������� ���������� �������
		 t.Price_Profit[i]    = 0 --������� ������� �������
		 t.Status[i]          = 0 --��������� -1 � �������  1 � �������  0 �� �������
		 t.Status_Change[i]   = 0 --��� ���������� ���������� �� ���������� ��������� Status 1-��  0-���
		 end
		 table.save(t,Path_Table)                                   -- ����� 	
		 --������� �������, ���� ��� ���� --��������� ��� �������� !-------------------------------------------------------------------
		 Check_Current_position() --��������� ������� �������� ������� � ���������� � ���������� Current_Position --REAL_TRADE - ������������ 
		 Check_Count_position()   --��������� ��������� ������� �� ����� t.Status[i] ������ POSITION
		     while (Current_Position ~= POSITION*SIZE) do

             KILL_ALL_ORDERS() --������� ��� �������� ������ !!! ����� !!! --REAL_TRADE - ������������ 								
		     Trade_Ops() -- ������� ����������� ���������  --REAL_TRADE - ������������ 
		
             Check_Current_position() --��������� ������� �������� ������� � ���������� � ���������� Current_Position --REAL_TRADE - ������������ 
             Check_Count_position()   --��������� ��������� ������� �� ����� t.Status[i] ������ POSITION
             end
		---------------------------------------------------------------------------------------------------------------------------------	 
    end
end

function Init_Table_if_not_exist_KAMA() --�������� ��������� �������� � �������--���� ������� ���� !!!
    if io.open(Path_Table,"r") == nil then
        --��� ������������� �������
        t = {Date = {"20005555","20005555","20005555","20005555","20005555"},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, State = {1,2,3,4,5}, G_T_P = {1,2,3,4,5}, M_T_P = {1,2,3,4,5}, KAMA1_1 = {1,2,3,4,5},KAMA1_2 = {1,2,3,4,5},KAMA2_1 = {1,2,3,4,5},KAMA2_2 = {1,2,3,4,5}, KAMA3_1 = {1,2,3,4,5},KAMA3_2 = {1,2,3,4,5}, Price_Enter = {1,2,3,4,5}, Price_Exit = {1,2,3,4,5}, Price_Slippage = {1,2,3,4,5}, Price_Profit = {1,2,3,4,5}, Status = {11,22,33,44,55}, Status_Change = {11,22,33,44,55} } 
		 for i = 1, Num do
		 t.Date[i]            = "20141111"
		 t.Time[i]            = "00:00:00"	
		 t.State[i]           = 0 --��������� �������, � ������� ��� ���������
		 --Global_Trend_Position Mini_Trend_Position
		 t.G_T_P[i]           = 0
		 t.M_T_P[i]           = 0
		 
		 t.KAMA1_1[i]         = 0
		 t.KAMA1_2[i]         = 0
		 t.KAMA2_1[i]         = 0
		 t.KAMA2_2[i]         = 0
		 t.KAMA3_1[i]         = 0
		 t.KAMA3_2[i]         = 0
		 		
		 t.Price_Enter[i]     = 0 --����������� �������� ���� ����� �� ����������� �������, ���������� ����� ���������� ������
		 t.Price_Exit[i]      = 0 --����������� �������� ���� ������ �� ����������� �������, ���������� ����� ���������� ������
		 t.Price_Slippage[i]  = 0 --��������������� ������������� ����������� ��� ��������� ������������� ��� abs(Price_LVL[i]+PIP - Price_Enter[i])		
		 t.Price_Profit[i]    = 0 --������� ������� �������
		 t.Status[i]          = 0 --��������� -1 � �������  1 � �������  0 �� �������
		 t.Status_Change[i]   = 0 --��� ���������� ���������� �� ���������� ��������� Status 1-��  0-���
		 end
		 table.save(t,Path_Table)                                   -- ����� 	
	 
    end
end
function Init_Table_if_not_exist_DAY_Trend() --�������� ��������� �������� � �������--���� ������� ���� !!!
    if io.open(Path_Table,"r") == nil then
        --��� ������������� �������
        t = {Date = {"20005555","20005555","20005555","20005555","20005555"},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, State = {1,2,3,4,5}, G_T_P = {1,2,3,4,5}, MAX_Target = {1,2,3,4,5}, MIN_Target = {1,2,3,4,5},Donch_Middle = {1,2,3,4,5},SAR1 = {1,2,3,4,5},SAR2 = {1,2,3,4,5} , Status = {11,22,33,44,55}, Status_Change = {11,22,33,44,55}} 
		 for i = 1, Num do
		 t.Date[i]            = "20141111"
		 t.Time[i]            = "00:00:00"	
		 t.State[i]           = 0 --��������� �������, � ������� ��� ���������
		 --Global_Trend_Position Mini_Trend_Position
		 t.G_T_P[i]           = 0
		 t.MAX_Target[i]        = 0
		 
		 t.MIN_Target[i]      = 0
		 t.Donch_Middle[i]    = 0
		 t.SAR1[i]            = 0
		 t.SAR2[i]            = 0
		 		
		 t.Status[i]          = 0 --��������� -1 � �������  1 � �������  0 �� �������
		 t.Status_Change[i]   = 0 --��� ���������� ���������� �� ���������� ��������� Status 1-��  0-���
		 end
		 table.save(t,Path_Table)                                   -- ����� 	
	 
    end
end

function Init_Table_if_not_exist_DAY_Trend_Mul() --�������� ��������� �������� � �������--���� ������� ���� !!!
    if io.open(Path_Table,"r") == nil then
        --��� ������������� �������
        t = {Date = {"20005555","20005555","20005555","20005555","20005555"},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, State = {1,2,3,4,5}, G_T_P = {1,2,3,4,5}, ASK = {1,2,3,4,5}, BID = {1,2,3,4,5},Donch_Middle = {1,2,3,4,5},SAR1 = {1,2,3,4,5},SAR2 = {1,2,3,4,5} ,SAR3 = {1,2,3,4,5}, Status = {11,22,33,44,55}, Status_Change = {11,22,33,44,55}} 
		 for i = 1, Num do
		 t.Date[i]            = "20141111"
		 t.Time[i]            = "00:00:00"	
		 t.State[i]           = 0 --��������� �������, � ������� ��� ���������
		 --Global_Trend_Position Mini_Trend_Position
		 t.G_T_P[i]           = 0
		 t.ASK[i]             = 0		 
		 t.BID[i]             = 0
		 
		 t.Donch_Middle[i]    = 0
		 t.SAR1[i]            = 0
		 t.SAR2[i]            = 0
		 t.SAR3[i]            = 0
		 		
		 t.Status[i]          = 0 --��������� -1 � �������  1 � �������  0 �� �������
		 t.Status_Change[i]   = 0 --��� ���������� ���������� �� ���������� ��������� Status 1-��  0-���
		 end
		 table.save(t,Path_Table)                                   -- ����� 	
	 
    end
end

function Init_Table_if_not_exist_Elder() --�������� ��������� �������� � �������--���� ������� ���� !!!
    if io.open(Path_Table,"r") == nil then
        --��� ������������� �������
        t = {Date = {"20001010","20001010","20001010","20001010","20001010"},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, State = {1,2,3,4,5}, G_T_P = {1,2,3,4,5}, M_T_P = {1,2,3,4,5}, MACD1 = {1,2,3,4,5}, MACD2 = {1,2,3,4,5},MACD_S1 = {1,2,3,4,5},MACD_S2 = {1,2,3,4,5}, MACD_H1 = {1,2,3,4,5},MACD_H2 = {1,2,3,4,5},MACD_H_mini1 = {1,2,3,4,5}, MACD_H_mini2 = {1,2,3,4,5},DEV = {1,2,3,4,5}, Price_Enter = {1,2,3,4,5}, Price_Exit = {1,2,3,4,5}, Price_Slippage = {1,2,3,4,5}, Price_Profit = {1,2,3,4,5}, Status = {11,22,33,44,55}, Status_Change = {11,22,33,44,55} } 
		 for i = 1, Num do
		 t.Date[i]            = "20141111"
		 t.Time[i]            = "00:00:00"	
		 t.State[i]           = 0 --��������� �������, � ������� ��� ���������
		 --Global_Trend_Position Mini_Trend_Position
		 t.G_T_P[i]           = 0
		 t.M_T_P[i]           = 0
		 
		 t.MACD1[i]           = 0
		 t.MACD2[i]           = 0
		 t.MACD_S1[i]         = 0
		 t.MACD_S2[i]         = 0
		 t.MACD_H1[i]         = 0
		 t.MACD_H2[i]         = 0
		 t.MACD_H_mini1[i]    = 0
		 t.MACD_H_mini2[i]    = 0
		 t.DEV[i]             = 0		 
		 
		 		
		 t.Price_Enter[i]     = 0 --����������� �������� ���� ����� �� ����������� �������, ���������� ����� ���������� ������
		 t.Price_Exit[i]      = 0 --����������� �������� ���� ������ �� ����������� �������, ���������� ����� ���������� ������
		 t.Price_Slippage[i]  = 0 --��������������� ������������� ����������� ��� ��������� ������������� ��� abs(Price_LVL[i]+PIP - Price_Enter[i])		
		 t.Price_Profit[i]    = 0 --������� ������� �������
		 t.Status[i]          = 0 --��������� -1 � �������  1 � �������  0 �� �������
		 t.Status_Change[i]   = 0 --��� ���������� ���������� �� ���������� ��������� Status 1-��  0-���
		 end
		 table.save(t,Path_Table)                                   -- ����� 	
	 
    end
end

function Init_Table_if_not_exist_Elder_v3() --�������� ��������� �������� � �������--���� ������� ���� !!!
    if io.open(Path_Table,"r") == nil then
        --��� ������������� �������
        t = {Date = {"20001010","20001010","20001010","20001010","20001010"},Time = {"11:22:22","11:22:22","11:22:22","11:22:22","11:22:22"}, State = {1,2,3,4,5}, G_T_P = {1,2,3,4,5}, M_T_P = {1,2,3,4,5}, MACD1 = {1,2,3,4,5}, MACD2 = {1,2,3,4,5},MACD_S1 = {1,2,3,4,5},MACD_S2 = {1,2,3,4,5}, MACD_H_mini1 = {1,2,3,4,5}, MACD_H_mini2 = {1,2,3,4,5},DEV = {1,2,3,4,5},EMA_L = {1,2,3,4,5},EMA_H = {1,2,3,4,5},Donch_L = {1,2,3,4,5},Donch_H = {1,2,3,4,5}, Price_Enter = {1,2,3,4,5}, Price_Exit = {1,2,3,4,5}, Price_Slippage = {1,2,3,4,5}, Price_Profit = {1,2,3,4,5}, Status = {11,22,33,44,55}, Status_Change = {11,22,33,44,55} } 
		 for i = 1, Num do
		 t.Date[i]            = "20141111"
		 t.Time[i]            = "00:00:00"	
		 t.State[i]           = 0 --��������� �������, � ������� ��� ���������
		 --Global_Trend_Position Mini_Trend_Position
		 t.G_T_P[i]           = 0
		 t.M_T_P[i]           = 0
		 
		 t.MACD1[i]           = 0
		 t.MACD2[i]           = 0
		 t.MACD_S1[i]         = 0
		 t.MACD_S2[i]         = 0
		 t.MACD_H_mini1[i]    = 0
		 t.MACD_H_mini2[i]    = 0
		 t.DEV[i]             = 0		 
		 
		 t.EMA_L[i]           = 0
		 t.EMA_H[i]           = 0
		 t.Donch_L[i]         = 0
		 t.Donch_H[i]         = 0
		 		 		
		 t.Price_Enter[i]     = 0 --����������� �������� ���� ����� �� ����������� �������, ���������� ����� ���������� ������
		 t.Price_Exit[i]      = 0 --����������� �������� ���� ������ �� ����������� �������, ���������� ����� ���������� ������
		 t.Price_Slippage[i]  = 0 --��������������� ������������� ����������� ��� ��������� ������������� ��� abs(Price_LVL[i]+PIP - Price_Enter[i])		
		 t.Price_Profit[i]    = 0 --������� ������� �������
		 t.Status[i]          = 0 --��������� -1 � �������  1 � �������  0 �� �������
		 t.Status_Change[i]   = 0 --��� ���������� ���������� �� ���������� ��������� Status 1-��  0-���
		 
		 end
		 table.save(t,Path_Table)                                   -- ����� 	
	 
    end
end

--��������� ������� !!! ������ �� �������
--�������:  |  ����� |  ������� �������   |  ������� ������� ��� �� Python  |BUY_PRICE |  SELL_PRICE |  Close_H1[1]  | Close_H1[0]  |  Close_M1[1]  | Close_M1[0]  |
--�������:  |  Ticker|  Current_Position  |  Set_Position                   |BUY_PRICE |  SELL_PRICE |  Close_H1     | Close_H0     |  Close_M1     | Close_M0     |
function Init_Table_if_not_exist_Python_v1() --�������� ��������� �������� � �������--���� ������� ���� !!!
    if io.open(Path_Table,"r") == nil then
        --��� ������������� �������
        t = {Ticker = {"SiM9","SiM9"},Current_Position = {1,2}, Set_Position = {1,2}, BUY_PRICE = {1,2}, SELL_PRICE = {1,2}, Close_H1 = {1,2}, Close_H0 = {1,2}, Close_M1 = {1,2}, Close_M0 = {1,2}} 
		 for i = 1, Num do
		 t.Ticker[i]           = "SiM9"
		 
		 t.Current_Position[i] = 0
		 t.Set_Position[i]     = 0
		 
		 t.BUY_PRICE[i]        = "0"
		 t.SELL_PRICE[i]       = "0"
		 
		 t.Close_H1[i]         = 0
		 t.Close_H0[i]         = 0
		 
		 t.Close_M1[i]         = 0
		 t.Close_M0[i]         = 0
	 	 
		 end
		 table.save(t,Path_Table)                                   -- ����� 	 
    end
end

function SEND_ORDER_V2(PRICE,QUANTITY) --�������� �� ����� ����� ������ +0 ����� �� �������, ����� ���-����� �������� ����
      if     QUANTITY > 0 then
	  OPERATION = "B"
	  elseif QUANTITY < 0 then
	  OPERATION = "S"
	  QUANTITY=-QUANTITY   --������������� ������ ���������� ! ������� ������ !
	  end
	     if QUANTITY ~= 0 then
	     TRANS_ID = TRANS_ID+1	  
         local t = {
                        ["TRANS_ID"]=tostring(TRANS_ID),
						["ACTION"]="NEW_ORDER",
						["CLASSCODE"]=MARKET,
                        ["SECCODE"]=TICKER,                        
                        ["ACCOUNT"]=tostring(ACCOUNT),
                        ["CLIENT_CODE"]=CLIENT_CODE,
                        ["TYPE"]="L",
                        ["OPERATION"]=OPERATION,
						["PRICE"]=tostring(PRICE),                 --tostring(math.floor(a_price))
                        ["QUANTITY"]=tostring(QUANTITY)            --tostring(a_count)
                        --["EXPIRY_DATE"]="GTS",                        
                   }
            res=sendTransaction(t)
			return res
         end
end

function SEND_ORDER_V3(TICKER_,BUY_PRICE,SELL_PRICE,QUANTITY) --�������� �� ����� ����� ������ +0 ����� �� �������, ����� ���-����� �������� ����
      if     QUANTITY > 0 then
	  OPERATION = "B"
	  PRICE = BUY_PRICE
	  elseif QUANTITY < 0 then
	  OPERATION = "S"
	  QUANTITY=-QUANTITY   --������������� ������ ���������� ! ������� ������ !
	  PRICE = SELL_PRICE
	  end
	     if QUANTITY ~= 0 then
	     TRANS_ID = TRANS_ID+1	  
         local t = {
                        ["TRANS_ID"]=tostring(TRANS_ID),
						["ACTION"]="NEW_ORDER",
						["CLASSCODE"]=tostring(MARKET),
                        ["SECCODE"]=tostring(TICKER_),                        
                        ["ACCOUNT"]=tostring(ACCOUNT),
                        ["CLIENT_CODE"]=tostring(CLIENT_CODE),
                        ["TYPE"]="L",
                        ["OPERATION"]=tostring(OPERATION),
						["PRICE"]=tostring(PRICE),                 --tostring(math.floor(a_price))
                        ["QUANTITY"]=tostring(QUANTITY)            --tostring(a_count)
                        --["EXPIRY_DATE"]="GTS",                        
                   }
            res=sendTransaction(t)
			return res
         end
end
function SEND_ORDER(OPERATION,PRICE,QUANTITY) --��������
      if QUANTITY>0 then
	  TRANS_ID = TRANS_ID+1
      local t = {
                        ["TRANS_ID"]=tostring(TRANS_ID),
						["ACTION"]="NEW_ORDER",
						["CLASSCODE"]=MARKET,
                        ["SECCODE"]=TICKER,                        
                        ["ACCOUNT"]=tostring(ACCOUNT),
                        ["CLIENT_CODE"]=CLIENT_CODE,
                        ["TYPE"]="L",
                        ["OPERATION"]=OPERATION,
						["PRICE"]=tostring(PRICE),                 --tostring(math.floor(a_price))
                        ["QUANTITY"]=tostring(QUANTITY)            --tostring(a_count)
                        --["EXPIRY_DATE"]="GTS",                        
                }
            res=sendTransaction(t)
			return res
      end
end
function SEND_STOP_ORDER(OPERATION,PRICE,STOP_PRICE,QUANTITY) --�������� 
      if QUANTITY>0 then
	  TRANS_ID = TRANS_ID+1
      local  t = {
                        ["TRANS_ID"]=tostring(TRANS_ID),
						["ACTION"]="NEW_STOP_ORDER",
						["CLASSCODE"]=MARKET,
                        ["SECCODE"]=TICKER,                        
                        ["ACCOUNT"]=tostring(ACCOUNT),
                        ["CLIENT_CODE"]=CLIENT_CODE,
                        ["TYPE"]="L",
                        ["OPERATION"]=OPERATION,						
						["PRICE"]=tostring(PRICE),                 --tostring(math.floor(a_price))
						["STOPPRICE"]=tostring(STOP_PRICE),
                        ["QUANTITY"]=tostring(QUANTITY)            --tostring(a_count)
                        --["EXPIRY_DATE"]="GTS",    -- 0  ���� �������� ����� �� ��������� ������ ��� ��������              
                  }
            res=sendTransaction(t)
			return res
      end
end
function KILL_STOP_ORDER(NUMBER) --�������� -�������� ����� ����-������ ��� ��������
      
	  TRANS_ID = TRANS_ID+1
      local  t = {
                        ["TRANS_ID"]=tostring(TRANS_ID),
						["ACTION"]="KILL_STOP_ORDER",
						["STOP_ORDER_KEY"]=tostring(NUMBER),
						["CLASSCODE"]=MARKET,
                        ["SECCODE"]=TICKER,                        
                        ["ACCOUNT"]=tostring(ACCOUNT),
                        --["CLIENT_CODE"]=CLIENT_CODE,
                        --["TYPE"]="L",
                        --["OPERATION"]=OPERATION,						
						--["PRICE"]=tostring(PRICE),                 --tostring(math.floor(a_price))
						--["STOPPRICE"]=tostring(STOP_PRICE),
                        --["QUANTITY"]=tostring(QUANTITY)            --tostring(a_count)
                        --["EXPIRY_DATE"]="GTS",                        
                  }
            res=sendTransaction(t)
			return res      
end
function KILL_ORDER(NUMBER) --�������� -�������� ����� ������ ��� ��������     
	  TRANS_ID = TRANS_ID+1
      local  t = {
                        ["TRANS_ID"]=tostring(TRANS_ID),
						["ACTION"]="KILL_ORDER",
						["ORDER_KEY"]=tostring(NUMBER),  --�������� ������� !!!
						["CLASSCODE"]=MARKET,
                        ["SECCODE"]=TICKER,                        
                        ["ACCOUNT"]=tostring(ACCOUNT),
                        --["CLIENT_CODE"]=CLIENT_CODE,
                        --["TYPE"]="L",
                        --["OPERATION"]=OPERATION,						
						--["PRICE"]=tostring(PRICE),                 --tostring(math.floor(a_price))
						--["STOPPRICE"]=tostring(STOP_PRICE),
                        --["QUANTITY"]=tostring(QUANTITY)            --tostring(a_count)
                        --["EXPIRY_DATE"]="GTS",                        
                  }
            res=sendTransaction(t)
			return res
      
end
function KILL_ALL_STOP_ORDERS() --������� ��� �������� ����-������ !!! --����� ����� !!!
		for i = 0, getNumberOf("stop_orders")-1 do --������� ���� ������ � "������� ������"
		     if bit_set(getItem("stop_orders",i).flags,0)  then         --������� �������� ������
			 --getItem("orders",i).order_num  --������ �������
			 --message(" TTT "..getItem("orders",i).price,1)
			 --message(" TTT "..getItem("orders",i).order_num,1)
			 KILL_STOP_ORDER(getItem("stop_orders",i).order_num)             --�������� ������� !!!			 		
			 end	
		end 		
end
function KILL_ALL_ORDERS() --������� ��� �������� ������ !!! ����� !!!
		for i = 0, getNumberOf("orders")-1 do --������� ���� ������ � "������� ������"
		     if bit_set(getItem("orders",i).flags,0)  then         --������� �������� ������
			 --getItem("orders",i).order_num  --������ �������
			 --message(" TTT "..getItem("orders",i).price,1)
			 --message(" TTT "..getItem("orders",i).order_num,1)
			 KILL_ORDER(getItem("orders",i).order_num)             --�������� ������� !!!			 		
			 end	
		end 		
end
function ACTIVE_ORDERS() --������� ����������, ���� �� �������� ������ � ������� ���������� ����� �������� ������
   local count_of_active_orders = 0
		for i = 0, getNumberOf("orders") do --������� ���� ������ � "������� ������"
		     if bit_set(getItem("orders",i).flags,0)  then         --������� �������� ������
			 count_of_active_orders = count_of_active_orders + 1
			 --getItem("orders",i).order_num  --������ �������
			 --message(" TTT "..getItem("orders",i).price,1)
			 --message(" TTT "..getItem("orders",i).order_num,1)
			 --KILL_ORDER(getItem("orders",i).order_num)             --�������� ������� !!!			 		
			 end	
		end 
    return count_of_active_orders		
end
function table.val_to_str ( v )
   if "string" == type( v ) then
      v = string.gsub( v, "\n", "\\n" )
      if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
         return "'" .. v .. "'"
      end
      return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
   end
   return "table" == type( v ) and table.tostring( v ) or tostring( v )
end
function table.key_to_str ( k )
   if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
      return k
   end
   return "[" .. table.val_to_str( k ) .. "]"
end
-- �������������� ������� ��� ������� � ��������� ������������� � ������������ � ����������� ����� lua
function table.tostring( tbl )
   local result, done = {}, {}
   for k, v in ipairs( tbl ) do
      table.insert( result, table.val_to_str( v ) )
      done[ k ] = true
   end
   for k, v in pairs( tbl ) do
      if not done[ k ] then
         table.insert( result, table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
      end
   end
   return "{" .. table.concat( result, "," ) .. "}"
end
-- ���������� ������� ��� ������� � ����
function table.save(tbl,filename)
   local f,err = io.open(filename,"w")
   if not f then
      return nil,err
   end
   f:write(table.tostring(tbl))
   f:close()
   return true
end
-- ������ ������� �� ����� � ������� ��� �������
function table.read(filename)
   local f,err = io.open(filename,"r")
   if not f then
      return nil,err
   end   
   --local tbl = assert(loadstring("return " .. f:read("*a"))) ---������ ���� ��������������.
   
   local l = f:read("*a")
   --local tbl = assert(loadstring("return " .. l)) --- ���� 20201202 ��������� ?  # ��� Since Lua 5.2, loadstring has been replaced by load.
   local tbl = assert(load("return " .. l)) --- ���� 20220108 ������� ��������� !
   
   f:close()
   return tbl()
end

function ParseCSVLine(line,sep) -- �� ��� � ��� ��������
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then append it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end

function File_Read(filename)

local col = 1
local pat = "(.*)"
local A={};local B={};
--local A={};local B={};local C={};local D={};local E={};
--local F={};local G={};local H={};local I={};local J={};
--local K={};local L={};local M={};local N={};local O={};
--local P={};local Q={};local R={};local S={};local T={};
local file, err = io.open(filename,"r")
if err ~= nil then return {0},{0}; end --PrintDbgStr("err read file: "..err); --� ������ ���� �����-�� ����� ��� ����� ��� ��� ������� Nil ���������� 2 ������� � ������.
str = file:read()
if ( str~= nil and #str>0) then -- !!!�����, �� ���� �������� �� ������ ���� � ������ �����
	for var in string.gmatch (str, ";") do col=col+1 end
	for i = 2, col do pat = pat..";(.*)" end
	for line in io.lines(filename) do
	--PrintDbgStr(line)
	local _,_,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20 = string.find(line,pat)
	--PrintDbgStr(tostring(s1))
	table.insert(A,s1);table.insert(B,s2);
	--table.insert(A,s1);table.insert(B,s2);table.insert(C,s3);table.insert(D,s4);table.insert(E,s5);
	--table.insert(F,s6);table.insert(G,s7);table.insert(H,s8);table.insert(I,s9);table.insert(J,s10);
	--table.insert(K,s11);table.insert(L,s12);table.insert(M,s13);table.insert(N,s14);table.insert(O,s15);
	--table.insert(P,s16);table.insert(Q,s17);table.insert(R,s18);table.insert(S,s19);table.insert(T,s20);

	end
	file:close()
	table.remove(A,1);table.remove(B,1);
	--table.remove(A,1);table.remove(B,1);table.remove(C,1);table.remove(D,1);table.remove(E,1);
	--table.remove(F,1);table.remove(G,1);table.remove(H,1);table.remove(I,1);table.remove(J,1);
	--table.remove(K,1);table.remove(L,1);table.remove(M,1);table.remove(N,1);table.remove(O,1);
	--table.remove(P,1);table.remove(Q,1);table.remove(R,1);table.remove(S,1);table.remove(T,1);
	--Print_Table� Print_Table(S) Print_Table(T)
	return A,B
	--return A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T
else 
	return {0},{0}; --� ������ ���� �����-�� ����� ��� ����� ��� ��� ������� Nil ���������� 2 ������� � ������.
end
end