#import <Foundation/Foundation.h>
#import "SBLayoutConstraint.h"

@interface SBSupressItemConstraint : SBLayoutConstraint
{
	CGRect		_originalFrame;
}

+(SBSupressItemConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem;

-(void) restore;

@end
