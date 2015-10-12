//
//	Strata.h
//	StrataSolver_CPP
//

#include <string>
#include <vector>
using namespace std;

class Strata {
private:
	string findNextStep();
	void solvePreliminarily();
	void solveFinally();
	string step2Str(string step);
public:
	unsigned int row;
	vector<string> solve;
	unsigned int **matrix;
	Strata(unsigned int n);
	void solveTotally();
	void displaySolution();
};