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
double LotSize=1000;
int  point = 700;
double Increasing = 1.2;
string SYMBOL ="TRXUSDT.coss";

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(15);
   double Ask=NormalizeDouble(SymbolInfoDouble(SYMBOL,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(SYMBOL,SYMBOL_BID),_Digits);

   double OpenOrderOfBuy=(Ask-(Ask*(point*_Point))); // buy limit = down price
   double CloseOrdeOfBuy=Ask+(Ask*(point*_Point)); // TakeProfit
   double StopLossOfBuy=OpenOrderOfBuy-(OpenOrderOfBuy*(point*_Point));

   double OpenOrderOfSell=Bid+(Bid*(point*_Point));
   double CloseOrderOfSell=Bid-(Bid*(point*_Point));
   double StopLossOfSell=OpenOrderOfSell+(OpenOrderOfSell*(point*_Point));
   resetVolume();
   for(int i=0; i<10; i++)
     {
      trade.BuyLimit(LotSize,OpenOrderOfBuy-(i*_Point),_Symbol,StopLossOfBuy-(i*_Point),CloseOrdeOfBuy+(i*_Point),ORDER_TIME_GTC,0,"Buy");
      LotSize=(int)LotSize*Increasing;
     }
   resetVolume();
   for(int i=0; i<10; i++)
     {
      trade.SellLimit(LotSize,OpenOrderOfSell+(i*_Point),_Symbol,StopLossOfSell+(i*_Point),CloseOrderOfSell-(i*_Point),ORDER_TIME_GTC,0,"Sell");
      LotSize=(int)LotSize*Increasing;
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
   double StopLossOfBuy=OpenOrderOfBuy-(OpenOrderOfBuy*(point*_Point));

   double OpenOrderOfSell=Bid+(Bid*(point*_Point));
   double CloseOrderOfSell=Bid-(Bid*(point*_Point));
   double StopLossOfSell=OpenOrderOfSell+(OpenOrderOfSell*(point*_Point));
   /*if(Ask>=(OpenOrderOfBuy+(OpenOrderOfBuy*(1*_Point))))
     {
      printf("Ask =%G",(OpenOrderOfBuy+(OpenOrderOfBuy*(1*_Point))));
      CancelOrder();
     }*/
   /*ulong    ticket;
   double   open_price;
   double   initial_volume;
   datetime time_setup;
   string   symbol;
   string   type;
   long     order_magic;
   long     positionID;
   for(int i=OrdersTotal(); i>=0; i--)
     {
      if((ticket=OrderGetTicket(i))>0)
        {
         //--- return order properties
         open_price    =OrderGetDouble(ORDER_PRICE_OPEN);
         time_setup    =(datetime)OrderGetInteger(ORDER_TIME_SETUP);
         symbol        =OrderGetString(ORDER_SYMBOL);
         order_magic   =OrderGetInteger(ORDER_MAGIC);
         positionID    =OrderGetInteger(ORDER_POSITION_ID);
         initial_volume=OrderGetDouble(ORDER_VOLUME_INITIAL);
         type          =EnumToString(ENUM_ORDER_TYPE(OrderGetInteger(ORDER_TYPE)));
         //--- prepare and show information about the order
         printf("#ticket %d %s %G %s at %G was set up at %s",
                ticket,                 // order ticket
                type,                   // type
                initial_volume,         // placed volume
                symbol,                 // symbol
                open_price,             // specified open price
                TimeToString(time_setup)// time of order placing
               );
         if(type=="ORDER_TYPE_BUY_LIMIT")
           {
            printf("ORDER_TYPE_BUY_LIMIT");
            if(Ask>(OpenOrderOfBuy+(OpenOrderOfBuy*(1*_Point))))
              {
                  trade.OrderDelete(ticket);
              }
           }
         else if(type=="ORDER_TYPE_SELL_LIMIT")
           {
            printf("ORDER_TYPE_SELL_LIMIT");
            if(Bid>(OpenOrderOfSell+(OpenOrderOfSell*(1*_Point))))
              {
                  trade.OrderDelete(ticket);
              }
           }

        }
     }*/
  }

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   double OpenOrderOfBuy=(Ask-(Ask*(point*_Point))); // buy limit = down price
   double CloseOrdeOfBuy=Ask+(Ask*(point*_Point)); // TakeProfit
   double StopLossOfBuy=OpenOrderOfBuy-(OpenOrderOfBuy*(point*_Point));

   double OpenOrderOfSell=Bid+(Bid*(point*_Point));
   double CloseOrderOfSell=Bid-(Bid*(point*_Point));
   double StopLossOfSell=OpenOrderOfSell+(OpenOrderOfSell*(point*_Point));
   resetVolume();
   double LotBuy = LotSize;
   double LotSell = LotSize;
   for(int i=OrdersTotal(); i>=0; i--)
     {
      int ticket=OrderGetTicket(i);
      trade.OrderDelete(ticket);
      if(SettingOrder(20))
        {
         if(i<10)
           {

            trade.BuyLimit(LotBuy,OpenOrderOfBuy-(i*_Point),_Symbol,StopLossOfBuy-(i*_Point),CloseOrdeOfBuy+(i*_Point),ORDER_TIME_GTC,0,"Buy");
            LotBuy=(int)LotBuy*Increasing;
           }
         else
           {

            trade.SellLimit(LotSell,OpenOrderOfSell+(i*_Point),_Symbol,StopLossOfSell+(i*_Point),CloseOrderOfSell-(i*_Point),ORDER_TIME_GTC,0,"Sell");
            LotSell=(int)LotSell*Increasing;
           }

        }

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SettingOrder(int Orders)
  {
   return PositionsTotal()< Orders && OrdersTotal()< Orders;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void resetVolume()
  {
   LotSize=1000;
  }
/*
buy 10 and sell 10 first time only
every 15 sec  close and new order



if price change 1% of
*/
