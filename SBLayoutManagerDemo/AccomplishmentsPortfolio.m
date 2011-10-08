//
//  AccomplishmentsPortfolio.m
//  SBLayoutProDemo
//
//  Created by Steve Breen on 10/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AccomplishmentsPortfolio.h"

static AccomplishmentsPortfolio *__sharedAccomplismentsPortfolio;

@implementation AccomplishmentsPortfolio


+(void) initialize
{
	if( !__sharedAccomplismentsPortfolio )
		__sharedAccomplismentsPortfolio = [[self alloc] init];
}

+(AccomplishmentsPortfolio *) sharedInstance
{
	return __sharedAccomplismentsPortfolio;
}

-(NSArray *) accomplishments
{
	if( !_accomplishments )
	{
		NSMutableArray *accomplishments = [NSMutableArray array];
		NSArray *accomplishmentDicts = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"Accomplishments"];
		for( NSDictionary *dict in accomplishmentDicts )
		{
			[accomplishments addObject: [Accomplishment accomplishmentWithDictionary: dict]];
		}
		_accomplishments = [[NSArray alloc] initWithArray: accomplishments];
	}
	return _accomplishments;
}


@end
