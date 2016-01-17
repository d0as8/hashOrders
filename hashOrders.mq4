//+------------------------------------------------------------------+
//|                                                   hashOrders.mq4 |
//|                                                            d0as8 |
//|                                                             1.00 |
//+------------------------------------------------------------------+
#property copyright "d0as8"
#property version   "1.00"
#property strict

void OnStart() {
   string orderStr = "";
   uchar order[], hash[], key[];

   for( int i = 0, total = OrdersTotal(); i < total; i++ ) {
      if( true == OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) {

         orderStr = OrderFormat();
         StringToCharArray( orderStr, order, 0, StringLen( orderStr ), CP_ACP );

         if ( 0 < CryptEncode( CRYPT_HASH_SHA1, order, key, hash ) ) {
            PrintFormat( "Order: '%s', SHA1: '%s'", orderStr, ArrayToHex( hash ) );
         } else {
            PrintFormat( "Order: '%s', ErrorCode: '%s'", orderStr, GetLastError() );
         }
      }
   }
}

const string OPERATION_TYPES[6] = { "BUY", "SELL", "BUYLIMIT", "SELLLIMIT", "BUYSTOP", "SELLSTOP" };

string OrderFormat() {
   return(
      StringFormat(
         "%d %s %s %.2f %s %.5f %.5f %.5f %G"
         , OrderTicket()
         , TimeToStr( OrderOpenTime() )
         , OPERATION_TYPES[OrderType()]
         , OrderLots()
         , OrderSymbol()
         , OrderOpenPrice()
         , OrderStopLoss()
         , OrderTakeProfit()
         , OrderCommission()
      )
   );
}

string ArrayToHex( uchar &array[] ) {
   string res="";

   for( int i = 0, count = ArraySize( array ); i < count; i++ ) {
      res += StringFormat( "%x" , array[i] );
   }

   return( res );
}