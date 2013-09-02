//
//  MatchingCardgameViewController.m
//  Matchismo2
//
//  Created by William Ho on 9/1/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "MatchingCardgameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "MatchingCardCollectionViewCell.h"
#import "MatchingGameResult.h"

@interface MatchingCardgameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation MatchingCardgameViewController

#define ALPHA_UNPLAYABLE 0.4
#define ALPHA_PLAYABLE 1.0

-(CardMatchingGame*)game
{
    if(!_game)_game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
    return _game;
}

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(NSUInteger)startingCardCount
{
    return 22;
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[MatchingCardCollectionViewCell class]]) {
        MatchingCardView *matchingCardView = ((MatchingCardCollectionViewCell *)cell).matchingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            matchingCardView.rank = playingCard.rank;
            matchingCardView.suit = playingCard.suit;
            matchingCardView.faceUp = playingCard.isFaceUp;
            matchingCardView.alpha = playingCard.isUnplayable ? ALPHA_UNPLAYABLE : ALPHA_PLAYABLE;
        }
    }    
}

-(void)synchronize:(GameResult *)gameResult
{
    if([gameResult isKindOfClass:[MatchingGameResult class]])
    {
        MatchingGameResult *matchingGameResult = (MatchingGameResult*)gameResult;
        if(matchingGameResult)
            [matchingGameResult synchronize];
    }
}

@end
