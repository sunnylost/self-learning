val x = [ 5, 1, 6, 8 ]
val e = [];

5::x;

null x;

null e;

hd x;
tl x;

(*
if null e
then 0
else hd e

tl [ 9 ]
*)

val y = 5::6::x;

hd (tl (tl y));

fun sum_of_int_list( x: int list ) =
    if null x
    then 0
    else hd x + sum_of_int_list( tl x )

fun list_product( xs: int list ) =
    if null xs
    then 1
    else hd xs * list_product( tl xs )

fun countdown( x: int ) =
    if x > 1
    then x::countdown( x - 1 )
    else [ x ]

fun append( xs: int list, ys: int list ) = 
    if null xs
    then ys
    else ( hd xs )::append( tl xs, ys )

fun sum_pair_list( xs: ( int * int ) list ) =
    if null xs
    then 0
    else #1 ( hd xs ) + #2 ( hd xs ) + sum_pair_list( tl xs ) 

fun firsts( xs: ( int * int ) list ) =
    if null xs
    then []
    else ( #1 ( hd xs ) )::firsts( tl xs )

;sum_of_int_list( [ 1, 2, 3, 5 ] )
;list_product( [ 2, 5, 7 ])
;countdown( 12 )
;append( [ 1, 5, 6 ], [ 2, 5, 7 ] )
;sum_pair_list( [ (5, 8), (10, 12), (30, 25) ] ) = 90
;firsts [ (1, 5), (2, 10), (3, 5) ]
