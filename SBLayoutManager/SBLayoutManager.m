#import "SBLayoutManager.h"

#import <QuartzCore/QuartzCore.h>

NSString * const kSBLayoutManagerConstraintsDidChangeNotification	=	@"LPLayoutManagerConstraintsDidChangeNotification";

@interface SBLayoutManager()

-(void) initComplete;
-(void) addSubItemsToRootItem: (SBLayoutItem *) rootItem 
				withSuperview: (UIView *) rootView
					  outlets: (NSDictionary *) outlets;
-(void) loadViewHierarchy: (UIView *) view;
-(void) setRootViewSize: (CGSize) size;
-(SBLayoutItem *) layoutItemForView: (UIView *) view;							
-(void) addConstraint: (SBLayoutConstraint *) constraint;
-(void) removeConstraint: (SBLayoutConstraint *) constraint;
-(void) removeConstraintsForView: (UIView *) view;
-(SBLayoutItem *) layoutItemForBindingName: (NSString *) bindingName;			// bindingName == @<foo> from UILabels
-(SBLayoutItem *) layoutItemForOutletName: (NSString *) outletName;				// outletName from NIB

// utilty
-(void) setIsCollapsed: (BOOL) collapse forItem: (SBLayoutItem *) item;			// helper for managing supress constraint
-(void) removeConstraintsOfClass: (Class) classToRemove;
-(void) removeConstraintsOfClass: (Class) classToRemove item: (SBLayoutItem *) view;
-(NSArray *) constraintsForItem: (SBLayoutItem *) item;
-(NSArray *) constraintsForItem: (SBLayoutItem *) item withClass: (Class) class;
-(void) enumerateItemsWithBlock: (VisitLayoutItemBlock) block;

@end

@implementation SBLayoutManager

@synthesize rootLayoutItem = _rootLayoutItem;
@synthesize bottomLeading = _bottomLeading;
@synthesize minimumHeight = _minimumHeight;
@synthesize layoutCompleteBlock = _layoutCompleteBlock;


-(id) initWithView: (UIView *) rootView
{
	if( (self = [super init]) )
	{
		_doesDirectDrawing = NO;
		[self initComplete];
		[self loadViewHierarchy: rootView];
	}
	return self;
}

-(void) initComplete
{
	_constraints = [[NSMutableArray alloc] init];		
	_bindings = [[NSMutableDictionary alloc] init];
	_outlets = [[NSMutableDictionary alloc] init];
}

+(SBLayoutManager *) layoutManagerWithRootView: (UIView *) rootView;
{
	return [[[self alloc] initWithView: rootView] autorelease];
}

-(void) addConstraint: (SBLayoutConstraint *) constraint
{
	[_constraints addObject: constraint];	
	[[NSNotificationCenter defaultCenter] postNotificationName: kSBLayoutManagerConstraintsDidChangeNotification object: nil];
}

-(void) removeConstraint: (SBLayoutConstraint *) constraint
{
	// supress constraint has some slightly special handling (restore orginal position)
	if( [constraint isKindOfClass: [SBSupressItemConstraint class]] )
	{
		SBSupressItemConstraint *supressConstraint = (SBSupressItemConstraint *)constraint;
		[supressConstraint restore];
	}
	
	[_constraints removeObject: constraint];	
	[[NSNotificationCenter defaultCenter] postNotificationName: kSBLayoutManagerConstraintsDidChangeNotification object: nil];
}

-(void) removeConstraintsForView: (UIView *) view
{
	NSArray *constraintsToRemove = [self constraintsForItem: [self layoutItemForView: view]];
	for( SBLayoutConstraint *itemToRemove in constraintsToRemove )
	{
		[self removeConstraint: itemToRemove];
	}
}

