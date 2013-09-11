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
@property (weak, nonatomic) IBOutlet UIButton *addThreeCardsButton;
@property (weak, nonatomic) IBOutlet UIButton *hintButton;

@end

@implementation SetCardgameViewController

#define ALPHA_DISABLE 0.4
#define ALPHA_ENABLE 1.0

#pragma mark - Setters

#pragma mark - Getters

-(CardSetGame *)game
{
    if(!_game)
    {
        _game = [[CardSetGame alloc ] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
        self.cardsForHint = nil;
        [self.hintButton setTitle:[NSString stringWithFormat:@"Hint: %d", self.game.numOfHints] forState:UIControlStateNormal];
        self.addThreeCardsButton.enabled = YES;
        self.addThreeCardsButton.alpha = ALPHA_ENABLE;
        self.hintButton.enabled = YES;
        self.hintButton.alpha = ALPHA_ENABLE;
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

-(BOOL)removeCardsFromView
{
    return YES;
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
    self.cardsForHint = [self.game findHint];
    if(self.cardsForHint)
        [self updateUI];
    
    self.game.numOfHints--;
    [self.hintButton setTitle:[NSString stringWithFormat:@"Hint: %d", self.game.numOfHints] forState:UIControlStateNormal];
    
    if(!self.game.numOfHints)
    {
        self.hintButton.enabled = NO;
        self.hintButton.alpha = ALPHA_DISABLE;
    }
}

- (IBAction)addThreeCards:(id)sender
{
    if(3 <= [self.game.deck.cards count])
    {
        if([self.game ifMatchExist])
        {
            [self.game applyMatchExistedPenalty];
            self.game.numOfHints++;
            [self showHint:nil];
        }
        
        for(int i = 0; i < 3; i++)
        {
            [self addCardToCardCollectionView];
        }
    }
    else
    {
        self.addThreeCardsButton.enabled = NO;
        self.addThreeCardsButton.alpha = ALPHA_DISABLE;
    }
}

@end
