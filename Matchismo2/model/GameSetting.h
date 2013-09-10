//
//  GameSetting.h
//  Matchismo2
//
//  Created by William Ho on 9/9/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSetting : NSObject

@property (nonatomic) NSUInteger numOfStartingCard;

+(NSUInteger)numOfStartingCard;
-(void)setNumOfStartingCard:(NSUInteger)numOfStartingCard;

@end
