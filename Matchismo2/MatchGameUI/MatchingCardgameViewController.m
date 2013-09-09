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
#import "SelectedMatchingCardCollectionViewCell.h"
#import "MatchedMatchingCardCollectionViewCell.h"
#import "MatchingGameResult.h"

@interface MatchingCardgameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation MatchingCardgameViewController

#define ALPHA_UNPLAYABLE 0.4
#define ALPHA_PLAYABLE 1.0

#pragma mark - Getters

-(CardMatchingGame*)game
{
    if(!_game)_game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
    return _game;
}

-(NSUInteger)startingCardCount
{
    return 22;
}
-(NSUInteger)numOfCardToMatch
{
    return 2;
}

#pragma mark - Main Functions

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[MatchingCardCollectionViewCell class]])
    {
        MatchingCardView *matchingCardView = ((MatchingCardCollectionViewCell *)cell).matchingCardView;
        if ([card isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            matchingCardView.rank = playingCard.rank;
            matchingCardView.suit = playingCard.suit;
            matchingCardView.faceUp = playingCard.isFaceUp;
            matchingCardView.alpha = playingCard.isUnplayable ? ALPHA_UNPLAYABLE : ALPHA_PLAYABLE;
        }
    }
    
    else if([cell isKindOfClass:[SelectedMatchingCardCollectionViewCell class]])
    {
        if ([card isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            MatchingCardView *matchingCardView = ((SelectedMatchingCardCollectionViewCell *)cell).selectedMatchingCardView;
            matchingCardView.rank = playingCard.rank;
            matchingCardView.suit = playingCard.suit;
            matchingCardView.faceUp = YES;
        }
    }
    else if([cell isKindOfClass:[MatchedMatchingCardCollectionViewCell class]])
    {
        if ([card isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            MatchingCardView *matchingCardView = ((MatchedMatchingCardCollectionViewCell *)cell).matchedMatchingCardView;
            matchingCardView.rank = playingCard.rank;
            matchingCardView.suit = playingCard.suit;
            matchingCardView.faceUp = YES;
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
