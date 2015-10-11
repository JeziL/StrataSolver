
#import <Foundation/Foundation.h>
#import "Strata.h"

int main(int argc, const char * argv[]) {
    NSLog(@"START:");
    @autoreleasepool {
        @try {
            NSString *filePath = @"Question.txt";
            NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
            NSArray *numArr = [str componentsSeparatedByString:@"\n"];
            NSUInteger numberOfLines = [numArr count];
        
            Strata *s = [[Strata alloc]initWithRow:numberOfLines];
        
            for (int i = 0; i < numberOfLines; i++) {
                for (int j = 0; j < numberOfLines; j++) {
                    NSString *tmpStr = [[numArr objectAtIndex:i] substringWithRange:NSMakeRange(j, 1)];
                    s.matrix[i][j] = [NSNumber numberWithInt:[tmpStr intValue]];
                }
            }
        
            [s solveTotally];
            
            [s displaySolution];
            
        }
        @catch (NSException *exception){
            NSLog(@"Something Wrong.");
            NSLog(@"END.");
            return 0;
        }
    }
    NSLog(@"END.");
    return 0;
}
