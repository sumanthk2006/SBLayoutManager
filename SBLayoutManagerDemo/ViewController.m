//
//  ViewController.m
//  SBLayoutProDemo
//
//  Created by Steve Breen on 10/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AccomplishmentsPortfolio.h"
#import "UIView+DebugAdditions.h"

@interface ViewController()
-(void) configureBarButtonItems;
-(void) updateCurrentAccomplishment;
@end


@implementation ViewController
@synthesize titleLabel;
@synthesize yearLabel;
@synthesize descriptionLabel;
@synthesize footerLabel;
@synthesize imageView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.navigationItem.title = NSLocalizedString(@"Layout Demo", @"");
	
	// configure our layout manager
	_layoutManager = [SBLayoutManager layoutManagerWithRootView: [self view]];
	[_layoutManager view: self.titleLabel isRightOfView: self.imageView];
	[_layoutManager view: self.yearLabel isRightOfView: self.titleLabel];
	[_layoutManager view: self.descriptionLabel isRightOfView: self.imageView];
	[_layoutManager view: self.footerLabel isRightOfView: self.imageView];
	
	[_layoutManager viewIsVariableWidth: self.titleLabel];
	[_layoutManager viewIsVariableHeight: self.descriptionLabel];
	[_layoutManager view: self.footerLabel isBelowView: self.descriptionLabel];

	[self configureBarButtonItems];	
	[self updateCurrentAccomplishment];
}


- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setYearLabel:nil];
    [self setDescriptionLabel:nil];
    [self setFooterLabel:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[_layoutManager layout];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[_layoutManager layout];
}

-(void) next:(id) sender
{
	_currentAccomplishmentIndex++;
	if( _currentAccomplishmentIndex >= [[[AccomplishmentsPortfolio sharedInstance] accomplishments] count] )
	{
		_currentAccomplishmentIndex = 0;
	}
	[self updateCurrentAccomplishment];
}

-(void) toggleBoundingRects: (id) sender
{
	_showBoundingRects = !_showBoundingRects;
	if( _showBoundingRects )
	{
		[[self view] showAllBoundingRects];
	}
	else
	{
		[[self view] hideAllBoundingRects];
	}
	
	[self configureBarButtonItems];
}

#pragma mark- Internal Methods

-(void) configureBarButtonItems
{
	NSString *boundingRectTitle = _showBoundingRects ? NSLocalizedString(@"Hide Bounds", @"Hide Bounds") : NSLocalizedString(@"Show Bounds",  @"Show Bounds");
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: boundingRectTitle
																			 style: UIBarButtonItemStyleBordered
																			target: self
																			action: @selector(toggleBoundingRects:)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Next", @"Next") 
																			  style: UIBarButtonItemStyleDone
																			 target: self 
																			 action: @selector(next:)];
}

-(void) updateCurrentAccomplishment
{
	Accomplishment *accomplishment = [[[AccomplishmentsPortfolio sharedInstance] accomplishments] objectAtIndex: _currentAccomplishmentIndex];
	
	self.titleLabel.text = [accomplishment title];
	self.yearLabel.text = [[accomplishment year] stringValue];
	self.descriptionLabel.text = [accomplishment longDescription];
	self.imageView.image = [accomplishment image];
	
	// size our interface items to match the data as defined by the layout manager's configuration
	[_layoutManager layout];
}

@end
