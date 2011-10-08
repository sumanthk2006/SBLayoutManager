#import "SBHorizontalConstraint.h"


@implementation SBHorizontalConstraint

@synthesize leftOf = _leftOf;

-(id) initWithConstrainedItem:(SBLayoutItem *)constrainedItem 
				 adjacentItem:(SBLayoutItem *)adjacentItem
				   leftOfItem: (BOOL) leftOfItem
{
	if( self = [super initWithConstrainedItem: constrainedItem adjacentItem: adjacentItem] )
	{
		_leftOf = leftOfItem;
		if( _leftOf )
		{
			_leading = adjacentItem.frame.origin.x - CGRectGetMaxX(constrainedItem.frame);
		}
		else
		{
			_leading = constrainedItem.frame.origin.x - CGRectGetMaxX(adjacentItem.frame);
		}
	}
	return self;
}

+(SBHorizontalConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
									leftOfItem: (SBLayoutItem *) adjacentItem
{
	return [[[self alloc] initWithConstrainedItem: constrainedItem adjacentItem: adjacentItem leftOfItem: YES] autorelease];
}

+(SBHorizontalConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
								   rightOfItem: (SBLayoutItem *) adjacentItem
{
	return [[[self alloc] initWithConstrainedItem: constrainedItem adjacentItem: adjacentItem leftOfItem: NO] autorelease];
}


-(void) layout
{
	CGFloat newX = 0.0;
	CGFloat leading = CGRectEqualToRect( CGRectZero, _adjacentItem.frame ) ? 0.0 : _leading;
	if( _leftOf )
	{
		newX = _adjacentItem.frame.origin.x - (leading + _constrainedItem.frame.size.width);
	}
	else
	{
		newX = CGRectGetMaxX(_adjacentItem.frame) + leading;
	}
	_constrainedItem.frame = CGRectIntegral(CGRectMake(newX, _constrainedItem.frame.origin.y, _constrainedItem.frame.size.width, _constrainedItem.frame.size.height ));
}

-(BOOL) canChangeContentSize
{
	return NO;
}


-(NSString *) description
{
	return [NSString stringWithFormat: @"%@ %@", _leftOf ? @"left of" : @"right of", _adjacentItem];
}

@end
