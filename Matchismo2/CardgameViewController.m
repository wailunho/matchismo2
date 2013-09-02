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

@end

@implementation CardgameViewController

#define SET_RESULTS_KEY @"Set_GameResult_All"
#define MATCH_RESULTS_KEY @"Match_GameResult_All"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Setters

#pragma mark - Getters
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
    return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
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
    self.gameResult = nil;
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}
- (IBAction)flipCard:(UITapGestureRecognizer*)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if(indexPath)
    {
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        [self updateUI];
        self.gameResult.score = self.game.score;
        
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
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
