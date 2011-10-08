#import "UIView+DebugAdditions.h"
#import "UIView+HierarchyAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(DebugAdditions)

-(void) showAllBoundingRects
{
	for( UIView *view in [self allSubviews] )
	{
		view.clipsToBounds = YES;
		view.layer.borderWidth = 1.0;
		view.layer.borderColor = [UIColor blackColor].CGColor;
	}
}

@end
