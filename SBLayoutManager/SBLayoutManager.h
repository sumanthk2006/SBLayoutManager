#import <Foundation/Foundation.h>

#import "SBLayoutItem.h"
#import "SBLayoutConstraint.h"
#import "SBHorizontalConstraint.h"
#import "SBVerticalConstraint.h"
#import "SBVariableContentSizeConstraint.h"
#import "SBVariableContentHeightConstraint.h"
#import "SBVariableContentWidthConstraint.h"
#import "SBSupressItemConstraint.h"
#import "SBRemainingSpaceConstraint.h"
#import "SBCenteredConstraint.h"

typedef void (^VisitLayoutItemBlock)( SBLayoutItem * item, BOOL *shouldStop );
typedef void (^LayoutIsCompleteBlock)();

@interface SBLayoutManager : NSObject
{
@private
	NSMutableArray					*_constraints;
	SBLayoutItem					*_rootLayoutItem;
	NSMutableDictionary				*_bindings;
	NSMutableDictionary				*_outlets;
	BOOL							_doesDirectDrawing;
	CGFloat							_bottomLeading;
	LayoutIsCompleteBlock			_layoutCompleteBlock;
	CGFloat							_minimumHeight;
}

@property (nonatomic, readonly) SBLayoutItem					*rootLayoutItem;
@property (nonatomic, assign)	CGFloat							bottomLeading;
@property (nonatomic, assign)	CGFloat							minimumHeight;
@property (nonatomic, copy)		LayoutIsCompleteBlock			layoutCompleteBlock;

									
+(SBLayoutManager *) layoutManagerWithRootView: (UIView *) rootView;			

// configure
-(void) viewIsVariableHeight: (UIView *) view;
-(void) viewIsVariableHeight: (UIView *) view minHeight: (CGFloat) minHeight;
-(void) viewIsVariableWidth: (UIView *) view;
-(void) viewIsVariableWidth: (UIView *) view maxWidth: (CGFloat) maxWidth;

-(void) viewIsCenteredVertically: (UIView *) view;
-(void) viewIsCenteredHorizontally: (UIView *) view;

-(void) view: (UIView *) view isRightOfView: (UIView *) otherView;
-(void) view: (UIView *) view isLeftOfView: (UIView *) otherView;
-(void) view: (UIView *) view isAboveView: (UIView *) otherView;
-(void) view: (UIView *) view isBelowView: (UIView *) otherView;
-(void) view: (UIView *) view isCollapsed: (BOOL) collapsed;

-(void) viewTakesRemainingVerticalSpaceInSuperview: (UIView *) view;

-(BOOL) isViewCollapsed: (UIView *) view;

// perform the layout
-(void) layout;
-(void) restoreLayout;															// back to original state; useful for re-use of layout manager
-(CGSize) sizeThatFits: (CGSize) size;											// walks top-level views to find MAX x,y. Subclass for special cases.

@end


// -- Notifications -- //

extern NSString * const kSBLayoutManagerConstraintsDidChangeNotification;
