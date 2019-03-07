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
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   double OpenOrderAtThisPoint=(Bid-(50*_Point));
   double CloseOrderAtThisPoint=(Ask+(50*_Point)); // TakeProfit


   double StopLoss= 0;

   double MomentValue = GenerateMomentum();
   double LotSize = DynamicLotSize();
   
   
   if(MomentValue<99.99 && PositionsTotal()<10 && OrdersTotal()<10)
     {
      Comment("Week:" ,MomentValue,"LotSize:",LotSize);
      trade.BuyLimit(LotSize,OpenOrderAtThisPoint,_Symbol,StopLoss,CloseOrderAtThisPoint,ORDER_TIME_GTC,0,"Buy");
      //Print("OpenOrderAtThisPoint=",OpenOrderAtThisPoint," CloseOrderAtThisPoint=",CloseOrderAtThisPoint);
      //trade.SellLimit(LotSize,CloseOrderAtThisPoint,_Symbol,StopLoss,OpenOrderAtThisPoint,ORDER_TIME_GTC,0,"Sell");
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
//+------------------------------------------------------------------

double DynamicLotSize()
  {
   double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
   double LotSize=NormalizeDouble((Equity/100000),2);
   return LotSize;
  }
//+------------------------------------------------------------------+
