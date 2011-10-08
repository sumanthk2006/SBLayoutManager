#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class SBLayoutItem;

typedef enum { kSBLayoutItemKindCustom=0, kSBLayoutItemKindLabel, kSBLayoutItemKindImage } SBLayoutItemKind;

typedef void (^LIRequestContentDataBlock)( SBLayoutItem *layoutItem );


@interface SBLayoutItem : NSObject 
{
	CGRect						_frame;
	CGRect						_originalFrame;
	NSString					*_bindingName;
	NSString					*_outletName;
	SBLayoutItem				*_superItem;
	NSMutableArray				*_subItems;
	SBLayoutItemKind			_kind;
	
	
@private
	id							_contentData;
	UIViewContentMode			_contentMode;
	NSInteger					_numberOfLines;
	UIFont						*_font;
	UIColor						*_color;
	UIColor						*_backgroundColor;
	UILineBreakMode				_lineBreakMode;
	UIView						*_view;
	LIRequestContentDataBlock	_requestContentDataBlock;
}

@property (nonatomic, assign)	CGRect						frame;
@property (nonatomic, copy)		NSString					*bindingName;			// @foo values for binding to some object
@property (nonatomic, copy) 	NSString					*outletName;			// @outlets from NIB
@property (nonatomic, retain)	SBLayoutItem				*superItem;
@property (nonatomic, retain)	NSArray						*subItems;
@property (nonatomic, retain)	id							contentData;
@property (nonatomic, assign) 	UILineBreakMode				lineBreakMode;
@property (nonatomic, assign) 	BOOL						hidden;
@property (nonatomic, assign) 	UIViewContentMode			contentMode;
@property (nonatomic, assign) 	NSInteger					numberOfLines;
@property (nonatomic, retain) 	UIFont						*font;
@property (nonatomic, retain) 	UIColor						*color;
@property (nonatomic, retain) 	UIColor						*backgroundColor;
@property (nonatomic, retain)	UIView						*view;
@property (nonatomic, copy)		LIRequestContentDataBlock	requestContentDataBlock;


+(SBLayoutItem *) layoutItemWithView: (UIView *) view
						   superItem: (SBLayoutItem *) superItem;

-(void) addSubItem: (SBLayoutItem *) subItem;
-(void) revertFrame;

-(BOOL) isLabel;
-(BOOL) isImageView;

@end
