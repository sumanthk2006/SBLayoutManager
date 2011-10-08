#import <Foundation/Foundation.h>
#import "SBLayoutConstraint.h"

@interface SBVariableContentSizeConstraint : SBLayoutConstraint <NSCoding>
{
	CGSize	_maxSize;
}

@property (nonatomic, assign) CGSize maxSize;

+(SBVariableContentSizeConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem;


@end
