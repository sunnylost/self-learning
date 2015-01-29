fun swap( pr: int * int ) = 
    ( #2 pr, #1 pr )

fun sum_of_pair( pr1: int * int, pr2: int * int ) = 
    ( #1 pr1 ) + ( #2 pr1 ) + ( #1 pr2 ) + ( #2 pr2 )

val pr1 = ( 1, 2 )
val pr2 = ( 5, 6 )
;sum_of_pair( pr1, pr2 )

;swap( pr2 )