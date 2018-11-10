BEGIN {
	FS = "," ;
}

{
	j = 0 ;
	total = 0 ;
	for( i = 9; i <= (NF-1) ; i ++ ) {
		total += j * $i ;
		j ++ ;
	}
	print $0 "," total ;
}
