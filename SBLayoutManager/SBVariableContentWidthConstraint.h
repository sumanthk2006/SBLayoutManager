#import <Foundation/Foundation.h>
#import "SBLayoutConstraint.h"

@interface SBVariableContentWidthConstraint : SBLayoutConstraint<NSCoding>
{
	CGFloat		_maxWidth;
}

@property (nonatomic, assign) CGFloat maxWidth;

+(SBVariableContentWidthConstraint *) constraintWithItem: (SBLayoutItem *) Item;

-(CGFloat) calculatedWidth;

@end
