//+------------------------------------------------------------------+
//|                                                 SimpleOnePip.mq5 |
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   double PointProfit=0.00008;
   double PointStartOrder=0.00002; // this is 0.0001 = 1 pips
   double PointStopLoss=0.00100;

   double OpenOrderOfBuy=(Ask+(PointStartOrder));



   double CloseOrdeOfBuy=(Ask+(PointProfit)); // TakeProfit
   double StopLossOfBuy=Ask-(PointStopLoss);

   double OpenOrderOfSell=(Bid-(PointStartOrder));
   double CloseOrderOfSell=(Bid-(PointProfit));
   double StopLossOfSell=Bid+(PointStopLoss);

   double LotSize=1;
   double Profit=TotalProfit();
   
   Print("Profit=",Profit);
   Comment("Profit=",Profit);
   
   if(Profit>=100)
     {
      CloseAllPosition();
     }

   int countBuy = CountTypeBuy();
   int countSell= CountTypeSell();

   Print("countBuy=",countBuy," countSell=",countSell);

   if(SetttingOrder(10))
     {
      if(countBuy>countSell)
        {
         trade.Sell(LotSize,_Symbol,OpenOrderOfSell,StopLossOfSell,CloseOrderOfSell,"Sell");
        }
      else if(countBuy<countSell)
        {
         trade.Buy(LotSize,_Symbol,OpenOrderOfBuy,StopLossOfBuy,CloseOrdeOfBuy,"Buy");
        }
      else if(countBuy==countSell)
        {
         trade.Buy(LotSize,_Symbol,OpenOrderOfBuy,StopLossOfBuy,CloseOrdeOfBuy,"Buy");
         trade.Sell(LotSize,_Symbol,OpenOrderOfSell,StopLossOfSell,CloseOrderOfSell,"Sell");
        }
     }

  }
//+------------------------------------------------------------------+

bool SetttingOrder(int Orders)
  {
   return PositionsTotal()<Orders; //&& OrdersTotal() < Orders;
  }
//+------------------------------------------------------------------+
void CloseAllPosition()
  {
   Print("CloseAllPosition");
//Comment("CloseAllPosition");
   for(int i=PositionsTotal();i>=0;i--)
     {
      int ticket=PositionGetTicket(i);
      trade.PositionClose(ticket);
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
double TotalProfit()
  {
   double pft=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(ticket>0)
        {
         if(PositionGetString(POSITION_SYMBOL)==Symbol())
           {
            pft+=PositionGetDouble(POSITION_PROFIT);
           }
        }
     }
   return(pft);
  }
//+------------------------------------------------------------------+

int CountTypeBuy()
  {
   int countBuy=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(ticket>0)
        {
         Print("POSITION_TYPE=",PositionGetInteger(POSITION_TYPE));
         if(PositionGetInteger(POSITION_TYPE)==0) // buy
            countBuy++;
        }
     }
   return countBuy;
  }
//+------------------------------------------------------------------+
int  CountTypeSell()
  {
   int countSell=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(ticket>0)
        {
         //Print("POSITION_TYPE=",PositionGetInteger(POSITION_TYPE));
         if(PositionGetInteger(POSITION_TYPE)==1) // sell
            countSell++;
        }
     }
   return countSell;
  }
//+------------------------------------------------------------------+
