#import "SBRemainingSpaceConstraint.h"


@implementation SBRemainingSpaceConstraint

-(id) initWithItem: (SBLayoutItem *) item
			 style: (SBRemainingSpaceStyle) style
{
	if( self = [super initWithConstrainedItem: item adjacentItem: nil] )
	{
		_style = style;
	}
	return self;
}

+(SBRemainingSpaceConstraint *) constraintWithItem:(SBLayoutItem *)item
											 style: (SBRemainingSpaceStyle) style
{
	SBRemainingSpaceConstraint *constraint = [[[self alloc] initWithItem: item style: style] autorelease];
	if( item.view.superview )
	{
		constraint.leading = item.view.superview.bounds.size.height - CGRectGetMaxY(item.view.frame);
		if( constraint.leading < 0 ) constraint.leading = 0;
	}
	return constraint;
}

-(BOOL) canChangeContentSize
{
	return YES;
}

-(BOOL) shouldLayoutLast
{
	return YES;
}

-(void) layout
{
	if( _style != kSBRemainingBelow )
		return;
	
	UIView *superview = self.constrainedItem.view.superview;
	UIView *view = self.constrainedItem.view;
	
	if( superview && view )
	{
		CGFloat newHeight = superview.bounds.size.height - (CGRectGetMinY(view.frame) + self.leading);
		CGRect frame = self.constrainedItem.frame;
		self.constrainedItem.frame = CGRectIntegral(CGRectMake( frame.origin.x, frame.origin.y, frame.size.width, newHeight ));
	}
}

-(NSString *) description
{
	return [NSString stringWithFormat: @"LPRemainingSpaceConstraint item = %@ style = %d leading = %f", self.constrainedItem, _style, _leading];
}

@end
