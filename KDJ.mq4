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
input int kdj_period = 9;

input double Lots = 0.1;
input double OrdersCapacity=1;
input double TakeProfit = 300;
input double StopLoss = 300; 
input bool useStopLoss = false;
int MagicNumber = 13297;
  
void OnTick()
  {
     if (isNewBar()){
         double li[9];
         double hi[9];
         double cn = iClose(_Symbol, PERIOD_M30, 0);
         for (int i = 0; i < 9; i ++) {
            li[i] = iHigh("BTC", PERIOD_H4, i+1);
            hi[i] = iLow("BTC", PERIOD_H4, i+1);
         }
         double hn = ArrayMaximum(hi);
         double ln = ArrayMinimum(li);

         printf("Hn: %lf, Ln: %lf, Cn: %lf", hn, ln, cn);
         double RSV = (cn - ln) / (hn-ln) * 100;
         double K = 2 *lastK / 3 + RSV / 3;
         double D = 2 * lastD / 3 + K / 3;
         int ticket;
         if (lastK < lastD && K > D && K > 80 && D > 80) {
                 ticket = OrderSend(_Symbol, OP_BUY, Lots, Ask, 3,0,Ask+TakeProfit,"KDJ EA", MagicNumber,0, Green);
                       if(ticket>0)
                 {
                  if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
                     Print("Buy at :",OrderOpenPrice(), "K: ", K, "K_:", lastK, "D: ", D, "D_:", lastD);
                 }
               else
                  Print("Buy failed :",GetLastError());
          }
         if (lastK > lastD && K < D && K < 30 && D < 30) {
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
