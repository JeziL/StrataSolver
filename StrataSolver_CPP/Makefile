main: main.o Strata.o
	g++ main.o Strata.o -o StrataSolver

main.o: main.cpp Strata.h
	g++ -c main.cpp

Strata.o: Strata.cpp Strata.h
	g++ -c Strata.cpp

clean:
	rm *.o