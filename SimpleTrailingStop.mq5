//+------------------------------------------------------------------+
//|                                           SimpleTrailingStop.mq5 |
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
   double Ask =NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid =NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);


   double LotSize = 0.10;
   double StopLoss=(Ask-3*_Point);   // Ask -  5 point
   double TakeProFit=(Ask+50*_Point);
   if((PositionsTotal()==0))
     {
      trade.Buy(LotSize,_Symbol,Ask,StopLoss,(Ask+50*_Point),NULL);
      
      CheckTrailingStop(Ask);
      
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void CheckTrailingStop(double Ask)
  {
  // Set the desired Stop Loss to 5 point 
   double StopLoss=NormalizeDouble(Ask-6*_Point,_Digits);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      string symbol=PositionGetSymbol(i);
      if(_Symbol==symbol)
        {
         // get ticker
         ulong PositionTicket=PositionGetInteger(POSITION_TICKET);
         // get Current StopLoss
         double CurrentStopLoss=PositionGetDouble(POSITION_SL);
         Print("Ticket=",PositionTicket," CurrentStopLoss=",CurrentStopLoss," StopLoss=",StopLoss);
         if(CurrentStopLoss<StopLoss)
           {
            // Modify the StopLoss
            trade.PositionModify(PositionTicket,(CurrentStopLoss+10*_Point),0);
           }
        }
     }
  }
//+------------------------------------------------------------------+
/*
  bool  Buy( 
   double        volume,          // position volume 
   const string  symbol=NULL,     // symbol 
   double        price=0.0,       // execution price 
   double        sl=0.0,          // stop loss price 
   double        tp=0.0,          // take profit price 
   const string  comment=""       // comment 
   )
  */
//+------------------------------------------------------------------+