-(void) setIsCollapsed: (BOOL) collapse 
			   forItem: (SBLayoutItem *) item
{
	// add a supress
	if( collapse )
	{
		NSArray *constraints = [self constraintsForItem: item withClass: [SBSupressItemConstraint class]];
		if( constraints.count == 0 )
		{
			[self addConstraint: [SBSupressItemConstraint constraintWithItem: item]];
		}
	}
	// remove a supress
	else
	{
		[self removeConstraintsOfClass: [SBSupressItemConstraint class] item: item];
	}
}

-(void) removeConstraintsOfClass: (Class) classToRemove
{
	NSArray *constraintsToRemove = [_constraints filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"class == %@", classToRemove]];
	if( constraintsToRemove.count )
	{
		for( SBLayoutConstraint *constraint in constraintsToRemove )
		{
			[self removeConstraint: constraint];
		}		
		[[NSNotificationCenter defaultCenter] postNotificationName: kSBLayoutManagerConstraintsDidChangeNotification object: nil];
	}
}

-(void) removeConstraintsOfClass: (Class) classToRemove 
						   item: (SBLayoutItem *) item
{
	NSArray *constraints = [[self constraintsForItem: item] filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"class == %@", classToRemove]];
	for( SBLayoutConstraint *constraint in constraints )
	{
		[self removeConstraint: constraint];
	}
}


-(NSArray *) constraintsForItem: (SBLayoutItem *) item
{
	return [_constraints filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"constrainedItem == %@", item]];
}

-(NSArray *) constraintsForItem: (SBLayoutItem *) item withClass: (Class) class
{
	return [_constraints filteredArrayUsingPredicate: [NSPredicate predicateWithFormat: @"constrainedItem == %@ && class == %@", item, class]];
}

-(void) visitItem: (SBLayoutItem *) item
		withBlock: (VisitLayoutItemBlock) visitBlock
{
	BOOL shouldStop = NO;
	visitBlock(item, &shouldStop);
	if( shouldStop )
		return;
	
	for( SBLayoutItem *subitem in item.subItems )
	{
		[self visitItem: subitem withBlock: visitBlock];
	}
}

-(void) enumerateItemsWithBlock: (VisitLayoutItemBlock) visitBlock
{
	[self visitItem: _rootLayoutItem withBlock: visitBlock];	
}


-(SBLayoutItem *) layoutItemForBindingName: (NSString *) bindingName
{
	return [_bindings objectForKey: bindingName];
}

-(SBLayoutItem *) layoutItemForOutletName: (NSString *) outletName
{
	SBLayoutItem *item = [_outlets objectForKey: outletName];
	NSAssert( item != nil, @"Important!" );
	return item;
}

-(SBLayoutItem *) layoutItemForView: (UIView *) view
{
	__block SBLayoutItem *itemFound = nil;
	[self enumerateItemsWithBlock:^(SBLayoutItem *item, BOOL *shouldStop ) {
		if( item.view == view )
		{
			itemFound = item;
			*shouldStop = YES;
		}
	}];
	 return itemFound;
}


-(void) viewIsVariableHeight: (UIView *) view
				   minHeight: (CGFloat) minHeight
{
	SBLayoutItem *layoutItem = [self layoutItemForView: view];
	if( layoutItem )
	{
		SBVariableContentHeightConstraint *constraint = [SBVariableContentHeightConstraint constraintWithItem: layoutItem];
		constraint.minHeight = minHeight;
		[self addConstraint: constraint];
	}
#ifdef DEBUG
	NSAssert( layoutItem, @"Required.");
#endif
}

-(void) viewIsVariableHeight: (UIView *) view
{
	[self viewIsVariableHeight: view minHeight: 0.0];
}


-(void) viewIsVariableWidth: (UIView *) view
{
	[self viewIsVariableWidth: view maxWidth: 0];
}

-(void) viewIsVariableWidth: (UIView *) view
				   maxWidth: (CGFloat) maxWidth
{
	SBLayoutItem *layoutItem = [self layoutItemForView: view];
	if( layoutItem )
	{
		SBVariableContentWidthConstraint *constraint = [SBVariableContentWidthConstraint constraintWithItem: layoutItem];
		constraint.maxWidth = maxWidth;
		[self addConstraint: constraint];
	}
#ifdef DEBUG
	NSAssert( layoutItem, @"Required.");
#endif
}


