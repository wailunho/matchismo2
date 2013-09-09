//
//  CardgameViewController.m
//  Matchismo2
//
//  Created by William Ho on 8/31/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "CardgameViewController.h"
#import "CardGame.h"
#import "CardMatchingGame.h"
#import "CardSetGame.h"

@interface CardgameViewController () <UICollectionViewDataSource>

@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *selectedCardCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *matchedCardCollectionView;
@property (strong, nonatomic) NSMutableArray *cardsSelected;
@property (strong, nonatomic) NSMutableArray *cardsMatched; //also use for mismatched
@property (strong, nonatomic) NSMutableArray *cardsQueue;
@property (nonatomic) int numCardsSelected;
@property (nonatomic) int numCardsMatched;
@property (weak, nonatomic) IBOutlet UILabel *matchedLabel;
@property(nonatomic) NSUInteger currentNumOfCards;

@end

@implementation CardgameViewController

#define SET_RESULTS_KEY @"Set_GameResult_All"
#define MATCH_RESULTS_KEY @"Match_GameResult_All"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.currentNumOfCards = self.startingCardCount;
}

#pragma mark - Setters

#pragma mark - Getters

-(NSMutableArray *)cardsQueue
{
    if(!_cardsQueue)_cardsQueue = [[NSMutableArray alloc] init];
    return _cardsQueue;
}

-(NSMutableArray *)cardsSelected
{
    if(!_cardsSelected)_cardsSelected = [[NSMutableArray alloc] init];
    return _cardsSelected;
}

-(NSMutableArray *)cardsMatched
{
    if(!_cardsMatched)_cardsMatched = [[NSMutableArray alloc] init];
    return _cardsMatched;
}
-(CardGame*)game
{
    if(!_game)_game = [[CardGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]];
    return _game;
}

