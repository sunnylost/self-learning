(* This is a comment. It begins with a parenthesis and a asterisk. *)

val x = 10;

(* dynamic environment: x --> 10 *)

val y = 20;

val z = y - x;

val abs_of_z = if z < 0 then 0 - z else z

val abs_of_z_simple = abs z;

val negative_num = ~5;

val w = x + negative_num;

val y = ~1; 
(* tilde means negative. *)

fun pow( x: int, y: int ) =
    if y = 0
    then 1
    else x * pow( x, y - 1 );

pow( 5, 2 )