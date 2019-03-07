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

   double OpenOrderAtThisPoint=(Bid-(50*_Point));
   double CloseOrderAtThisPoint=(Ask+(50*_Point)); // TakeProfit

   double StopLoss=Bid-(75*_Point);

   double MomentValue=GenerateMomentum();
   double LotSize=DynamicLotSize();

   if(MomentValue<99.99 && PositionsTotal()<2 && OrdersTotal()<2)
     {
      Comment("Week:",MomentValue,"LotSize:",LotSize);
      trade.BuyLimit(LotSize,OpenOrderAtThisPoint,_Symbol,StopLoss,CloseOrderAtThisPoint,ORDER_TIME_GTC,0,"Buy");
      //Print("OpenOrderAtThisPoint=",OpenOrderAtThisPoint," CloseOrderAtThisPoint=",CloseOrderAtThisPoint);
      //trade.SellLimit(LotSize,CloseOrderAtThisPoint,_Symbol,StopLoss,OpenOrderAtThisPoint,ORDER_TIME_GTC,0,"Sell");
     }
     CheckTrailingStop(Ask);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  GenerateMomentum()
  {
   double myPriceArray[];
   int iMomentumDefinition=iMomentum(_Symbol,_Period,14,PRICE_CLOSE);
   ArraySetAsSeries(myPriceArray,false);
   CopyBuffer(iMomentumDefinition,0,0,3,myPriceArray);
   double myMomentumValue=NormalizeDouble(myPriceArray[0],2);

   return myMomentumValue;
  }
//+------------------------------------------------------------------

double DynamicLotSize()
  {
   double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
   double LotSize=NormalizeDouble((Equity/100000),2);
   
   return LotSize;
  }
//+------------------------------------------------------------------+

void CheckTrailingStop(double Ask)
  {
// Set the desired Stop Loss to 100 point 
   double StopLoss=NormalizeDouble(Ask-100*_Point,_Digits);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      string symbol=PositionGetSymbol(i);
      Print(symbol,"=",_Symbol);
      if(_Symbol==symbol)
        {
  
         ulong PositionTicket=PositionGetInteger(POSITION_TICKET);
         
         double CurrentStopLoss=PositionGetDouble(POSITION_SL);

         if(CurrentStopLoss<StopLoss)
            trade.PositionModify(PositionTicket,(CurrentStopLoss+10*_Point),0);

        }
     }
  }
//+------------------------------------------------------------------+
