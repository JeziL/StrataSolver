//
//	main.cpp
//	StrataSolver_CPP
//

#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include "Strata.h"
using namespace std;

int main() {
	try {
		ifstream questionFile("Question.txt");
		string line;
		vector<string> lines;
		while (getline(questionFile, line)) {
			lines.push_back(line);
		}

		Strata myStrata(lines.size());
		for (int i = 0; i < lines.size(); i++) {
			for (int j = 0; j < lines.size(); j++) {
				myStrata.matrix[i][j] = atoi(lines[i].substr(j,1).c_str());
			}
		}
		myStrata.solveTotally();
		myStrata.displaySolution();
	}
	catch(char *str) {
		cout<<"Something Wrong: "<<str<<endl;
		return 0;
	}
	return 0;
}