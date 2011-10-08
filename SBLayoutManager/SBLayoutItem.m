#import "SBLayoutItem.h"
#import <QuartzCore/QuartzCore.h>
#import "CGRectHelpers.h"

static NSInteger __layoutItemNextTag = 42;

@interface SBLayoutItem(internalMethods)
-(void) initCompleteWithView: (UIView *) view;
@end

@implementation SBLayoutItem

@synthesize frame = _frame;
@synthesize bindingName = _bindingName;
@synthesize outletName = _outletName;
@synthesize superItem = _superItem;
@synthesize subItems = _subItems;
@synthesize contentData = _contentData;
@synthesize lineBreakMode = _lineBreakMode;
@synthesize hidden = _hidden;
@synthesize contentMode = _contentMode;
@synthesize numberOfLines = _numberOfLines;
@synthesize font = _font;
@synthesize color = _color;
@synthesize backgroundColor = _backgroundColor;
@synthesize view = _view;
@synthesize requestContentDataBlock = _requestContentDataBlock;



-(id) initWithView: (UIView *) view
		 superItem: (SBLayoutItem *) superItem
{
	if( (self = [super init]) )
	{
		_subItems = [[NSMutableArray alloc] init];
		_superItem = [superItem retain];
		[self initCompleteWithView: view];
	}
	return self;
}

-(void) initCompleteWithView: (UIView *) view
{
	// common attributes
	if( !view.tag )
		view.tag = __layoutItemNextTag++;
	
	_view = view;
	_frame = view.frame;
	_originalFrame = view.frame;
	_backgroundColor = [view.backgroundColor retain];
	_contentMode = view.contentMode;
	
	// class specific attributes
	if( [view isKindOfClass: [UILabel class]] && [view superclass] != [UILabel class] )
	{
		_kind = kSBLayoutItemKindLabel;
		UILabel *label = (UILabel *)view;
		_color = [label.textColor retain];
		_contentData = [label.text copy];
		_numberOfLines = label.numberOfLines;
		_font = [label.font retain];
		_lineBreakMode = label.lineBreakMode;
	}
	else if( [view isKindOfClass: [UIImageView class]] )
	{
		_kind = kSBLayoutItemKindImage;
		UIImageView *imageView = (UIImageView *)view;
		_contentData = [imageView retain];
	}
	else
	{
		_kind = kSBLayoutItemKindCustom;
	}
}

-(void) setFrame:(CGRect)frame
{
	// sanity check. CA hates NaN and your app will die an ugly death.
	if( CGRectIsInvalid(frame) )
		return;
	
	// be sure we're point aligned
	frame = CGRectIntegral( frame );
	
	NSString * const kKey = @"frame";
	[self willChangeValueForKey: kKey];
	_frame = frame;
	[self didChangeValueForKey: kKey];
	
	if( _view )
	{
		_view.frame = frame;
	}
}

-(BOOL) hidden
{
	return _view.hidden;
}

-(void) setHidden:(BOOL)hidden
{
	NSString *kKey = @"hidden";
	[self willChangeValueForKey: kKey];
	_view.hidden = hidden;
	[self didChangeValueForKey: kKey];
}


-(CGRect) frame
{
	CGRect frame = _frame;
	if( _view )
	{
		frame = _view.frame;
	}
	return frame;
}

-(void) dealloc 
{
	[_requestContentDataBlock release];
	[_outletName release];
	[_bindingName release];
	[_superItem release];
	[_subItems release];
	[_font release];
	[_backgroundColor release];
	[_color release];
	[_view release];

    [super dealloc];
}

-(void) addSubItem:(SBLayoutItem *)subItem
{
	[_subItems addObject: subItem];
}

-(NSArray *) subItems
{
	return [NSArray arrayWithArray: _subItems];
}

-(void) revertFrame
{
	self.frame = _originalFrame;
}

+(SBLayoutItem *) layoutItemWithView: (UIView *) view
						   superItem: (SBLayoutItem *) superItem
{
	return [[[self alloc] initWithView: view superItem: superItem] autorelease];
}

-(BOOL) isLabel
{
	return _kind == kSBLayoutItemKindLabel;
}

-(BOOL) isImageView
{
	return _kind == kSBLayoutItemKindImage;
}

-(NSString *) description
{
	return [NSString stringWithFormat: @"LPLayoutItem %@ binding %@ outlet %@ rootView.class = %@", NSStringFromCGRect(self.frame), self.bindingName, self.outletName, [self.view class]];
}

@end
