//
//  GameResult.h
//  Matchismo
//
//  Created by William Ho on 8/25/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "GameResult.h"

@interface MatchingGameResult : GameResult

+(NSArray*) allMatchGameResults;
-(void)synchronize;

@end
