
#import <Foundation/Foundation.h>

@interface Strata : NSObject

@property NSUInteger row;
@property NSMutableArray *matrix;
@property NSMutableArray *solve;
- (id)initWithRow: (NSUInteger) n;
- (NSString *)findNextStep;
- (void)solvePreliminarily;
- (void)solveFinally;
- (NSString *)Step2Str: (NSString *)step;
- (void)displaySolution;
- (void)solveTotally;

@end
