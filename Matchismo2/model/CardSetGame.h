//
//  CardSetGame.h
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "CardGame.h"

@interface CardSetGame : CardGame

@property (nonatomic) int numOfHints;

-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
-(NSMutableArray*)findHint;
-(BOOL)ifMatchExist;
-(void)applyMatchExistedPenalty;

@end
