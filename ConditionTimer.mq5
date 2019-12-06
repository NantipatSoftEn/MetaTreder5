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
   EventSetTimer(1);
   
   
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
   
   if(Ask>=(OpenOrderOfBuy+(OpenOrderOfBuy*(1*_Point))))
     {
          printf("Ask =%G",(OpenOrderOfBuy+(OpenOrderOfBuy*(1*_Point))));
          CancelOrder();     
     }
     
     
   if(SettingOrder(20))
     {
         trade.BuyLimit(LotSize,OpenOrderOfBuy,_Symbol,StopLossOfBuy,CloseOrdeOfBuy,ORDER_TIME_GTC,0,"Buy");
         trade.SellLimit(LotSize,OpenOrderOfSell,_Symbol,StopLossOfSell,CloseOrderOfSell,ORDER_TIME_GTC,0,"SELL");
     }
      
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---   
      CancelOrder();
  }
//+------------------------------------------------------------------+

bool SettingOrder(int Orders)
  {
    return PositionsTotal()< Orders && OrdersTotal()< Orders;
  }
  
  
void CancelOrder()
  {
      datetime time_setup; 
      for(int i=0;i<OrdersTotal();i++)
      {
         int ticket=OrderGetTicket(i);
         time_setup    =(datetime)OrderGetInteger(ORDER_TIME_SETUP);
         datetime trade_server_time=TimeTradeServer(); 
         printf("Local time: %s ,time_setup : %s  result=%d",TimeToString(trade_server_time,TIME_SECONDS),TimeToString(time_setup,TIME_SECONDS),TimeTradeServer()-time_setup);
 
         if(TimeTradeServer()-time_setup>=15)
           {
            printf("OrderDelete");
            trade.OrderDelete(ticket);
           }
      }
  }
