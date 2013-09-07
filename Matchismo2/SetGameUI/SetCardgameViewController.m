//
//  SetCardgameViewController.m
//  Matchismo2
//
//  Created by William Ho on 9/6/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetCardgameViewController.h"
#import "CardSetGame.h"
#import "SetCardDeck.h"
#import "SetGameResult.h"
#import "SetCardCollectionViewCell.h"

@interface SetCardgameViewController ()

@property (strong, nonatomic) CardSetGame *game;

@end

@implementation SetCardgameViewController

#define ALPHA_UNPLAYABLE 0.4
#define ALPHA_PLAYABLE 1.0

#pragma mark - Setters

-(CardSetGame *)game
{
    if(!_game)_game = [[CardSetGame alloc ] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
    return _game;
}

-(NSUInteger)startingCardCount
{
    return 12;
}

-(NSUInteger)numOfCardToMatch
{
    return 3;
}

#pragma mark - Main Functions

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]])
    {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard = (SetCard *)card;
            setCardView.symbol = setCard.symbol;
            setCardView.numOfSymbol = setCard.numOfSymbol;
            setCardView.color = setCard.color;
            setCardView.shading = setCard.shading;
            setCardView.selected = setCard.faceUp;
            setCardView.alpha = setCard.isUnplayable ? ALPHA_UNPLAYABLE : ALPHA_PLAYABLE;
        }
    }
}

-(void)synchronize:(GameResult *)gameResult
{
    if([gameResult isKindOfClass:[SetGameResult class]])
    {
        SetGameResult *setGameResult = (SetGameResult*)gameResult;
        if(setGameResult)
            [setGameResult synchronize];
    }
}

@end
