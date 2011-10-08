#import "SBVariableContentWidthConstraint.h"

#define kDefaultMaxWidth 600.0

@implementation SBVariableContentWidthConstraint

@synthesize maxWidth = _maxWidth;

-(id) initWithItem: (SBLayoutItem *) Item
{
	if( (self = [super initWithConstrainedItem: Item adjacentItem: nil]) )
	{
		_maxWidth = kDefaultMaxWidth;
	}
	return self;			
}

+(SBVariableContentWidthConstraint *) constraintWithItem: (SBLayoutItem *) Item
{
	return [[[self alloc] initWithItem: Item] autorelease];
}

-(CGFloat) calculatedWidth
{
	CGFloat width = self.constrainedItem.frame.size.width;
	if( [self.constrainedItem isLabel] )
	{
		width = [[self.constrainedItem valueForKeyPath: @"view.text"] sizeWithFont: self.constrainedItem.font].width; 
		if( width > _maxWidth && _maxWidth != 0.0 )
		{
			width = _maxWidth;
		}
	}
	return width;
}

-(void) layout
{
	if( [self.constrainedItem isLabel] )
	{
		CGRect frame = self.constrainedItem.frame;
		self.constrainedItem.frame = CGRectIntegral(CGRectMake( frame.origin.x, frame.origin.y, [self calculatedWidth], frame.size.height ));
	}
	else
	{
		CGSize size = [self.constrainedItem.view sizeThatFits: CGSizeMake(0, 0)];
		CGRect frame = self.constrainedItem.frame;
		CGFloat width = size.width;
		if( self.maxWidth >= 0.0 && width > self.maxWidth )
		{
			width = self.maxWidth;
		}
		self.constrainedItem.frame = CGRectIntegral(CGRectMake( frame.origin.x, frame.origin.y, width, frame.size.height ));
	}
}

-(BOOL) canChangeContentSize
{
	return YES;
}

-(NSString *) description
{
	return @"Variable Content Width";
}

/*  Keyed Archiving */
//
- (void) encodeWithCoder: (NSCoder *)encoder 
{
    [encoder encodeFloat: self.maxWidth forKey: @"maxWidth"];
}

- (id) initWithCoder: (NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        self.maxWidth =  [decoder decodeFloatForKey: @"maxWidth"];
    }
    return self;
}

@end
