
#import "Strata.h"

@implementation Strata

@synthesize row;
@synthesize matrix;
@synthesize solve;

- (id)initWithRow:(NSUInteger)n {
    if (self = [super init]) {
        self.row = n;
        self.solve = [NSMutableArray array];
        self.matrix = [NSMutableArray array];
        NSMutableArray *aLine = [NSMutableArray array];
        NSNumber *element = [NSNumber numberWithInt:0];
        for (NSUInteger i = 0; i < self.row; i++) {
            [aLine addObject:element];
        }
        for (NSUInteger i = 0; i < self.row; i++) {
            NSMutableArray *line = [NSMutableArray arrayWithArray:aLine];
            [self.matrix addObject:line];
        }
    }
    return self;
}

- (NSString *)findNextStep {
    NSUInteger next = 2 * self.row;
    int nextColor = 0;
    
    // Start line search.
    NSUInteger next_line = self.row;
    int countMax_line = 0;
    int nextColor_line = 0;
    for (NSUInteger i = 0; i < self.row; i++) {
        BOOL lineCouldBeNext = YES;
        int max = 0;
        int count = 0;
        for (NSUInteger j = 0; j < self.row; j++) {
            max = [self.matrix[i][j] intValue]>max?[self.matrix[i][j] intValue]:max;
        }
        if (max == 0) {lineCouldBeNext = NO; goto aLineEnded;}
        for (NSUInteger j = 0; j < self.row; j++) {
            if ([self.matrix[i][j] intValue] != max && [self.matrix[i][j] intValue] != 0) {
                lineCouldBeNext = NO;
                break;
            }
            else if ([self.matrix[i][j] intValue] != 0) {
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
    NSUInteger next_row = self.row;
    int countMax_row = 0;
    int nextColor_row = 0;
    for (NSUInteger i = 0; i < self.row; i++) {
        BOOL rowCouldBeNext = YES;
        int max = 0;
        int count = 0;
        for (NSUInteger j = 0; j < self.row; j++) {
            max = [self.matrix[j][i] intValue]>max?[self.matrix[j][i] intValue]:max;
        }
        if (max == 0) {rowCouldBeNext = NO; goto aRowEnded;}
        for (NSUInteger j = 0; j < self.row; j++) {
            if ([self.matrix[j][i] intValue] != max && [self.matrix[j][i] intValue] != 0) {
                rowCouldBeNext = NO;
                break;
            }
            else if ([self.matrix[j][i] intValue] != 0) {
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
    for (NSUInteger i = 0; i < self.row; i++) {
        for (NSUInteger j = 0; j < self.row; j++) {
            if ([self.matrix[i][j] intValue] == 0)
                countOfZero++;
        }
    }
    
    // Line or row?
    if (countMax_line >= countMax_row && (countMax_line != 1 || countOfZero < (self.row * (self.row - 1))) && countMax_line != 0) {
        next = next_line;
        nextColor = nextColor_line;
        if (next != 2 * self.row) {
            for (NSInteger i = 0; i < self.row; i++) {
                self.matrix[next_line][i] = [NSNumber numberWithInt:0];
            }
        }
    }
    if (countMax_line < countMax_row && (countMax_row != 1 || countOfZero < (self.row * (self.row - 1))) && countMax_row != 0) {
        next = next_row + self.row;
        nextColor = nextColor_row;
        if (next != 2 * self.row) {
            for (NSInteger i = 0; i < self.row; i++) {
                self.matrix[i][next_row] = [NSNumber numberWithInt:0];
            }
        }
    }
    
    return [NSString stringWithFormat:@"%lu,%d",(unsigned long)next, nextColor];
}

- (void)solvePreliminarily {
    while (1) {
        NSString *str = [self findNextStep];
        if ([[[str componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"%lu",2 * self.row]]) {
            break;
        }
        [self.solve addObject:str];
    }
}

- (void)solveFinally {
    NSMutableArray *newSolve = [NSMutableArray array];
    
    int countMax_line = 0;
    NSUInteger targetLine = 2 * self.row;
    for (NSUInteger i = 0; i < self.row; i++) {
        int count = 0;
        for (NSUInteger j = 0; j < self.row; j++) {
            if ([self.matrix[i][j] intValue] != 0) {
                count++;
            }
        }
        if (count > countMax_line) {
            countMax_line = count;
            targetLine = i;
        }
    }
    
    int countMax_row = 0;
    NSUInteger targetRow = 2 * self.row;
    for (NSUInteger i = 0; i < self.row; i++) {
        int count = 0;
        for (NSUInteger j = 0; j < self.row; j++) {
            if ([self.matrix[j][i] intValue] != 0) {
                count++;
            }
        }
        if (count > countMax_row) {
            countMax_row = count;
            targetRow = i;
        }
    }
    
    if (countMax_line >= countMax_row && targetLine != 2 * self.row) {
        for (NSUInteger i = 0; i < self.row; i++) {
            if ([self.matrix[targetLine][i] intValue] != 0) {
                NSString *str = [NSString stringWithFormat:@"%lu,%d", i + self.row, [self.matrix[targetLine][i] intValue]];
                [newSolve addObject:str];
            }
        }
        [newSolve addObject:[NSString stringWithFormat:@"%lu,%d", targetLine, (arc4random() % 2) + 1]];
    }
    else if (targetRow != 2 * self.row){
        for (NSUInteger i = 0; i < self.row; i++) {
            if ([self.matrix[i][targetRow] intValue] != 0) {
                NSString *str = [NSString stringWithFormat:@"%lu,%d", i, [self.matrix[i][targetRow] intValue]];
                [newSolve addObject:str];
            }
        }
        [newSolve addObject:[NSString stringWithFormat:@"%lu,%d", targetRow + self.row, (arc4random() % 2) + 1]];
    }
// -----
    if ([self.solve count] + [newSolve count] == 2 * self.row) {
        [self.solve addObjectsFromArray:newSolve];
        NSMutableArray *tmp = [NSMutableArray array];
        NSUInteger i = [self.solve count] - 1;
        while (1) {
            [tmp addObject:self.solve[i]];
            if (i == 0) break;
            i--;
        }
        self.solve = tmp;
    }
    else {
        NSMutableArray *locationProcessed = [NSMutableArray array];
        for (NSUInteger i = 0; i < [self.solve count]; i++) {
            [locationProcessed addObject:[[self.solve[i] componentsSeparatedByString:@","] objectAtIndex:0]];
        }
        for (NSUInteger i = 0; i < [newSolve count]; i++) {
            [locationProcessed addObject:[[newSolve[i] componentsSeparatedByString:@","] objectAtIndex:0]];
        }
        for (NSUInteger i = 0; i < 2 * self.row; i++) {
            NSString *str = [NSString stringWithFormat:@"%lu",i];
            if (![locationProcessed containsObject:str]) {
                int tmpColor = 1;
                if (i < self.row) {
                    for (NSUInteger j = 0; j < self.row; j++) {
                        if ([self.matrix[i][j] intValue] != 0) {
                            tmpColor = [self.matrix[i][j] intValue];
                            break;
                        }
                    }
                }
                else {
                    for (NSUInteger j = 0; j < self.row; j++) {
                        if ([self.matrix[j][i - self.row] intValue] != 0) {
                            tmpColor = [self.matrix[j][i - self.row] intValue];
                            break;
                        }
                    }
                }
                [newSolve insertObject:[NSString stringWithFormat:@"%lu,%d", i, tmpColor] atIndex:0];
            }
        }
        
        [self.solve addObjectsFromArray:newSolve];
        NSMutableArray *tmp = [NSMutableArray array];
        NSUInteger i = [self.solve count] - 1;
        while (1) {
            [tmp addObject:self.solve[i]];
            if (i == 0) break;
            i--;
        }
        self.solve = tmp;
    }
}

- (NSString *)Step2Str: (NSString *)step {
    NSString *str;
    
    if ([[[step componentsSeparatedByString:@","] objectAtIndex:0] intValue] < self.row) {
        str = [NSString stringWithFormat:@"Fill the line %d with color %@", [[[step componentsSeparatedByString:@","] objectAtIndex:0] intValue] + 1, [step substringFromIndex:step.length - 1]];
    }
    else {
        str = [NSString stringWithFormat:@"Fill the column %d with color %@", [[[step componentsSeparatedByString:@","] objectAtIndex:0] intValue] - (int)self.row + 1, [step substringFromIndex:step.length - 1]];
    }
    
    return str;
}

- (void)solveTotally {
    [self solvePreliminarily];
    if ([self.solve count] == 0) {
        self.matrix[self.row][self.row] = [NSNumber numberWithInt:0];  //Make self.matrix out of range to throw an exception.
    }
    [self solveFinally];

}

- (void)displaySolution {
    for (NSUInteger i = 0; i < [self.solve count]; i++) {
        NSLog(@"Step%lu. %@", i + 1, [self Step2Str:self.solve[i]]);
    }
}

@end
