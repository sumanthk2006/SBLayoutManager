#import <Foundation/Foundation.h>
#import "SBLayoutConstraint.h"

@interface SBVariableContentHeightConstraint : SBLayoutConstraint
{
	CGFloat		_maxHeight;
	CGFloat		_minHeight;
}

@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat minHeight;

+(SBVariableContentHeightConstraint *) constraintWithItem: (SBLayoutItem *) Item;

-(CGFloat) calculatedHeight;

@end
