#import "SBVariableContentSizeConstraint.h"


@implementation SBVariableContentSizeConstraint

@synthesize maxSize = _maxSize;


+(SBVariableContentSizeConstraint *) constraintWithItem: (SBLayoutItem *) constrainedItem
{
	return [[[self alloc] initWithConstrainedItem: constrainedItem adjacentItem: nil] autorelease];
}

-(void) layout
{
	if( _layoutBlock )
	{
		_layoutBlock(self);
	}
	else if( !CGSizeEqualToSize(self.maxSize, CGSizeZero) )
	{
		if( self.maxSize.width < self.constrainedItem.frame.size.width || self.maxSize.height < self.constrainedItem.frame.size.height ) 
		{
			self.constrainedItem.frame = CGRectIntegral(CGRectMake( self.constrainedItem.frame.origin.x, self.constrainedItem.frame.origin.y, self.maxSize.width,  self.maxSize.height ));
		}
	}
}

-(BOOL) canChangeContentSize
{
	return YES;
}

-(NSString *) description
{
	return [NSString stringWithFormat: @"Variable content size for %@", self.constrainedItem];
}


/*  Keyed Archiving */
//
- (void) encodeWithCoder: (NSCoder *)encoder 
{
    [encoder encodeCGSize: self.maxSize forKey: @"maxSize"];
}

- (id) initWithCoder: (NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        self.maxSize =  [decoder decodeCGSizeForKey: @"maxSize"];
    }
    return self;
}

@end
