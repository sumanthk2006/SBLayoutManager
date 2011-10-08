//
//  AccomplishmentsPortfolio.h
//  SBLayoutProDemo
//
//  Created by Steve Breen on 10/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Accomplishment.h"


@interface AccomplishmentsPortfolio : NSObject
{
	NSArray		*_accomplishments;
}

@property (nonatomic, readonly)		NSArray		*accomplishments;			// Accomplishment

+(AccomplishmentsPortfolio *) sharedInstance;


@end
