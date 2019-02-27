//+------------------------------------------------------------------+
//|                                                        Lean2.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include  <Treade/Trade.mqh>
CTrade trade;

input double LotSize=0.01;
input int MagicNumber=65262;
input int Slippage=10;

int sarvalue;
double sar_value[];

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
   trade.SetExportMagicNumber(MagicNumber);
   
   trade.SetDeviationInPoints(Slippage);
   
   trade.SetAsysncMode(false);
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
   CopyBuffer(sarvalue,0,0,4,sar_value);
   Print(sar_value[0]," ",
         sar_value[1]," ",
         sar_value[2]," ",
         sar_value[3]," "
         );
  }
//+------------------------------------------------------------------+
