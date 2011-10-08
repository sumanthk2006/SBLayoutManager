#import <Foundation/Foundation.h>
#import "SBLayoutConstraint.h"

typedef enum { kSBCenteredContraintHorizontal, kSBCenteredContraintVertical } SBCenteredConstraintKind;

@interface SBCenteredConstraint : SBLayoutConstraint 
{
	SBCenteredConstraintKind		_kind;
}

+(SBCenteredConstraint *) constraintByCenteringVerticallyForItem: (SBLayoutItem *) constrainedItem;
+(SBCenteredConstraint *) constraintByCenteringHorizontallyForItem: (SBLayoutItem *) constrainedItem;

@end
