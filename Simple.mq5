
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
void OnTick()
  {
//---
   double PriceOfBuy=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double PriceOfSell=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);


   double TakeProfitBuy=(PriceOfSell+(200*_Point)); //CloseOrderAtThisPoint and TakeProFit
   double StopLossBuy=(PriceOfBuy-(200*_Point)); //CloseOrderAtThisPoint and StopLoss

   double TakeProfitSell=(PriceOfSell-(200*_Point));
   double StopLossSell=(PriceOfBuy+(200*_Point));

   double LotSize=0.10;
   datetime DateTime=ORDER_TIME_GTC;
   
  double myMomentumValue = GenerateMomentum();
   if(myMomentumValue>100)
     {
      Comment("STORONG MOMENT");
      trade.SellLimit(LotSize,PriceOfSell,_Symbol,StopLossSell,TakeProfitSell,ORDER_TIME_GTC,0,"Buy");
     }
   if(myMomentumValue<99)
     {
      Comment("Week moment");
      trade.BuyLimit(LotSize,PriceOfBuy,_Symbol,StopLossBuy,TakeProfitBuy,ORDER_TIME_GTC,0,"Buy");
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  GenerateMomentum()
  {
   double myPriceArray[];
   int iMomentumDefinition=iMomentum(_Symbol,_Period,14,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,false);
   CopyBuffer(iMomentumDefinition,0,0,3,myPriceArray);
   double myMomentumValue=NormalizeDouble(myPriceArray[0],2);
   return myMomentumValue;
  } 
//+------------------------------------------------------------------+
