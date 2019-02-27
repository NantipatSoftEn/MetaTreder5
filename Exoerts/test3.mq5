//+------------------------------------------------------------------+
//|                                                        Lean2.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include  <Trade/Trade.mqh>
CTrade trade;

input double LotSize=0.01;
input int MagicNumber=65262;
input int Slippage=10;

int sarvalue;
double sar_value[];
double tpoint,bid,ask,tradenow,High[],Low[],Close[],Open[];
input double step=0.02;
input double maximum=0.2;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetDeviationInPoints(Slippage);
   trade.SetAsyncMode(false);
   tpoint=Point();
   sarvalue=iSAR(Symbol(),PERIOD_CURRENT,step,maximum);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print(sarvalue);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//Print( ArraySetAsSeries(sar_value,true));
   ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);
   bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
   ArraySetAsSeries(sar_value,true);
//Print(ask," ",bid);
   CopyBuffer(sarvalue,0,0,4,sar_value);
   Comment(sar_value[0]," ",
           sar_value[1]," ",
           sar_value[2]," ",
           sar_value[3]," "
           );

   if(IsNewCandle())
     {
      tradenow=1;
     }
   if(iLowF(Symbol(),0,2)<sar_value[2] && iHighF(Symbol(),0,1)>sar_value[1] && tradenow==1)
     {
      trade.Buy(LotSize,NULL,ask,0,NULL);
      tradenow=0;
     }

   if(iLowF(Symbol(),0,2)>sar_value[2] && iHighF(Symbol(),0,1)<sar_value[1] && tradenow==1)
     {
      trade.Sell(LotSize,NULL,bid,0,NULL);
      tradenow=0;
     }

  }
//+------------------------------------------------------------------+
bool IsNewCandle()
  {
   static int BarOnChart=0;
   if(Bars(_Symbol,PERIOD_CURRENT)==BarOnChart)
      return false;

   BarOnChart=Bars(_Symbol,PERIOD_CURRENT);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iLowF(string symbol,ENUM_TIMEFRAMES timeframe,int index)
  {
   double low=0;
   ArraySetAsSeries(High,true);
   int copied=CopyHigh(symbol,timeframe,0,Bars(symbol,timeframe),Low);

   if(copied>0 && index<copied) low=Low[index];
   return low;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iHighF(string symbol,ENUM_TIMEFRAMES timeframe,int index)
  {
   double high=0;
   ArraySetAsSeries(High,true);
   int copied=CopyHigh(symbol,timeframe,0,Bars(symbol,timeframe),High);

   if(copied>0 && index<copied) high=High[index];
   return high;
  }

//+------------------------------------------------------------------+
