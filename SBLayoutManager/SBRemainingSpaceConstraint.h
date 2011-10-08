#import <Foundation/Foundation.h>
#import "SBLayoutConstraint.h"

typedef enum { kSBRemainingBelow } SBRemainingSpaceStyle;

@interface SBRemainingSpaceConstraint : SBLayoutConstraint 
{
	SBRemainingSpaceStyle	_style;
}

+(SBRemainingSpaceConstraint *) constraintWithItem: (SBLayoutItem *) item
											 style: (SBRemainingSpaceStyle) style;

@end
