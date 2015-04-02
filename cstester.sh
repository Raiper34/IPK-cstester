#!/usr/bin/env bash 

trap "kill 0" SIGINT

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
	"./client -h localhost -p $1 -l rabj" #Test10
	"./client -h 127.0.0.1 -p $1 -l unkown unkown2" #Test11
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy -G" #Test12
	"./client -h 127.0.0.1 -p $1 -u 1994 -LUGHNS" #Test 13
	"./client -h 127.0.0.1 -p $1 -u 1994 285 -LUGHNS" #Test 14
	"./client -h 127.0.0.1 -p $1 -u 1994 285 unkown -LUGHNS" #Test 15
	"./client -h 127.0.0.1 -p $1 -u 1994 285 -LUGNHS" #Test16
	"./client -h 127.0.0.1 -p $1 -u 285 -L -U -G" #Test 17
	"./client -h 127.0.0.1 -p $1 -u 1994 1994 285 285 -LUGHNS" #Test 18
	"./client -h localhost -p $1 -u 1994 285 1994 285 -LUGHNS" #Test 19
	"./client -h 127.0.0.1 -p $1 -u unkown unkown2 -L -U -GNHS" #Test 20
	"./client -h 127.0.0.1 -p $1 -u 1994 285 -LN" #Test21
	"./client -h 127.0.0.1 -p $1 -u 1994 285" #Test22
	"./client -h 127.0.0.1 -p $1 -u unkown unkown2" #Test23
	"./client -h localhost -p $1 -u 1994 285 -G" #Test24
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy unkown -LUGHNS" #Test 25 -tieto testy 25 a 26 testuju ci chyby ze nenaslo uzivatela idu na stderr a najdeny uivatelia na stdin
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy unkown -LUGHNS" #Test26
	"./client -p $1 -l rabj rysavy unkown -LUGHNS" #Test27 --chyba host
	"./client -h 127.0.0.1 -l rabj rysavy unkown -LUGHNS" #Test28 --chyba host
	"./client -h 127.0.0.1 -p $1 rabj rysavy unkown -LUGHNS" #Test29 --chyba -l alebo -u
	"./client -h 127.0.0.1 -p $1" #Test30 --chyba -l alebo -u
	"./client -h 127.50.50.1 -p $1 -l rabj rysavy unkown -LUGHNS" #Test31 chyba neplatny host
	"./client -h 127.0.0.1 -p 40 -l rabj rysavy unkown -LUGHNS" #Test32 port mimo povoleny rozsah
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy unkown -LUGHNSX" #Test33 argument naviac
	"./server -p 40" #Test34 port mimo povoleny rozsah
	"./server -p $1 -X" #Test35 argument navyse
	"./server -p $1 sdsd" #Test36 argument navyse
	"./server -p" #Test37 nezadany port
	"./server" #Test38 nezadany port
)

if [ -z ${1+x} ]
then
	echo -e "\033[31mPort is missing!\033[0m"
	exit
fi

make clean
make

###################Test klienta######################
./server -p $1 &

for (( number=1; number<=24; number++ ))
do
	eval ${TESTS[$number - 1]} &>out/test${number}.out
	diff -u ref-out/test${number}.out out/test${number}.out > out/test${number}.diff
	if [ $? = 0 ]
	then
		echo -e "\033[1;32mTest${number} PASS"
	else
		echo -e "\033[31mTest${number} FAIL"
	fi
	echo -e "\033[0m-----------"
done

eval ${TESTS[24]} 1>out/test25.out 2>out/test25.err
diff -u ref-out/test25.out out/test25.out > out/test25.diff
if [ $? = 0 ]
	then
		echo -e "\033[1;32mTest25 PASS"
	else
		echo -e "\033[31mTest25 FAIL"
fi
diff -u ref-out/test25.err out/test25.err > out/test25.diff
if [ $? = 0 ]
	then
		echo -e "\033[1;32mTest26 PASS"
	else
		echo -e "\033[31mTest26 FAIL"
fi
echo -e "\033[0m-----------"

for (( number=27; number<=33; number++ ))
do
	eval ${TESTS[$number - 1]}
	if [ $? -ne 0 ]
	then
		echo -e "\033[1;32mTest${number} PASS"
	else
		echo -e "\033[31mTest${number} FAIL"
	fi
	echo -e "\033[0m-----------"
done

kill $!

###################Test serveru######################
for (( number=34; number<=38; number++ ))
do
	eval ${TESTS[$number - 1]}
	if [ $? -ne 0 ]
	then
		echo -e "\033[1;32mTest${number} PASS"
	else
		echo -e "\033[31mTest${number} FAIL"
	fi
	echo -e "\033[0m-----------"
done