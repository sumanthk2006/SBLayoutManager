//
//  Accomplishment.h
//  SBLayoutProDemo
//
//  Created by Steve Breen on 10/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Accomplishment : NSObject

@property (nonatomic, strong)	NSString	*title;
@property (nonatomic, strong)	NSString	*longDescription;
@property (nonatomic, strong)	NSNumber	*year;
@property (nonatomic, strong)	UIImage		*image;

+(Accomplishment *) accomplishmentWithDictionary: (NSDictionary *) dict;

@end
