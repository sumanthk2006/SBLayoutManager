#import <Foundation/Foundation.h>
#import "SBLayoutConstraint.h"

@interface SBVerticalConstraint : SBLayoutConstraint 
{
@private
	BOOL	_below;
}

@property (nonatomic, assign) BOOL below;

+(SBVerticalConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
								   belowItem: (SBLayoutItem *) adjacentItem;

+(SBVerticalConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
								   aboveItem: (SBLayoutItem *) adjacentItem;

@end
