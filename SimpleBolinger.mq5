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


   double PointProfit=0.00006;
   double PointStartOrder=0.00002; // this is 0.0001 = 1 pips
   double PointStopLoss=0.00002;

   double OpenOrderOfBuy=(Ask+(PointStartOrder));

   Print("OpenOrderOfBuyCheck",OpenOrderOfBuy);

   double CloseOrdeOfBuy=(Ask+(PointProfit)); // TakeProfit
   double StopLossOfBuy=Ask-(PointStopLoss);

   double OpenOrderOfSell=(Bid-(PointStartOrder));
   double CloseOrderOfSell=(Bid-(PointProfit));
   double StopLossOfSell=Bid+(PointStopLoss);

   double LotSize=1;

   if(SetttingOrder(6))
     {
      trade.BuyStop(LotSize,OpenOrderOfBuy,_Symbol,StopLossOfBuy,CloseOrdeOfBuy,ORDER_TIME_GTC,0,"BuyStop");
      trade.SellStop(LotSize,OpenOrderOfSell,_Symbol,StopLossOfSell,CloseOrderOfSell,ORDER_TIME_GTC,0,"SellStop");
     }

  }
//+------------------------------------------------------------------+

bool SetttingOrder(int Orders)
  {
   return PositionsTotal()< Orders && OrdersTotal()< Orders;
  }
//+------------------------------------------------------------------+
void  GenerateBollingerBands()
  {
   MqlRates PriceInfo[];

   ArraySetAsSeries(PriceInfo,true);
   int PriceData=CopyRates(Symbol(),Period(),0,3,PriceInfo);

   double UpperBandArray[];
   double LowerBandArray[];
   ArraySetAsSeries(UpperBandArray,true);
   ArraySetAsSeries(LowerBandArray,true);

   int BollingerBands=iBands(_Symbol,_Period,20,0,2,PRICE_CLOSE);
   
   
  
   CopyBuffer(BollingerBands,1,0,3,UpperBandArray);
   CopyBuffer(BollingerBands,2,0,3,LowerBandArray);

   double myUpperBandvalue  = UpperBandArray[0];
   double myLowerBandvalue  = LowerBandArray[0];

   double myLastUpperBandvalue  = UpperBandArray[1];
   double myLastLowerBandvalue  = LowerBandArray[1];

// check if we have a re-entry form belows
   string entry;
   if(PriceInfo[0].close>myLowerBandvalue && PriceInfo[1].close<myLastLowerBandvalue)
     {
      entry="buy";
     }

   if(PriceInfo[0].close>myUpperBandvalue && PriceInfo[1].close<myLastUpperBandvalue)
     {
      entry="Sell";
     }


   if(entry=="Sell" && PositionsTotal()<1)
     {
      trade.Buy(0.10,NULL,Bid,0,,NULL);
     }
   if(entry=="buy" && PositionsTotal()<1)
     {
      
     }

  }
 
//+------------------------------------------------------------------+
