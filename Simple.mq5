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

   int PointProfit=200;
   int PointStartOrder=200;
   int PointStopLoss=300;

   double OpenOrderOfBuy=(Ask-(PointStartOrder*_Point));
   double CloseOrdeOfBuy=(Ask+(PointProfit*_Point)); // TakeProfit
   double StopLossOfBuy=Ask-(PointStopLoss*_Point);

   double OpenOrderOfSell=(Bid+(PointStartOrder*_Point));
   double CloseOrderOfSell=(Bid-(PointProfit*_Point));
   double StopLossOfSell=Bid+(PointStopLoss*_Point);

   double MomentValue=GenerateMomentum();
   double LotSize=DynamicLotSize();

   if(SetttingOrder(1))
     {
      
         Comment("Week:",MomentValue,"LotSize:",LotSize);
         trade.BuyLimit(LotSize,OpenOrderOfBuy,_Symbol,StopLossOfBuy,CloseOrdeOfBuy,ORDER_TIME_GTC,0,"Buy");
         //trade.Buy()
        
      
         //Comment("Strong:",MomentValue,"LotSize:",LotSize);
         //trade.SellLimit(LotSize,OpenOrderOfSell,_Symbol,StopLossOfSell,CloseOrderOfSell,ORDER_TIME_GTC,0,"Sell");
       
     }

   CheckTrailingStop(Ask);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SetttingOrder(int Orders)
  {
   return PositionsTotal()< Orders && OrdersTotal()< Orders;
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