-(void) viewIsCenteredVertically: (UIView *) view
{
	SBLayoutItem *layoutItem = [self layoutItemForView: view];
	if( layoutItem )
	{
		[self addConstraint: [SBCenteredConstraint constraintByCenteringVerticallyForItem: layoutItem]];
	}
#ifdef DEBUG
	NSAssert( layoutItem, @"Required.");
#endif
}

-(void) viewIsCenteredHorizontally: (UIView *) view
{
	SBLayoutItem *layoutItem = [self layoutItemForView: view];
	if( layoutItem )
	{
		[self addConstraint: [SBCenteredConstraint constraintByCenteringHorizontallyForItem: layoutItem]];
	}
#ifdef DEBUG
	NSAssert( layoutItem, @"Required.");
#endif
}

-(void) view: (UIView *) view isRightOfView: (UIView *) otherView
{
	SBLayoutItem *constrainedItem = [self layoutItemForView: view];
	SBLayoutItem *adjacentItem = [self layoutItemForView: otherView];
	if( constrainedItem && adjacentItem )
	{
		[self addConstraint: [SBHorizontalConstraint constraintWithItem: constrainedItem rightOfItem: adjacentItem]];
	}
#ifdef DEBUG
	NSAssert( constrainedItem && adjacentItem, @"Required.");
#endif
}

-(void) view: (UIView *) view isLeftOfView: (UIView *) otherView
{
	SBLayoutItem *constrainedItem = [self layoutItemForView: view];
	SBLayoutItem *adjacentItem = [self layoutItemForView: otherView];
	if( constrainedItem && adjacentItem )
	{
		[self addConstraint: [SBHorizontalConstraint constraintWithItem: constrainedItem leftOfItem: adjacentItem]];
	}
#ifdef DEBUG
	NSAssert( constrainedItem && adjacentItem, @"Required.");
#endif
}

-(void) view: (UIView *) view isAboveView: (UIView *) otherView
{
	SBLayoutItem *constrainedItem = [self layoutItemForView: view];
	SBLayoutItem *adjacentItem = [self layoutItemForView: otherView];
	if( constrainedItem && adjacentItem )
	{
		[self addConstraint: [SBVerticalConstraint constraintWithItem: constrainedItem aboveItem: adjacentItem]];
	}
#ifdef DEBUG
	NSAssert( constrainedItem && adjacentItem, @"Required.");
#endif
}

-(void) view: (UIView *) view isBelowView: (UIView *) otherView
{
	SBLayoutItem *constrainedItem = [self layoutItemForView: view];
	SBLayoutItem *adjacentItem = [self layoutItemForView: otherView];
	if( constrainedItem && adjacentItem )
	{
		[self addConstraint: [SBVerticalConstraint constraintWithItem: constrainedItem belowItem: adjacentItem]];
	}
#ifdef DEBUG
	NSAssert( constrainedItem && adjacentItem, @"Required.");
#endif
}

-(void) view: (UIView *) view isCollapsed: (BOOL) collapsed
{
	SBLayoutItem *item = [self layoutItemForView: view];
#ifdef DEBUG
	NSAssert( item, @"Required." );
#endif
	[self setIsCollapsed: collapsed forItem: item];
}

-(void) viewTakesRemainingVerticalSpaceInSuperview: (UIView *) view
{
	SBLayoutItem *layoutItem = [self layoutItemForView: view];
	if( layoutItem )
	{
		[self addConstraint: [SBRemainingSpaceConstraint constraintWithItem: layoutItem style: kSBRemainingBelow]];
	}
#ifdef DEBUG
	NSAssert( layoutItem, @"Required." );
#endif
}

-(BOOL) isViewCollapsed: (UIView *) view
{
	NSArray *constraintsFound = [self constraintsForItem: [self layoutItemForView: view] withClass: [SBSupressItemConstraint class]];
	return [constraintsFound count] > 0;
}

