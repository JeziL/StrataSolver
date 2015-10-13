main: main.o Strata.o
	g++ main.o Strata.o -o StrataSolver

main.o: main.cpp Strata.h
	g++ -std=c++11 -c main.cpp

Strata.o: Strata.cpp Strata.h
	g++ -std=c++11 -c Strata.cpp

clean:
	rm *.o