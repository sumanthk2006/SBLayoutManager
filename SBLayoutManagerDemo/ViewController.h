//
//  ViewController.h
//  SBLayoutProDemo
//
//  Created by Steve Breen on 10/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBLayoutManager.h"

@interface ViewController : UIViewController
{
	SBLayoutManager		*_layoutManager;
	NSInteger			_currentAccomplishmentIndex;
	BOOL				_showBoundingRects;
}

@property (weak, nonatomic) IBOutlet	UILabel		*titleLabel;
@property (weak, nonatomic) IBOutlet	UILabel		*yearLabel;
@property (weak, nonatomic) IBOutlet	UILabel		*descriptionLabel;
@property (weak, nonatomic) IBOutlet	UILabel		*footerLabel;
@property (weak, nonatomic) IBOutlet	UIImageView *imageView;

@end
