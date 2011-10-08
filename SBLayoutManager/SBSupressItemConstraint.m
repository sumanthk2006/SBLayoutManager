#import "SBSupressItemConstraint.h"
#import "CGRectHelpers.h"


@implementation SBSupressItemConstraint

+(SBSupressItemConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
{
	return [[[self alloc] initWithConstrainedItem: constrainedItem adjacentItem: nil] autorelease];
}

-(void) layout
{
	_originalFrame = self.constrainedItem.frame;
	
	if( !CGRectIsInvalid(_originalFrame) )
	{
		self.constrainedItem.frame = CGRectMake( _originalFrame.origin.x, _originalFrame.origin.y, 0, 0 );
	}
	self.constrainedItem.hidden = YES;
}

-(BOOL) canChangeContentSize
{
	return YES;
}

-(void) restore
{
	self.constrainedItem.hidden = NO;
	if( !CGRectEqualToRect(_originalFrame, CGRectZero) )
	{
		self.constrainedItem.frame = _originalFrame;
	}
}

-(NSString *) description
{
	return [NSString stringWithFormat: @"Supressing Item %@", self.constrainedItem];
}


@end
