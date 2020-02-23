//+------------------------------------------------------------------+
//|                                                          BOT.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include<Trade\Trade.mqh>
CTrade trade;

double Ask;
double Bid;
double PointTP=1;
double PointSL=1;
double TPbuy;
double SLbuy;

double TPsell;
double SLsell;
double volume=0.01;
//+------------------------------------------------------------------+
//| Inint Value                                                                 |
//+------------------------------------------------------------------+
void initValue() {
   Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   TPbuy=Ask+PointTP;
   SLbuy=Ask-PointSL;

   TPsell=Bid-PointTP;
   SLsell=Bid+PointSL;
}
//+------------------------------------------------------------------+
//|   set amount position                                                               |
//+------------------------------------------------------------------+
bool setPosition(int amount) {
   return PositionsTotal()< amount;
}
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
//---
   initValue();
   trade.Buy(volume,_Symbol,Ask,SLbuy,TPbuy,"Start");
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
//---

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
//---
   initValue();
   printf(trade.RequestTypeDescription());
   if(Ask >= trade.RequestTP()&& trade.RequestTypeDescription()== "buy") {
      printf("TPBuy");
      initValue();
      trade.Buy(volume,_Symbol,Ask,SLbuy,TPbuy,"TP condition BUY");
   } else if(Ask <= trade.RequestSL() && trade.RequestTypeDescription()== "buy" ) {
      printf("SLBuy");
      initValue();
      trade.Sell(volume,_Symbol,Ask,SLsell,TPsell,"SL condition SELL");

   } else if(Bid <= trade.RequestTP()&& trade.RequestTypeDescription()== "sell") {
      printf("TPsell");
      initValue();
      trade.Sell(volume,_Symbol,Ask,SLsell,TPsell,"TP condition SELL");
   } else if(Bid >= trade.RequestSL() && trade.RequestTypeDescription()== "sell" ) {
      printf("SLsell");
      initValue();
      trade.Buy(volume,_Symbol,Ask,SLbuy,TPbuy,"SL condition SELL");
   }


}
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade() {
//---


}
//+------------------------------------------------------------------+
