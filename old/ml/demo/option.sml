fun countdown( x: int ) =
    if x = 0
    then [0]
    else x :: countdown( x - 1 )

fun max1( x: int list ) =
    if null x
    then 0
    else 
        if hd x > max1( tl x )
        then hd x
        else max1( tl x )

fun max2( x: int list ) = 
    if null x
    then 0
    else 
        let 
            val cur_max = max2( tl x )
        in
            if hd x > cur_max
            then hd x
            else cur_max
        end

fun max3( x: int list ) =
    if null x
    then NONE
    else  
        let 
            val tl_nums = max3( tl x )
            val hd_num  = hd x
        in
            if isSome tl_nums andalso hd_num < valOf tl_nums
            then tl_nums
            else SOME hd_num
        end

fun max4( x: int list ) =
    if null x
    then NONE
    else
        let
            fun max_tl( x: int list ) =
                if null ( tl x )
                then hd x
                else 
                    let 
                        val tl_nums = max_tl( tl x )
                        val hd_num  = hd x
                    in
                        if hd_num > tl_nums
                        then hd_num
                        else tl_nums
                    end 
        in
            SOME ( max_tl x )
        end

val xs = countdown 19
;max1( xs )
;max2( xs )
;valOf( max3( xs ) )
;valOf( max4( xs ) )