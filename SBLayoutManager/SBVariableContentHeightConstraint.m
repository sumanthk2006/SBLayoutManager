#import "SBVariableContentHeightConstraint.h"

#define kDefaultMaxHeight	600.0
#define kDefaultMinHeight	0.0

@implementation SBVariableContentHeightConstraint

@synthesize maxHeight = _maxHeight;
@synthesize minHeight = _minHeight;

-(id) initWithItem: (SBLayoutItem *) Item
{
	if( (self = [super initWithConstrainedItem: Item adjacentItem: nil]) )
	{
		_maxHeight = kDefaultMaxHeight;
		_minHeight = kDefaultMinHeight;
	}
	return self;			
}

+(SBVariableContentHeightConstraint *) constraintWithItem: (SBLayoutItem *) Item
{
	return [[[self alloc] initWithItem: Item] autorelease];
}

-(CGFloat) calculatedHeight
{
	CGFloat height = self.constrainedItem.frame.size.height;
	if( [self.constrainedItem isLabel] )
	{
		height = [[self.constrainedItem valueForKeyPath: @"view.text"] sizeWithFont: self.constrainedItem.font constrainedToSize: CGSizeMake(self.constrainedItem.frame.size.width, self.maxHeight) lineBreakMode: self.constrainedItem.lineBreakMode].height; 
	}
	else 
	{
		height = [self.constrainedItem.view sizeThatFits: self.constrainedItem.frame.size].height;
	}
	
	if( height > self.maxHeight ) 
		height = self.maxHeight;
	
	if( height < self.minHeight )
		height = self.minHeight;

	return height;
}

-(void) layout
{
	CGRect frame = self.constrainedItem.frame;
	self.constrainedItem.frame = CGRectIntegral(CGRectMake( frame.origin.x, frame.origin.y, frame.size.width, [self calculatedHeight] ));
}

-(BOOL) canChangeContentSize
{
	return YES;
}

-(NSString *) description
{
	return [NSString stringWithFormat: @"Variable Content Height for %@", self.constrainedItem];
}

@end
