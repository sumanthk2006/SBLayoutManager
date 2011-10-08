#import <Foundation/Foundation.h>
#import "SBLayoutConstraint.h"

@interface SBHorizontalConstraint : SBLayoutConstraint
{
@private
	BOOL		_leftOf;
}

@property (nonatomic, assign) BOOL leftOf;

+(SBHorizontalConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
									leftOfItem: (SBLayoutItem *) adjacentItem;

+(SBHorizontalConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
								   rightOfItem: (SBLayoutItem *) adjacentItem;

@end
