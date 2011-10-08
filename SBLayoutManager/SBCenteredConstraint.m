#import "SBCenteredConstraint.h"


@implementation SBCenteredConstraint

-(id) initWithConstrainedItem:(SBLayoutItem *)constrainedItem 
						 kind: (SBCenteredConstraintKind) kind
{
	if( self = [super initWithConstrainedItem: constrainedItem
								 adjacentItem: nil] )
	{
		_kind = kind;
	}
	return self;
}

+(SBCenteredConstraint *) constraintByCenteringVerticallyForItem: (SBLayoutItem *) constrainedItem
{
	return [[[self alloc] initWithConstrainedItem: constrainedItem kind: kSBCenteredContraintVertical] autorelease];
}

+(SBCenteredConstraint *) constraintByCenteringHorizontallyForItem: (SBLayoutItem *) constrainedItem
{
	return [[[self alloc] initWithConstrainedItem: constrainedItem kind: kSBCenteredContraintHorizontal] autorelease];
}

-(BOOL) canChangeContentSize
{
	return NO;
}

-(BOOL) shouldLayoutLast
{
	return YES;
}

-(void) layout
{
	if( _kind == kSBCenteredContraintVertical )
	{
		if( self.constrainedItem.frame.size.height < self.constrainedItem.superItem.frame.size.height )
		{
			CGRect frame = self.constrainedItem.frame;
			CGRect superFrame = self.constrainedItem.superItem.frame;
			self.constrainedItem.frame = CGRectIntegral(CGRectMake( frame.origin.x, floor((superFrame.size.height - frame.size.height) / 2.0), frame.size.width, frame.size.height ));
		}
	}
	else if( _kind == kSBCenteredContraintHorizontal )
	{
		if( self.constrainedItem.frame.size.width < self.constrainedItem.superItem.frame.size.width )
		{
			CGRect frame = self.constrainedItem.frame;
			CGRect superFrame = self.constrainedItem.superItem.frame;
			self.constrainedItem.frame = CGRectIntegral(CGRectMake( floor((superFrame.size.width - frame.size.width) / 2.0), frame.origin.y, frame.size.width, frame.size.height ));
		}
	}
}

@end
