//+------------------------------------------------------------------+
//|                                                  SimpleLimit.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
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
   double Ask =NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid =NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

   // If no order  
   double OpenOrderAtThisPoint = (Bid-(5*_Point));
   double CloseOrderAtThisPoint = (Ask+(5*_Point)); // TakeProfit
   double LotSize = 0.10;
   double StopLoss= 0.10;
   
   if((OrdersTotal()==0) && (PositionsTotal()==0))
     {
                        
      trade.BuyLimit(LotSize,OpenOrderAtThisPoint,_Symbol,StopLoss,CloseOrderAtThisPoint,ORDER_TIME_GTC,0,"Buy");
      Print("OpenOrderAtThisPoint=",OpenOrderAtThisPoint," CloseOrderAtThisPoint=",CloseOrderAtThisPoint);
      
      trade.SellLimit(LotSize,CloseOrderAtThisPoint,_Symbol,StopLoss,OpenOrderAtThisPoint,ORDER_TIME_GTC,0,"Sell");
    
     }
    // ba
  }
//+------------------------------------------------------------------+
/*
bool  BuyLimit( 
   double                volume,                       // order volume 
   double                price,                        // order price 
   const string          symbol=NULL,                  // symbol 
   double                sl=0.0,                       // stop loss price 
   double                tp=0.0,                       // take profit price 
   ENUM_ORDER_TYPE_TIME  type_time=ORDER_TIME_GTC,     // order lifetime 
   datetime              expiration=0,                 // order expiration time 
   const string          comment=""                    // comment 
   )
*/
//+------------------------------------------------------------------+