-(void) setRootViewSize: (CGSize) size
{
	_rootLayoutItem.view.frame = CGRectIntegral(CGRectMake( _rootLayoutItem.view.frame.origin.x, _rootLayoutItem.view.frame.origin.y, size.width, size.height ));
}


-(void) layout
{
	
#ifdef DEBUG_LAYOUT
	NSLog( @"Performing layout for %@", self.rootLayoutItem );
#endif
	NSMutableArray *predicates = [NSMutableArray array];

	// content size changes first
	[predicates addObject: [NSPredicate predicateWithFormat: @"canChangeContentSize == %@ && shouldLayoutLast == %@", [NSNumber numberWithBool: YES], [NSNumber numberWithBool: NO]]];
	
	// positioning restraints
	[predicates addObject: [NSPredicate predicateWithFormat: @"canChangeContentSize == %@ && shouldLayoutLast == %@", [NSNumber numberWithBool: NO], [NSNumber numberWithBool: NO]]];
	
	// anything that needs to be done last
	[predicates addObject: [NSPredicate predicateWithFormat: @"shouldLayoutLast == %@", [NSNumber numberWithBool: YES]]];
	
	for( NSPredicate *predicate in predicates )
	{
		NSArray *constraints = [_constraints filteredArrayUsingPredicate: predicate];
		[constraints makeObjectsPerformSelector: @selector(layout)];
	}
	
	if( _layoutCompleteBlock )
	{
		_layoutCompleteBlock();
	}
}


-(void) restoreLayout
{
	[self enumerateItemsWithBlock: ^(SBLayoutItem * item, BOOL *shouldStop) { [item revertFrame];	}];
}

-(CGSize) sizeThatFits: (CGSize) size
{
	CGSize maxSize = CGSizeZero;
	for( SBLayoutItem *item in self.rootLayoutItem.subItems )
	{
		maxSize = CGSizeMake( MAX(maxSize.width,CGRectGetMaxX(item.frame)), MAX(maxSize.height,CGRectGetMaxY(item.frame)) );
	}
	maxSize.height += self.bottomLeading;
	if( maxSize.height < self.minimumHeight )
	{
		maxSize.height = self.minimumHeight;
	}
	
	return maxSize;
}

#pragma mark Internal Methods

-(void) loadViewHierarchy: (UIView *) view
{
	_rootLayoutItem = [[SBLayoutItem layoutItemWithView: view superItem: nil] retain];
	[self addSubItemsToRootItem: _rootLayoutItem 
				  withSuperview: view 
						outlets: nil];
		
}

-(void) addSubItemsToRootItem: (SBLayoutItem *) rootItem 
				withSuperview: (UIView *) rootView
					  outlets: (NSDictionary *) outlets;
{
	for( UIView *subview in rootView.subviews )
	{
		SBLayoutItem *item = [SBLayoutItem layoutItemWithView: subview superItem: rootItem];
		
		NSString *outletName = [outlets objectForKey: [subview description]];
		if( outletName )
		{
			item.outletName = outletName;
			[_outlets setObject: item forKey: outletName];
		}
		
		// if we've provided a binding value in the label, grab that
		if( [subview isKindOfClass: [UILabel class]] )
		{
			UILabel *label = (UILabel *)subview;
			if( [label.text hasPrefix: @"@"] )
			{
				NSString *bindingName = [label.text stringByReplacingOccurrencesOfString: @"@" withString: @""];
				item.bindingName = bindingName;
				[_bindings setObject: item forKey: bindingName];
				// reset the label text
				label.text = @"";
			}
		}
		
 		[rootItem addSubItem: item];
		
		[self addSubItemsToRootItem: item 
					  withSuperview: subview
							outlets: outlets];
	}
}

-(void) dealloc 
{
    [_rootLayoutItem release];
	[_constraints release];
	[_bindings release];
	[_outlets release];
    [super dealloc];
}


@end
