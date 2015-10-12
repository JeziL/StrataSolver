//
//	Strata.cpp
//	StrataSolver_CPP
//

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include "Strata.h"
using namespace std;

Strata::Strata(unsigned int n) {
	row = n;
	matrix = new unsigned int*[n];
	for (int i = 0; i < n; i++) {
		matrix[i] = new unsigned int[n];
	}
	for (int j = 0; j < n; j++) {
		for (int k = 0; k < n; k++) {
			matrix[j][k] = 0;
		}
	}
}

string Strata::findNextStep() {
	unsigned int next = 2 * row;
	int nextColor = 0;

	//Start line search.
	unsigned int next_line = row;
    int countMax_line = 0;
    int nextColor_line = 0;
    for (int i = 0; i < row; i++) {
        bool lineCouldBeNext = true;
        int max = 0;
        int count = 0;
        for (int j = 0; j < row; j++) {
            max = matrix[i][j] > max?matrix[i][j]:max;
        }
        if (max == 0) {lineCouldBeNext = false; goto aLineEnded;}
        for (int j = 0; j < row; j++) {
            if (matrix[i][j] != max && matrix[i][j] != 0) {
                lineCouldBeNext = false;
                break;
            }
            else if (matrix[i][j] != 0) {
                count++;
            }
        }
    aLineEnded:if (lineCouldBeNext) {
            next_line = (count > countMax_line)?i:next_line;
            nextColor_line = (count > countMax_line)?max:nextColor_line;
            countMax_line = (count > countMax_line)?count:countMax_line;
        }
    }

    // Start row search.
    unsigned int next_row = row;
    int countMax_row = 0;
    int nextColor_row = 0;
    for (int i = 0; i < row; i++) {
        bool rowCouldBeNext = true;
        int max = 0;
        int count = 0;
        for (int j = 0; j < row; j++) {
            max = matrix[j][i] > max?matrix[j][i]:max;
        }
        if (max == 0) {rowCouldBeNext = false; goto aRowEnded;}
        for (int j = 0; j < row; j++) {
            if (matrix[j][i] != max && matrix[j][i] != 0) {
                rowCouldBeNext = false;
                break;
            }
            else if (matrix[j][i] != 0) {
                count++;
            }
        }
    aRowEnded:if (rowCouldBeNext) {
            next_row = (count > countMax_row)?i:next_row;
            nextColor_row = (count > countMax_row)?max:nextColor_row;
            countMax_row = (count > countMax_row)?count:countMax_row;
        }
    }

    int countOfZero = 0;
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < row; j++) {
            if (matrix[i][j] == 0)
                countOfZero++;
        }
    }

    // Line or row?
    if (countMax_line >= countMax_row && (countMax_line != 1 || countOfZero < (row * (row - 1))) && countMax_line != 0) {
        next = next_line;
        nextColor = nextColor_line;
        if (next != 2 * row) {
            for (int i = 0; i < row; i++) {
                matrix[next_line][i] = 0;
            }
        }
    }
    if (countMax_line < countMax_row && (countMax_row != 1 || countOfZero < (row * (row - 1))) && countMax_row != 0) {
        next = next_row + row;
        nextColor = nextColor_row;
        if (next != 2 * row) {
            for (int i = 0; i < row; i++) {
                matrix[i][next_row] = 0;
            }
        }
    }

    string nextStep = to_string(next) + ',' + to_string(nextColor);
    return nextStep;
}

void Strata::solvePreliminarily() {
    while (1) {
        string str = findNextStep();
        if (atoi(str.substr(0,str.find(",")).c_str()) == 2 * row) {
            break;
        }
        solve.push_back(str);
    }
}

void Strata::solveFinally() {
	vector<string> newSolve;

	int countMax_line = 0;
    unsigned int targetLine = 2 * row;
    for (int i = 0; i < row; i++) {
        int count = 0;
        for (int j = 0; j < row; j++) {
            if (matrix[i][j] != 0) {
                count++;
            }
        }
        if (count > countMax_line) {
            countMax_line = count;
            targetLine = i;
        }
    }
    
    int countMax_row = 0;
    unsigned int targetRow = 2 * row;
    for (int i = 0; i < row; i++) {
        int count = 0;
        for (int j = 0; j < row; j++) {
            if (matrix[j][i] != 0) {
                count++;
            }
        }
        if (count > countMax_row) {
            countMax_row = count;
            targetRow = i;
        }
    }
    
    if (countMax_line >= countMax_row && targetLine != 2 * row) {
        for (int i = 0; i < row; i++) {
            if (matrix[targetLine][i] != 0) {
                string str = to_string(i + row) + ',' + to_string(matrix[targetLine][i]);
                newSolve.push_back(str);
            }
        }
        string str = to_string(targetLine) + ',' + to_string((arc4random() % 2) + 1);
        newSolve.push_back(str);
    }
    else if (targetRow != 2 * row){
        for (int i = 0; i < row; i++) {
            if (matrix[i][targetRow] != 0) {
            	string str = to_string(i) + ',' + to_string(matrix[i][targetRow]);
                newSolve.push_back(str);
            }
        }
        string str = to_string(targetRow + row) + ',' + to_string((arc4random() % 2) + 1);
        newSolve.push_back(str);
    }

    //-----
    if (solve.size() + newSolve.size() == 2 * row) {

    	for (int i = 0; i < newSolve.size(); i++)
    		solve.push_back(newSolve[i]);

        reverse(solve.begin(), solve.end());
    }
    else {
        vector<string> locationProcessed;
        for (int i = 0; i < solve.size(); i++) {
            locationProcessed.push_back(solve[i].substr(0,solve[i].find(",")));
        }
        for (int i = 0; i < newSolve.size(); i++) {
            locationProcessed.push_back(newSolve[i].substr(0,solve[i].find(",")));
        }
        for (int i = 0; i < 2 * row; i++) {
            string str = to_string(i);
            if (find(locationProcessed.begin(),locationProcessed.end(),str) == locationProcessed.end()) {
                int tmpColor = 1;
                if (i < row) {
                    for (int j = 0; j < row; j++) {
                        if (matrix[i][j] != 0) {
                            tmpColor = matrix[i][j];
                            break;
                        }
                    }
                }
                else {
                    for (int j = 0; j < row; j++) {
                        if (matrix[j][i - row] != 0) {
                            tmpColor = matrix[j][i - row];
                            break;
                        }
                    }
                }
                string tmp = to_string(i) + ',' + to_string(tmpColor);
                newSolve.insert(newSolve.begin(),tmp);
            }
        }
        
        for (int i = 0; i < newSolve.size(); i++)
    		solve.push_back(newSolve[i]);

        reverse(solve.begin(), solve.end());
    }
}

string Strata::step2Str(string step) {
	string str;

	if (atoi(step.substr(0,step.find(",")).c_str()) < row) {
		str = "Fill the line " + to_string(atoi(step.substr(0,step.find(",")).c_str()) + 1) + " with color " + step.substr(step.find(",") + 1, step.length());
	}
	else {
		str = "Fill the column " + to_string(atoi(step.substr(0,step.find(",")).c_str()) - row + 1) + " with color " + step.substr(step.find(",") + 1, step.length());
	}
	return str;
}

void Strata::solveTotally() {
	solvePreliminarily();
	if (solve.size() == 0) {
		matrix[row][row] = 0;	//Make matrix out of range to throw an exception.
	}
	solveFinally();
}

void Strata::displaySolution(){
	for (int i = 0; i < solve.size(); i++) {
		cout<<"Step"<<i + 1<<". "<<step2Str(solve[i])<<endl;
	}
}