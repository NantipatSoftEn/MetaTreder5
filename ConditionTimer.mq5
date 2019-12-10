#property copyright "Copyright 2019, copyright to xHUB Trade CO. LTD."
#property link      "https://fxstockbroker.com"
#property version   "1.00"
#include<Trade\Trade.mqh>
CTrade trade;


double LotSize=1000;
double Increasing = 1.2;
int  point = 700;
int amountOrder =20;
double Ask;
double Bid;
double OpenOrderOfBuy;
double CloseOrdeOfBuy;
double StopLossOfBuy;

double OpenOrderOfSell;
double CloseOrderOfSell;
double StopLossOfSell;

int Second = 15;
int PriceChange = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(Second);
   setValue();
   resetVolume();
   for(int i=0; i<(int)(amountOrder/2); i++)
     {
      BuyLimit(LotSize,OpenOrderOfBuy,StopLossOfBuy,CloseOrdeOfBuy,i);
      LotSize=mutiplyVolume(LotSize);
     }
   resetVolume();
   for(int i=0; i<(int)(amountOrder/2); i++)
     {
      SellLimit(LotSize,OpenOrderOfSell,StopLossOfSell,CloseOrderOfSell,i);
      LotSize=mutiplyVolume(LotSize);
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
   setValue();
   resetVolume();
   double LotBuy = LotSize;
   double LotSell = LotSize;
   ulong    ticket;
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
            if(Ask>(OpenOrderOfBuy+(OpenOrderOfBuy*(PriceChange*_Point))))
              {
               printf(OpenOrderOfBuy+(OpenOrderOfBuy*(PriceChange*_Point)));
               trade.OrderDelete(ticket);

               BuyLimit(LotBuy,OpenOrderOfBuy,StopLossOfBuy,CloseOrdeOfBuy,i);
               LotBuy=mutiplyVolume(LotBuy);
              }
           }
         else
            if(type=="ORDER_TYPE_SELL_LIMIT")
              {
               printf("ORDER_TYPE_SELL_LIMIT");
               if(Bid<(OpenOrderOfSell+(OpenOrderOfSell*(PriceChange*_Point))))
                 {
                  printf(OpenOrderOfSell+(OpenOrderOfSell*(PriceChange*_Point)));
                  trade.OrderDelete(ticket);
                  SellLimit(LotSell,OpenOrderOfSell,StopLossOfSell,CloseOrderOfSell,i);
                  LotSell=mutiplyVolume(LotSell);
                 }
              }

        }
     }
  }

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

   setValue();
   resetVolume();
   double LotBuy = LotSize;
   double LotSell = LotSize;
   for(int i=OrdersTotal(); i>=0; i--)
     {
      int ticket=OrderGetTicket(i);
      trade.OrderDelete(ticket);
      if(SettingOrder(amountOrder))
        {
         if(i<(int)(amountOrder/2))
           {

            BuyLimit(LotBuy,OpenOrderOfBuy,StopLossOfBuy,CloseOrdeOfBuy,i);
            LotBuy=mutiplyVolume(LotBuy);
           }
         else
           {
            SellLimit(LotSell,OpenOrderOfSell,StopLossOfSell,CloseOrderOfSell,i);
            LotSell=mutiplyVolume(LotSell);
           }

        }

     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setValue()
  {
   Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   OpenOrderOfBuy=(Ask-(Ask*(point*_Point))); // buy limit = down price
   CloseOrdeOfBuy=Ask+(Ask*(point*_Point)); // TakeProfit
   StopLossOfBuy=OpenOrderOfBuy-(OpenOrderOfBuy*(point*_Point));

   OpenOrderOfSell=Bid+(Bid*(point*_Point));
   CloseOrderOfSell=Bid-(Bid*(point*_Point));
   StopLossOfSell=OpenOrderOfSell+(OpenOrderOfSell*(point*_Point));
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BuyLimit(double LotSize_p,double OpenOrderOfBuy_p,double StopLossOfBuy_p,double CloseOrdeOfBuy_p,int index)
  {
   trade.BuyLimit(LotSize_p,OpenOrderOfBuy_p-(index*_Point),_Symbol,StopLossOfBuy_p-(index*_Point),CloseOrdeOfBuy_p+(index*_Point),ORDER_TIME_GTC,0,"Buy");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SellLimit(double LotSize_p,double OpenOrderOfSell_p,double StopLossOfSell_p,double CloseOrderOfSell_p,int index)
  {
   trade.SellLimit(LotSize_p,OpenOrderOfSell+(index*_Point),_Symbol,StopLossOfSell+(index*_Point),CloseOrderOfSell-(index*_Point),ORDER_TIME_GTC,0,"Sell");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int mutiplyVolume(double LotOfType)
  {
   return (int)LotOfType*Increasing;
  }

/*
buy 10 and sell 10 first time only
every 15 sec  close and new order

if price change 1% of
*/
