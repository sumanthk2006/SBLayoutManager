#import <UIKit/UIKit.h>

CGRect	CGRectMakeWithCenter( CGPoint center, CGSize size );
CGRect	CGRectMakeWithOrigin( CGPoint origin, CGSize size );
CGFloat	CGRectMaxX( CGRect rect );
CGFloat	CGRectMaxY( CGRect rect );
CGRect	CGRectMakeCenteredRect( CGRect superviewRect, CGSize subviewSize );
CGRect  CGRectMakeWithEdgeInsets( CGRect rect, UIEdgeInsets insets );
CGRect	CGRectMakeIntegral( CGRect rect );


BOOL	CGRectIsInvalid( CGRect rect );