-(GameResult*)gameResult
{
    if(!_gameResult)_gameResult = [[GameResult alloc] init];
    return _gameResult;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([collectionView isEqual:self.cardCollectionView])
        return self.currentNumOfCards;
    else if([collectionView isEqual:self.selectedCardCollectionView])
    {
        return self.numCardsSelected;
    }
    else if([collectionView isEqual:self.matchedCardCollectionView])
    {
        if([self.cardsMatched count] == self.numOfCardToMatch)
            return self.numCardsMatched;
        else
            return 0;
    }
    else
        return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    if([collectionView isEqual:self.cardCollectionView])
    {
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    else if([collectionView isEqual:self.selectedCardCollectionView])
    {
        Card *card = self.cardsSelected[indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    else if([collectionView isEqual:self.matchedCardCollectionView])
    {
        Card *card = self.cardsMatched[indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    return cell;
}

#pragma mark - Helpers

//remove selected cards from the screen
-(void) removeSelectedCards
{
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.numCardsSelected; i++)
        [indexArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    
    [self.selectedCardCollectionView performBatchUpdates:^{
        self.numCardsSelected = 0;
        [self.selectedCardCollectionView deleteItemsAtIndexPaths:indexArray];
    } completion:nil];
}

//remove matched cards from the screen
-(void) removeMatchedCards
{
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.numCardsMatched; i++)
        [indexArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    
    [self.matchedCardCollectionView performBatchUpdates:^{
        self.numCardsMatched = 0;
        [self.matchedCardCollectionView deleteItemsAtIndexPaths:indexArray];
    } completion:nil];
}

//add selected cards onto the screen
-(void) addCardsFromSelected
{
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.cardsSelected count]; i++)
        [indexArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    
    [self.selectedCardCollectionView performBatchUpdates:^{
        self.numCardsSelected = [self.cardsSelected count];
        [self.selectedCardCollectionView insertItemsAtIndexPaths:indexArray];
    } completion:nil];
}

//add matched scards onto the screen
-(void) addCardsFromMatched
{
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.cardsMatched count]; i++)
        [indexArray addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    
    [self.matchedCardCollectionView performBatchUpdates:^{
        self.numCardsMatched = [self.cardsMatched count];
        [self.matchedCardCollectionView insertItemsAtIndexPaths:indexArray];
    } completion:nil];
}

#pragma mark - Main functions

-(Deck*)createDeck
{
    return nil; //abstract
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // abstract
}
- (IBAction)deal:(id)sender
{
    self.currentNumOfCards = self.startingCardCount;
    self.gameResult = nil;
    self.game = nil;
    self.flipCount = 0;
    [self.cardCollectionView reloadData];
    
    //remove cards from selected section
    [self removeSelectedCards];
    self.cardsSelected = nil;
    
    //remove cards from matched section
    [self removeMatchedCards];
    self.cardsMatched = nil;
    self.cardsQueue = nil;
    [self updateUI];
}
- (IBAction)flipCard:(UITapGestureRecognizer*)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    Card* card = [self.game cardAtIndex:indexPath.item];
    if(indexPath && !card.isUnplayable)
    {
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        self.gameResult.score = self.game.score;
        
        //if face up
        if(card.isFaceUp)
        {
            //add card to queue but only add card to cardsSelected array when it is
            //playable
            [self.cardsQueue addObject:card];
            
            if(!card.isUnplayable)
                [self.cardsSelected addObject:card];
        }
        //else it is face down
        else
        {
            //find and remove the card from the queue
            for(int j = 0; j < [self.cardsQueue count]; j++)
            {
                if([[self.cardsQueue[j] contents] isEqualToString:card.contents])
                {
                    [self.cardsQueue removeObjectAtIndex:j];
                }
            }
        }

        //removes cards that have deselected by searching all the
        //cards that are facing down or unplayable, from the cardsSelected array
        for(int i = 0; i < [self.game.cards count];i++)
        {
            Card *tempCard = [self.game cardAtIndex:i];
            if(!tempCard.isFaceUp || tempCard.isUnplayable)
            {
                for(int j = 0; j < [self.cardsSelected count]; j++)
                {
                    if([[self.cardsSelected[j] contents] isEqualToString:tempCard.contents])
                    {
                        [self.cardsSelected removeObjectAtIndex:j];
                    }
                }
            }
        }
        //if the queue has count equal to the number of card to match, the
        //match/mismatch is found.
        if([self.cardsQueue count] == self.numOfCardToMatch)
        {
            self.cardsMatched = [[NSMutableArray alloc] initWithArray:self.cardsQueue];
            self.cardsQueue = [[NSMutableArray alloc] initWithArray:self.cardsSelected];
        }

        [self updateUI];
        
        //synchronize the game result data with different keys
        if([self.game isMemberOfClass:[CardMatchingGame class]])
            [self.gameResult synchronizeWithKey:MATCH_RESULTS_KEY];
        else if([self.game isMemberOfClass:[CardSetGame class]])
            [self.gameResult synchronizeWithKey:SET_RESULTS_KEY];
    }
}

-(void)synchronize: (GameResult*)gameResult
{
    //abstract
}

- (void)updateUI
{
    //update cards in the playing section of the screen
    //add selected cards
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    //remove cards from the selected section of the screen
    [self removeSelectedCards];
    
    //add cards into selected section
    [self addCardsFromSelected];
    
    //update cards in matched/mismatched section of the screen
    if([self.cardsMatched count] == self.numOfCardToMatch)
    {
        //remove matched/mismatched cards
        [self removeMatchedCards];
        
        //add cards into matched/mismatched section
        [self addCardsFromMatched];
    }
    
    //update other labels
    self.matchedLabel.text = self.game.lastFlipResultString;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

-(void)removeCardAtCell:(UICollectionViewCell*)cell
{
    self.currentNumOfCards--;
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
    [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
}

-(void)addCard
{
    self.currentNumOfCards++;
    [self.cardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.currentNumOfCards - 1 inSection:0]]];
}

@end
