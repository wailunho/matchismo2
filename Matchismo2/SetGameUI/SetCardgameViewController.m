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
#import "SelectedSetCardCollectionViewCell.h"
#import "MatchedSetCardCollectionViewCell.h"

@interface SetCardgameViewController ()

@property (strong, nonatomic) CardSetGame *game;
@property (strong, nonatomic) NSMutableArray *cardsForHint;

@end

@implementation SetCardgameViewController

#define ALPHA_UNPLAYABLE 0.4
#define ALPHA_PLAYABLE 1.0

#pragma mark - Setters

#pragma mark - Getters

-(CardSetGame *)game
{
    if(!_game)
    {
        _game = [[CardSetGame alloc ] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
        self.cardsForHint = nil;
    }
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
-(NSMutableArray *)cardsForHint
{
    if(!_cardsForHint)_cardsForHint = [[NSMutableArray alloc] init];
    return _cardsForHint;
}

#pragma mark - Helpers



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
            if(setCard.isUnplayable)
                [self removeCardAtCell:cell];
            setCardView.hintOn = NO;
            for(SetCard* otherSetCard in self.cardsForHint)
            {
                if([setCard.contents isEqualToString:otherSetCard.contents])
                    setCardView.hintOn = YES;
            }
        }
    }
    else if([cell isKindOfClass:[SelectedSetCardCollectionViewCell class]])
    {
        SetCardView *setCardView = ((SelectedSetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard = (SetCard *)card;
            setCardView.symbol = setCard.symbol;
            setCardView.numOfSymbol = setCard.numOfSymbol;
            setCardView.color = setCard.color;
            setCardView.shading = setCard.shading;
            setCardView.selected = NO;
            setCardView.hintOn = NO;
        }
    }
    else if([cell isKindOfClass:[MatchedSetCardCollectionViewCell class]])
    {
        SetCardView *setCardView = ((MatchedSetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard = (SetCard *)card;
            setCardView.symbol = setCard.symbol;
            setCardView.numOfSymbol = setCard.numOfSymbol;
            setCardView.color = setCard.color;
            setCardView.shading = setCard.shading;
            setCardView.selected = NO;
            setCardView.hintOn = NO;
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

- (IBAction)showHint:(id)sender
{
    self.cardsForHint = nil;
    for(int i = 0; i < [self.game.cards count] - 2; i++)
    {
        for(int j = i + 1; j < [self.game.cards count] - 1; j++)
        {
            for(int k = j + 1; k < [self.game.cards count]; k++)
            {
                SetCard *firstCard = self.game.cards[i];
                SetCard *secondCard = self.game.cards[j];
                SetCard *thirdCard = self.game.cards[k];
                if([firstCard match:@[secondCard, thirdCard]])
                {
                    [self.cardsForHint addObjectsFromArray:@[firstCard, secondCard, thirdCard]];
                    goto DONE;
                }
            }
        }
    }
    DONE:
    [self updateUI];
}

@end
