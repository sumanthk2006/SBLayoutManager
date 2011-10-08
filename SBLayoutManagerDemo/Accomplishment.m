//
//  Accomplishment.m
//  SBLayoutProDemo
//
//  Created by Steve Breen on 10/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Accomplishment.h"

@implementation Accomplishment

@synthesize title;
@synthesize longDescription;
@synthesize year;
@synthesize image;

+(Accomplishment *) accomplishmentWithDictionary: (NSDictionary *) dict
{
	Accomplishment *accomplishment = [[self alloc] init];
	if( [dict isKindOfClass: [NSDictionary class]] )
	{
		accomplishment.title = [dict objectForKey: @"title"];
		accomplishment.longDescription = [dict objectForKey: @"description"];
		accomplishment.year = [dict objectForKey: @"year"];
		accomplishment.image = [UIImage imageNamed: [dict objectForKey: @"image"]];
	}
	return accomplishment;
}

@end
