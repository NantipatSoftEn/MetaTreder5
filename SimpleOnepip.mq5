//+------------------------------------------------------------------+
//|                                                 SimpleOnePip.mq5 |
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


   double PointProfit=0.00008;
   double PointStartOrder=0.00002; // this is 0.0001 = 1 pips
   double PointStopLoss=0.00010;
   
   double OpenOrderOfBuy=(Ask+(PointStartOrder));
   
   Print("OpenOrderOfBuyCheck",OpenOrderOfBuy);
   
   double CloseOrdeOfBuy=(Ask+(PointProfit)); // TakeProfit
   double StopLossOfBuy=Ask-(PointStopLoss);

   double OpenOrderOfSell=(Bid-(PointStartOrder));
   double CloseOrderOfSell=(Bid-(PointProfit));
   double StopLossOfSell=Bid+(PointStopLoss);
   
   double LotSize =  1;
   
   if(SetttingOrder(100))
     {
      trade.BuyStop(LotSize,OpenOrderOfBuy,_Symbol,0,CloseOrdeOfBuy,ORDER_TIME_GTC,0,"BuyStop");
      trade.SellStop(LotSize,OpenOrderOfSell,_Symbol,0,CloseOrderOfSell,ORDER_TIME_GTC,0,"SellStop");
     }

  }
//+------------------------------------------------------------------+

bool SetttingOrder(int Orders)
  {
   return PositionsTotal()< Orders && OrdersTotal()< Orders;
  }
//+------------------------------------------------------------------+
