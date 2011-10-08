#import "SBLayoutConstraint.h"

static NSInteger __lpLayoutConstraintNextID = 42;

@implementation SBLayoutConstraint

@synthesize constrainedItem = _constrainedItem;
@synthesize adjacentItem = _adjacentItem;
@synthesize leading = _leading;
@synthesize constraintID = _constraintID;
@synthesize layoutBlock = _layoutBlock;



-(id) initWithConstrainedItem: (SBLayoutItem *) constrainedItem
				 adjacentItem: (SBLayoutItem *) adjacentItem
{
	if( (self = [super init]) )
	{
		_constrainedItem = [constrainedItem retain];
		_adjacentItem = [adjacentItem retain];
		_constraintID = __lpLayoutConstraintNextID++;
	}
	return self;
}

// base class does nothing
-(void) layout
{
}

//Subclasses MUST override
-(BOOL) canChangeContentSize
{
	NSAssert( NO,  @"Subclass must override" );
	return NO;
}

// Subclasses may override
-(BOOL) shouldLayoutLast
{
	return NO;
}


-(void) dealloc 
{
	[_constrainedItem release];
	[_adjacentItem release];
	[_layoutBlock release];
    [super dealloc];
}

-(BOOL) isEqual:(id)object
{
	if( [object isKindOfClass: [self class]] )
		return NO;
	SBLayoutConstraint *otherConstraint = (SBLayoutConstraint *) object;
	
	return otherConstraint.constraintID == self.constraintID;
}

-(NSUInteger) hash
{
	return self.constraintID;
}



/*  Keyed Archiving */
//
- (void) encodeWithCoder: (NSCoder *)encoder 
{
    [encoder encodeObject: self.constrainedItem forKey: @"constrainedItem"];
    [encoder encodeObject: self.adjacentItem forKey: @"adjacentItem"];
    [encoder encodeFloat: self.leading forKey: @"leading"];
    [encoder encodeInteger: self.constraintID forKey: @"constraintID"];
}

- (id) initWithCoder: (NSCoder *)decoder 
{
    self = [super init];
    if (self) {
        self.constrainedItem =  [decoder decodeObjectForKey: @"constrainedItem"];
        self.adjacentItem =  [decoder decodeObjectForKey: @"adjacentItem"];
        self.leading =  [decoder decodeFloatForKey: @"leading"];
        self.constraintID =  [decoder decodeIntegerForKey: @"constraintID"];
    }
    return self;
}

@end
