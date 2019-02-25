//+------------------------------------------------------------------+
//|                                                         Lean.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print("gg Init");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
void OnDeinit(const int reason)
  {
//---
   Print("gg OnDeinit remove");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   for(int x=PositionsTotal() ; x>=0; x--)
     {
      ulong ticket=PositionGetTicket(x);
      if(PositionSelectByTicket(ticket))
        {
         Print(x," " ,PositionGetInteger(POSITION_TYPE),
         " ", PositionGetDouble(POSITION_PRICE_OPEN),
         " ",PositionGetSymbol(POSITION_SYMBOL) 
         );

        }
     }
  }
//+------------------------------------------------------------------+
