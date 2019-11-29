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

   /*int PointProfit=50;  // 5000=50 
   int PointStartOrder=20; // 200=2.0
   int PointStopLoss=30; // 3000=30*/

   double OpenOrderOfBuy=(Ask-(Ask*(2*_Point)));
   double CloseOrdeOfBuy=Ask+(Ask*(2*_Point)); // TakeProfit
   double StopLossOfBuy=OpenOrderOfBuy-(OpenOrderOfBuy*(2*_Point));
   printf(Ask*(2*_Point));
   printf(Ask-(Ask*(2*_Point)));
   
   double OpenOrderOfSell=Bid+(Bid*(2*_Point));
   double CloseOrderOfSell=Bid-(Bid*(2*_Point));
   double StopLossOfSell=OpenOrderOfSell+(OpenOrderOfSell*(2*_Point));
   
   double LotSize=0.0100;
   if(SettingOrder(50))
     {
      
         trade.BuyLimit(LotSize,OpenOrderOfBuy,_Symbol,StopLossOfBuy,CloseOrdeOfBuy,ORDER_TIME_GTC,0,"Buy");
         trade.SellLimit(LotSize,OpenOrderOfSell,_Symbol,StopLossOfSell,CloseOrderOfSell,ORDER_TIME_GTC,0,"SELL");
         //trade.Buy(LotSize, _Symbol,0,0,0,"buy");
     }

  }

bool SettingOrder(int Orders)
  {
    return PositionsTotal()< Orders && OrdersTotal()< Orders;
  }


