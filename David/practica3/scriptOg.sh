# for i in 0 

	for j in $(seq 1 4); do
		printf ">TEST%02d_%48s\n" $j "" | tr " " "-"
		rm popcount
		gcc popcount.c -o popcount -O$i -D TEST=$j -g
		./popcount
	done
#done
