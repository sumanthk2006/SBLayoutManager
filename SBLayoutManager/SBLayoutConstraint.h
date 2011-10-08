#import <Foundation/Foundation.h>
#import "SBLayoutItem.h"

@class SBLayoutConstraint;

typedef void (^SBLayoutConstraintLayoutBlock)( SBLayoutConstraint *constraint );


@interface SBLayoutConstraint : NSObject<NSCoding>
{
	SBLayoutItem					*_constrainedItem;
	SBLayoutItem 					*_adjacentItem;
	CGFloat							_leading;
	NSInteger						_constraintID;
	
	SBLayoutConstraintLayoutBlock	_layoutBlock;
}

@property (nonatomic, retain) 	SBLayoutItem 					*constrainedItem;
@property (nonatomic, retain) 	SBLayoutItem 					*adjacentItem;
@property (nonatomic, assign) 	CGFloat 						leading;
@property (nonatomic, assign) 	NSInteger 						constraintID;
@property (nonatomic, copy) 	SBLayoutConstraintLayoutBlock	layoutBlock;			// subclasses should call this (if provided) from -layout



-(id) initWithConstrainedItem: (SBLayoutItem *) constrainedItem
				 adjacentItem: (SBLayoutItem *) adjacentItem;

-(void) layout;

// subclass must implement
-(BOOL) canChangeContentSize;

// subclass can implement
-(BOOL) shouldLayoutLast;


@end
