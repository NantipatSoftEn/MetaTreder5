//+------------------------------------------------------------------+
//|                                                       Simple.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include<Trade\Trade.mqh>
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
void OnTick()=
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   double myPriceArray[];
   int iMomentumDefinition=iMomentum(_Symbol,_Period,14,PRICE_CLOSE);
   
   ArraySetAsSeries(myPriceArray,false);
   CopyBuffer(iMomentumDefinition,0,0,3,myPriceArray);
   
   double myMomentumValue=NormalizeDouble(myPriceArray[0],2);
//Print(myMomentumValue);
   double LotSize=1.00;//---
   
   if(myMomentumValue>100.0)
     {
      Comment("STORONG MOMENT");
      trade.Sell(LotSize,NULL,Bid,0,0,NULL);

     }
   if(myMomentumValue<99.9)
     {
      Comment("Week moment");
      trade.Buy(LotSize,NULL,Ask,0,0,NULL);
     }

  }
//+------------------------------------------------------------------+
