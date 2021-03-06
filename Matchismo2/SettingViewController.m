//
//  SettingViewController.m
//  Matchismo2
//
//  Created by William Ho on 9/2/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SettingViewController.h"
#import "GameSetting.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numOfStartingCardLabel;
@property (weak, nonatomic) IBOutlet UISlider *numOfStartingCardSlider;
@property (strong, nonatomic) GameSetting *setting;
@end

@implementation SettingViewController

#define SET_RESULTS_KEY @"Set_GameResult_All"
#define MATCH_RESULTS_KEY @"Match_GameResult_All"

- (void)viewWillAppear:(BOOL)animated
{
    //initialization
    self.numOfStartingCardSlider.value = [GameSetting numOfStartingCard];
    self.numOfStartingCardLabel.text = [NSString stringWithFormat:@"Number of starting cards: %d", [GameSetting numOfStartingCard]];
}

#pragma mark - Getters

-(GameSetting *)setting
{
    if(!_setting)_setting = [[GameSetting alloc] init];
    return _setting;
}

#pragma mark - Main Functions

- (IBAction)resetRanking:(id)sender
{
    //reset both ranking
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SET_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MATCH_RESULTS_KEY];
}

- (IBAction)changeNumOfStartingCard:(id)sender
{
    [self.setting setNumOfStartingCard:(int)roundf(self.numOfStartingCardSlider.value)];
    self.numOfStartingCardLabel.text = [NSString stringWithFormat:@"Number of starting cards: %d", [GameSetting numOfStartingCard]];
}

@end

