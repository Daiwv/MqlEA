//+------------------------------------------------------------------+
//|                                                       RSI EA.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
  input double RSI_BUY = 30;
  input double RSI_SELL = 80;
  input double RSI_DURATION = 14;
  input double Lots = 0.1;
  input double OrdersCapacity=1;
  input double TakeProfit = 3;
  input double StopLoss = 3; 
  input bool useStopLoss = true;
  int MagicNumber = 13297;
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      //计算RSI
      double myRSIValue = iRSI( _Symbol,PERIOD_M30, RSI_DURATION,PRICE_CLOSE,0);
      Comment ("RSI value: ", myRSIValue);
      int cnt = OrdersTotal();
      Print("Orders", cnt);  
      if (cnt >= OrdersCapacity) return;  
      if (isNewBar()){
      Print("NewBar", myRSIValue);
      //买入卖出策略
      int ticket;
      
      if (myRSIValue <= RSI_BUY) {
         if (useStopLoss) {
            ticket = OrderSend(_Symbol, OP_BUY, Lots, Ask, 3,Ask-StopLoss,Ask+TakeProfit,"RSI EA", MagicNumber,0, Green);
         }
         else {
            ticket = OrderSend(_Symbol, OP_BUY, Lots, Ask, 3,0,Ask+TakeProfit,"RSI EA", MagicNumber,0, Green); 
         }
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
               Print("Buy at :",OrderOpenPrice(), "RSI: ", myRSIValue);
           }
         else
            Print("Buy failed :",GetLastError());
         return;
      }  
      if (myRSIValue >= RSI_SELL) {
         if (useStopLoss) {
            ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+StopLoss,Bid-TakeProfit,"RSI EA",MagicNumber,0,Red);
         }
         else {
            ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,Bid-TakeProfit,"RSI EA",MagicNumber,0,Red);
         }
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
               Print("Sell at :",OrderOpenPrice(), "RSI: ", myRSIValue);
           }
         else
            Print("Sell failed : ",GetLastError());
        
      }

      }  
      return;   
  }

double LotsCount(int type) 
{
   double BuyLots=0;
   double SellLots=0;
   for (int t=0; t<OrdersTotal(); t++) 
   {
      bool cg=OrderSelect(t, SELECT_BY_POS, MODE_TRADES);
      if (cg == false) continue;
      if (OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber )BuyLots+=OrderLots();
      if (OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber )SellLots+=OrderLots();
   }
   return BuyLots+SellLots;
}


bool isNewBar()
  {
//--- memorize the time of opening of the last bar in the static variable
   static datetime last_time=0;
//--- current time
   datetime lastbar_time=SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);
    Print("Last bar time : ",lastbar_time);
//--- if it is the first call of the function
   if(last_time==0)
     {
      //--- set the time and exit
      last_time=lastbar_time;
      return(false);
     }

//--- if the time differs
   if(last_time!=lastbar_time)
     {
      //--- memorize the time and return true
      last_time=lastbar_time;
      return(true);
     }
//--- if we passed to this line, then the bar is not new; return false
   return(false);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
  
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
