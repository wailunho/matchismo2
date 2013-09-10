//
//  CardgameViewController.h
//  Matchismo2
//
//  Created by William Ho on 8/31/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "GameResult.h"

@interface CardgameViewController : UIViewController

//all abstracts need to be overrided
@property (readonly, nonatomic) NSUInteger startingCardCount; //abstract
@property (readonly, nonatomic) NSUInteger numOfCardToMatch; //abstract
@property (nonatomic) BOOL removeCardsFromView; //abstract

- (Deck *)createDeck; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; // abstract
-(void)synchronize:(GameResult*)gameResult; //abstract
-(void)addCard;
- (void)updateUI;
@end
