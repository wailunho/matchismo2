//
//  GameSetting.m
//  Matchismo2
//
//  Created by William Ho on 9/9/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "GameSetting.h"

@interface GameSetting()

@end

@implementation GameSetting

#define SETTING_DEFAULT_NUM_OF_STARTING_CARD 22
#define SETTING_NUM_OF_STARTING_CARD_KEY @"numOfStartingCard"
-(id)init
{
    self = [super init];
    if(self)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:SETTING_DEFAULT_NUM_OF_STARTING_CARD forKey:SETTING_NUM_OF_STARTING_CARD_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

#pragma mark - Getters

+(NSUInteger)numOfStartingCard
{
    NSUInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:SETTING_NUM_OF_STARTING_CARD_KEY];
    if(num)
        return num;
    else
        return SETTING_DEFAULT_NUM_OF_STARTING_CARD;
}

#pragma mark - Setters

-(void)setNumOfStartingCard:(NSUInteger)numOfStartingCard
{
    [[NSUserDefaults standardUserDefaults] setInteger:numOfStartingCard forKey:SETTING_NUM_OF_STARTING_CARD_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
