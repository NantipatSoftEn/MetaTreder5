//+------------------------------------------------------------------+
//|                                      SimpleOrdersCancelRobot.mq5 |
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
   double Balance= AccountInfoDouble(ACCOUNT_BALANCE);
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   if(PositionsTotal()==0 && OrdersTotal()==0)
     {
      trade.BuyStop(0.10,Ask+50*_Point,_Symbol,0,Ask+300*_Point,ORDER_TIME_GTC,0,0);
      trade.SellStop(0.10,Bid-50*_Point,_Symbol,0,Bid-300*_Point,ORDER_TIME_GTC,0,0);
     }

   if(Balance!=Equity)
      CancelOrder();

  }
//+------------------------------------------------------------------+

void CancelOrder()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong OrderTicket=OrderGetTicket(i);
      trade.OrderDelete(OrderTicket);
     }
  }
//+------------------------------------------------------------------+
