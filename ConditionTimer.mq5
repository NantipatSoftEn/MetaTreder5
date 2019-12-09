//+------------------------------------------------------------------+
//|                                               ConditionTimer.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include<Trade\Trade.mqh>
CTrade trade;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(15);
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   double OpenOrderOfBuy=(Ask-(Ask*(7*_Point))); // buy limit = down price
   double CloseOrdeOfBuy=Ask+(Ask*(7*_Point)); // TakeProfit
   double StopLossOfBuy=OpenOrderOfBuy-(OpenOrderOfBuy*(7*_Point));

   double OpenOrderOfSell=Bid+(Bid*(7*_Point));
   double CloseOrderOfSell=Bid-(Bid*(7*_Point));
   double StopLossOfSell=OpenOrderOfSell+(OpenOrderOfSell*(7*_Point));
   double LotSize=0.001;

   for(int i=0; i<10; i++)
     {
      trade.BuyLimit(LotSize,OpenOrderOfBuy-(i*_Point),_Symbol,StopLossOfBuy-(i*_Point),CloseOrdeOfBuy+(i*_Point),ORDER_TIME_GTC,0,"Buy");
     }

   for(int i=0; i<10; i++)
     {
      trade.SellLimit(LotSize,OpenOrderOfSell+(i*_Point),_Symbol,StopLossOfSell+(i*_Point),CloseOrderOfSell-(i*_Point),ORDER_TIME_GTC,0,"Buy");
     }

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
void OnTick()
  {
//---

   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   double OpenOrderOfBuy=(Ask-(Ask*(7*_Point))); // buy limit = down price
   double CloseOrdeOfBuy=Ask+(Ask*(7*_Point)); // TakeProfit
   double StopLossOfBuy=OpenOrderOfBuy-(OpenOrderOfBuy*(7*_Point));

   double OpenOrderOfSell=Bid+(Bid*(7*_Point));
   double CloseOrderOfSell=Bid-(Bid*(7*_Point));
   double StopLossOfSell=OpenOrderOfSell+(OpenOrderOfSell*(7*_Point));
   double LotSize=0.001;

   /*if(Ask>=(OpenOrderOfBuy+(OpenOrderOfBuy*(1*_Point))))
     {
          printf("Ask =%G",(OpenOrderOfBuy+(OpenOrderOfBuy*(1*_Point))));
          CancelOrder();
     }*/

   /*if(SettingOrder(20))
     {
         trade.BuyLimit(LotSize,OpenOrderOfBuy,_Symbol,StopLossOfBuy,CloseOrdeOfBuy,ORDER_TIME_GTC,0,"Buy");
         trade.SellLimit(LotSize,OpenOrderOfSell,_Symbol,StopLossOfSell,CloseOrderOfSell,ORDER_TIME_GTC,0,"SELL");
     }*/

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   datetime time_setup;
   for(int i=0; i<OrdersTotal(); i++)
     {
      int ticket=OrderGetTicket(i);
      time_setup    =(datetime)OrderGetInteger(ORDER_TIME_SETUP);
      datetime trade_server_time=TimeTradeServer();
      //printf("Local time: %s ,time_setup : %s  result=%d",TimeToString(trade_server_time,TIME_SECONDS),TimeToString(time_setup,TIME_SECONDS),TimeTradeServer()-time_setup);
      
      trade.OrderDelete(ticket);
     }
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   double OpenOrderOfBuy=(Ask-(Ask*(7*_Point))); // buy limit = down price
   double CloseOrdeOfBuy=Ask+(Ask*(7*_Point)); // TakeProfit
   double StopLossOfBuy=OpenOrderOfBuy-(OpenOrderOfBuy*(7*_Point));

   double OpenOrderOfSell=Bid+(Bid*(7*_Point));
   double CloseOrderOfSell=Bid-(Bid*(7*_Point));
   double StopLossOfSell=OpenOrderOfSell+(OpenOrderOfSell*(7*_Point));
   double LotSize=0.001;


   /*for(int i=0; i<10; i++)
     {
      trade.BuyLimit(LotSize,OpenOrderOfBuy-(i*_Point),_Symbol,StopLossOfBuy-(i*_Point),CloseOrdeOfBuy+(i*_Point),ORDER_TIME_GTC,0,"Buy");
     }

   for(int i=0; i<10; i++)
     {
      trade.SellLimit(LotSize,OpenOrderOfSell+(i*_Point),_Symbol,StopLossOfSell+(i*_Point),CloseOrderOfSell-(i*_Point),ORDER_TIME_GTC,0,"Buy");
     }*/

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SettingOrder(int Orders)
  {
   return PositionsTotal()< Orders && OrdersTotal()< Orders;
  }




/*
buy 10 and sell 10 first time only
every 15 sec  close and new order



if price change 1% of
*/
//+------------------------------------------------------------------+
