#!/usr/bin/env bash 

trap "kill 0" SIGINT

showResult()
{
	if [ $1 = 0 ]
	then
		echo -e "\033[1;32mTest${2} PASS"
	else
		echo -e "\033[31mTest${2} FAIL"
	fi
}

TESTS=(
	"./client -h 127.0.0.1 -p $1 -l rabj -LUGHNS" #Test 1
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy -LUGHNS" #Test 2
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy unkown -LUGHNS" #Test 3
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy -LUGNHS" #Test4
	"./client -h 127.0.0.1 -p $1 -l rysavy -L -U -G" #Test 5
	"./client -h 127.0.0.1 -p $1 -l rabj rabj rysavy rysavy -LUGHNS" #Test 6
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy rabj rysavy -LUGHNS" #Test 7
	"./client -h 127.0.0.1 -p $1 -l unkown unkown2 -L -U -GNHS" #Test 8
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy -LN" #Test9
	"./client -h 127.0.0.1 -p $1 -l rabj" #Test10 ------------------
	"./client -h 127.0.0.1 -p $1 -l unkown unkown2" #Test11
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy -G" #Test12
	"./client -h 127.0.0.1 -p $1 -u 1994 -LUGHNS" #Test 13
	"./client -h 127.0.0.1 -p $1 -u 1994 285 -LUGHNS" #Test 14
	"./client -h 127.0.0.1 -p $1 -u 1994 285 unkown -LUGHNS" #Test 15
	"./client -h 127.0.0.1 -p $1 -u 1994 285 -LUGNHS" #Test16
	"./client -h 127.0.0.1 -p $1 -u 285 -L -U -G" #Test 17
	"./client -h 127.0.0.1 -p $1 -u 1994 1994 285 285 -LUGHNS" #Test 18
	"./client -h 127.0.0.1 -p $1 -u 1994 285 1994 285 -LUGHNS" #Test 19 ----------------
	"./client -h 127.0.0.1 -p $1 -u unkown unkown2 -L -U -GNHS" #Test 20
	"./client -h 127.0.0.1 -p $1 -u 1994 285 -LN" #Test21
	"./client -h 127.0.0.1 -p $1 -u 1994 285" #Test22 ------------------
	"./client -h 127.0.0.1 -p $1 -u unkown unkown2" #Test23
	"./client -h 127.0.0.1 -p $1 -u 1994 285 -G" #Test24
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy unkown -LUGHNS" #Test 25 Test26
)

if [ -z ${1+x} ]
then
	echo -e "\033[31mPort is missing!\033[0m"
	exit
fi

make clean
make

./server -p $1 &

for (( number=1; number<=24; number++ ))
do
	eval ${TESTS[$number - 1]} &>out/test${number}.out
	diff -u ref-out/test${number}.out out/test${number}.out > out/test${number}.diff
	showResult $? $number
	echo -e "\033[0m-----------"
done

eval ${TESTS[24]} 1>out/test25.out 2>out/test25.err
diff -u ref-out/test25.out out/test25.out > out/test25.diff
showResult $? 25
diff -u ref-out/test25.err out/test25.err > out/test25.diff
showResult $? 25
echo -e "\033[0m-----------"

kill $!