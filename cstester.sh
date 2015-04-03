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
	"./client -h localhost -p $1 -l rabj rysavy unkown -u 1994 -L -U -G" #Test25 ++
	"./client -h localhost -p $1 -u 1994 285 -l unkown -G -U -S" #Test26 ++
	"./client -h 127.0.0.1 -p $1 -l RaBj RYSAVY rabj Rysavy -LNH" #Test 27 test case sensitivity +++
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy unkown -LUGHNS" #Test 28 -tieto testy 28 a 29 testuju ci chyby ze nenaslo uzivatela idu na stderr a najdeny uivatelia na stdin
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy unkown -LUGHNS"
	"./client -p $1 -l rabj rysavy unkown -LUGHNS" #Test30 --chyba host
	"./client -h 127.0.0.1 -l rabj rysavy unkown -LUGHNS" #Test31 --chyba host
	"./client -h 127.0.0.1 -p $1 rabj rysavy unkown -LUGHNS" #Test32 --chyba -l alebo -u
	"./client -h 127.0.0.1 -p $1" #Test33 --chyba -l alebo -u
	"./client -h 127.50.50.1 -p $1 -l rabj rysavy unkown -LUGHNS" #Test34 chyba neplatny host
	"./client -h 127.0.0.1 -p 40 -l rabj rysavy unkown -LUGHNS" #Test35 port mimo povoleny rozsah
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy unkown -LUGHNSX" #Test36 argument naviac
	"./client -h 127.0.0.1 -p $1 -l rabj rysavy unkown -LUGL" #Test37 duplicitny argument ++
	"./server -p 40" #Test38 port mimo povoleny rozsah
	"./server -p $1 -X" #Test39 argument navyse
	"./server -p $1 sdsd" #Test40 argument navyse
	"./server -p" #Test41 nezadany port
	"./server" #Test42 nezadany port
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

for (( number=1; number<=27; number++ ))
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

eval ${TESTS[27]} 1>out/test28.out 2>out/test28.err
diff -u ref-out/test28.out out/test28.out > out/test28.diff
if [ $? = 0 ]
	then
		echo -e "\033[1;32mTest28 PASS"
	else
		echo -e "\033[31mTest28 FAIL"
fi
diff -u ref-out/test28.err out/test28.err > out/test28.diff
if [ $? = 0 ]
	then
		echo -e "\033[1;32mTest29 PASS"
	else
		echo -e "\033[31mTest29 FAIL"
fi
echo -e "\033[0m-----------"

for (( number=30; number<=37; number++ ))
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
for (( number=38; number<=42; number++ ))
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