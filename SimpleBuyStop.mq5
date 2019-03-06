//+------------------------------------------------------------------+
//|                                                SimpleBuyStop.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\trade.mqh>
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
   double Balance=AccountInfoDouble(ACCOUNT_BALANCE);
   double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
   //Print(Ask," ",Bid);
   Print("Ask=",Ask);
   Print("Ask*100=",Ask*100*_Point);
   Print("Equity=",Equity,"Balance=",Balance);
   if((Equity==Balance) && (OrdersTotal()==0))
     {
      //--- Buy stop, 10 microlots, 100 point, above Ask, no SL,
      //--- 300 point TP, no expiration, no date, no comment
      trade.BuyStop(10.00,Ask+100*_Point,_Symbol,0,Ask+300 *_Point,ORDER_TIME_GTC,0,0);
      //--- Sell stop, 10 microlots, 100 point, above Bid, no SL,
      //--- 300 point TP, no expiration, no date, no comment
      trade.SellStop(10.00,Bid-100*_Point,_Symbol,0,Bid-300 *_Point,ORDER_TIME_GTC,0,0);
      
       trade.BuyLimit(10.00,Bid-100*_Point,_Symbol,0,Bid-300 *_Point,ORDER_TIME_GTC,0,0);
     }
     
     
   //---
   if(Balance!=Equity)
     {
      CancelOrder();
     }
  }
//+------------------------------------------------------------------+
void  CancelOrder()
  {
  for(int i=OrdersTotal()-1;i>=0;i--)
    {
     ulong OrderTicket=OrderGetTicket(i);
     trade.OrderDelete(OrderTicket);
    }
  }
//+------------------------------------------------------------------+
