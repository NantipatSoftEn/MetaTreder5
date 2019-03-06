//+------------------------------------------------------------------+
//|                                         SimpleDynamicLotSize.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
CTrade trade;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
   Print("Equity ",Equity);
   double DynamicPositionSize=NormalizeDouble((2000/100000),2);
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   //Print(Ask);
   Print(DynamicPositionSize);
   if(PositionsTotal()<100 && OrdersTotal()<100)
     {
      trade.BuyStop(DynamicPositionSize,Ask+100*_Point,_Symbol,0,Ask+300*_Point,ORDER_TIME_GTC,0,0);
      Comment("Dynamic Position Siz:",DynamicPositionSize);

     }
  }
//+------------------------------------------------------------------+
