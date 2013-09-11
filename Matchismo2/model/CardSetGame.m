//
//  CardSetGame.m
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "CardSetGame.h"
#import "SetCard.h"
#import "Deck.h"

@interface CardSetGame()

@end

@implementation CardSetGame

//socre multplier for card matching game
#define MATCH_BONUS 12
#define MISMATCH_PENALTY 6
#define FLIP_COST 1
#define ADD_CARDS_WHEN_MATCH_EXISTED_PENALTY 16

-(id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super initWithCardCount:count usingDeck:deck];
    if(self)
    {
        self.numOfHints = 5;
    }
    return self;
}

-(void)flipCardAtIndex:(NSUInteger) index
{
    Card *card = [self cardAtIndex:index];
    
    //check if card choosen and is playable
    if(card && !card.isUnplayable)
    {
        //check if card is not selected
        if(!card.isFaceUp)
        {
            //find another card(second card) that is already selected to do the matching
            for(SetCard *secondCard in self.cards)
            {
                if(secondCard.isFaceUp && !secondCard.isUnplayable)
                {
                    //second card is selected, we need to once again find another card that is selected.
                    for(SetCard *thirdCard in self.cards)
                    {
                        
                        if(thirdCard != secondCard && thirdCard.isFaceUp && !thirdCard.isUnplayable)
                        {
                            //three cards are selected
                            //match these three card.
                            int matchScore = [card match:@[secondCard, thirdCard]];
                            //they are matched
                            if (matchScore)
                            {
                                card.unplayable = YES;
                                secondCard.unplayable = YES;
                                thirdCard.unplayable = YES;
                                self.score += matchScore * MATCH_BONUS;
                                self.lastFlipResultString = [NSString stringWithFormat:@"Matched! +%d!", matchScore * MATCH_BONUS];
                            }
                            //not matched
                            else
                            {
                                secondCard.FaceUp = NO;
                                thirdCard.FaceUp = NO;
                                self.score -= MISMATCH_PENALTY;
                                self.lastFlipResultString = [NSString stringWithFormat:@"Mismatched! -%d!", MISMATCH_PENALTY];
                            }
                            break;
                        }
                    }
                }
            }
            //penality for each flip. Only when flipping it to face up.
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

-(NSMutableArray*)findHint
{
    //loop through all the combination and return the first matched one.
    NSMutableArray *cardsForHint = nil;
    for(int i = 0; i < [self.cards count] - 2; i++)
    {
        for(int j = i + 1; j < [self.cards count] - 1; j++)
        {
            for(int k = j + 1; k < [self.cards count]; k++)
            {
                SetCard *firstCard = self.cards[i];
                SetCard *secondCard = self.cards[j];
                SetCard *thirdCard = self.cards[k];
                //match is found, store it and exit the loops
                if(!firstCard.isUnplayable && !secondCard.isUnplayable && !thirdCard.isUnplayable &&
                   [firstCard match:@[secondCard, thirdCard]])
                {
                    cardsForHint = [[NSMutableArray alloc] initWithObjects:firstCard,secondCard, thirdCard, nil];
                    goto DONE;
                }
            }
        }
    }
    
DONE:
    return cardsForHint;
}

-(BOOL)ifMatchExist
{
    NSMutableArray *match = [[NSMutableArray alloc] init];
    match = [self findHint];
    if(match)
    {
        return YES;
    }
    else
        return NO;
}

-(void)applyMatchExistedPenalty
{
    if([self ifMatchExist])
        [self receivePenalty:ADD_CARDS_WHEN_MATCH_EXISTED_PENALTY];
}

@end
