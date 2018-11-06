//+------------------------------------------------------------------+
//|                                                          KDJ.mq4 |
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
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
double lastK = 50;
double lastD = 50;
input int short_period = 6;
input int long_period = 24;
input double Lots = 0.1;
input double TakeProfit = 200;
input double StopLoss = 200; 
input double buyBar = 30;
input double sellBar = 70;
input bool useStopLoss = false;
int MagicNumber = 13297;
bool isJX = false;
bool isSX = false;
  
void OnTick()
  {
     if (isNewBar()){
      
         double K = iRSI(_Symbol, _Period, short_period, PRICE_CLOSE, 0);
         Comment ("RSI value: ", K);
         double D = iRSI(_Symbol, _Period, long_period, PRICE_CLOSE, 0);
         int ticket;
 
         if (lastK < lastD && K > D) isJX = true;
         if (lastK > lastD && K < D) isSX = true;
         if (K < D) isJX = false;
         if (K > D) isSX = false;
         
         if (isJX && K < buyBar) {
                if (useStopLoss){
                
                 ticket = OrderSend(_Symbol, OP_BUY, Lots, Ask, 3,Ask-StopLoss,Ask+TakeProfit,"KDJ EA", MagicNumber,0, Green);
                 }
                 else {
                 ticket = OrderSend(_Symbol, OP_BUY, Lots, Ask, 3,0,Ask+TakeProfit,"KDJ EA", MagicNumber,0, Green);
                 }
                 if(ticket>0)    
                 {
                  if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
                     Print("Buy at :",OrderOpenPrice(), "K: ", K, "K_:", lastK, "D: ", D, "D_:", lastD);
                 }
               else
                  Print("Buy failed :",GetLastError());
          }
         if (isSX && K > sellBar) {
                 if (useStopLoss)
                 ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+StopLoss,Bid-TakeProfit,"KDJ EA",MagicNumber,0,Red);
                 else 
                 ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,Bid-TakeProfit,"KDJ EA",MagicNumber,0,Red);
           if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
               Print("Sell at :",OrderOpenPrice(), "K: ", K, "K_:", lastK, "D: ", D, "D_:", lastD);
           }
         else
            Print("Sell failed :",GetLastError());
         }
   
         lastK = K;
         lastD = D;
      }
//---
   
  }
  
  
bool isNewBar()
  {
//--- memorize the time of opening of the last bar in the static variable
   static datetime last_time=0;
//--- current time
   datetime lastbar_time=SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);

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
