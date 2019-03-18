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
void OnTick()
  {
//---
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   double PointProfit=0.00008;
   double PointStartOrder=0.00002; // this is 0.0001 = 1 pips
   double PointStopLoss=0.00300;

   double OpenOrderOfBuy=(Ask+(PointStartOrder));

//Print("OpenOrderOfBuyCheck",OpenOrderOfBuy);

   double CloseOrdeOfBuy=(Ask+(PointProfit)); // TakeProfit
   double StopLossOfBuy=Ask-(PointStopLoss);

   double OpenOrderOfSell=(Bid-(PointStartOrder));
   double CloseOrderOfSell=(Bid-(PointProfit));
   double StopLossOfSell=Bid+(PointStopLoss);

   double LotSize=1;
   double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
   double Balance=AccountInfoDouble(ACCOUNT_BALANCE);
   double Profit=Equity-Balance;
   Print("Profit=",Profit);
   Comment("Profit=",Profit);
// START
   trade.BuyStop(LotSize,OpenOrderOfBuy,_Symbol,StopLossOfBuy,CloseOrdeOfBuy,ORDER_TIME_GTC,0,"BuyStop");
   for(int i=PositionsTotal();i<5;i++)
     {
      ulong ticket=PositionGetTicket(i);
      Print(PositionGetDouble(POSITION_PRICE_OPEN),"= ",PositionGetDouble(POSITION_PRICE_CURRENT));
      if(PositionSelectByTicket(ticket))
        {
         if(PositionGetDouble(POSITION_PRICE_OPEN)!=PositionGetDouble(POSITION_PRICE_CURRENT))
           {
            trade.BuyStop(LotSize,OpenOrderOfBuy,_Symbol,StopLossOfBuy,CloseOrdeOfBuy,ORDER_TIME_GTC,0,"BuyStop");
            trade.SellStop(LotSize,OpenOrderOfSell,_Symbol,StopLossOfSell,CloseOrderOfSell,ORDER_TIME_GTC,0,"SellStop");
           }
        }
     }

   if(Profit>=100)
     {
      CloseAllPosition();
     }
  }
//+------------------------------------------------------------------+

bool SetttingOrder(int Orders)
  {
   return PositionsTotal()< Orders;
  }
//+------------------------------------------------------------------+
void CloseAllPosition()
  {
   Print("CloseAllPosition");
   Comment("CloseAllPosition");
   for(int i=PositionsTotal();i>=0;i--)
     {
      int ticket=PositionGetTicket(i);
      trade.PositionClose(ticket);
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
