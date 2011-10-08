#import "SBVerticalConstraint.h"



@implementation SBVerticalConstraint

@synthesize below = _below;


-(id) initWithItem: (SBLayoutItem *) constrainedItem
	  adjacentItem: (SBLayoutItem *) adjacentItem
	 adjacentAbove: (BOOL) adjacentAbove
{
	if( self = [super initWithConstrainedItem: constrainedItem adjacentItem: adjacentItem] )
	{
		_below = adjacentAbove;
		
		if( _below )
		{
			_leading = constrainedItem.frame.origin.y - CGRectGetMaxY(adjacentItem.frame);
		}
		else
		{
			_leading = adjacentItem.frame.origin.y - CGRectGetMaxY(constrainedItem.frame);
		}
	}
	return self;
}

+(SBVerticalConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
								   belowItem: (SBLayoutItem *) adjacentItem
{
	return [[[self alloc] initWithItem: constrainedItem adjacentItem: adjacentItem adjacentAbove: YES] autorelease];
}

+(SBVerticalConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
								   aboveItem: (SBLayoutItem *) adjacentItem
{
	return [[[self alloc] initWithItem: constrainedItem adjacentItem: adjacentItem adjacentAbove: NO] autorelease];
}

-(void) layout
{
	CGFloat newY = 0.0;
	CGFloat leading = CGRectEqualToRect( CGRectZero, _adjacentItem.frame ) ? 0.0 : _leading;
	if( _below )
	{
		newY = CGRectGetMaxY(_adjacentItem.frame) + leading;
	}
	else
	{
		newY = _adjacentItem.frame.origin.y - (leading + _constrainedItem.frame.size.height);
	}
	_constrainedItem.frame = CGRectIntegral(CGRectMake( _constrainedItem.frame.origin.x, newY, _constrainedItem.frame.size.width, _constrainedItem.frame.size.height ));
}

-(BOOL) canChangeContentSize
{
	return NO;
}

-(NSString *) description
{
	return [NSString stringWithFormat: @"%@ %@", _below ? @"below" : @"above", _adjacentItem];
}
@end
