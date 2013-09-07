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
#define MATCH_BONUS 8
#define MISMATCH_PENALTY 4
#define FLIP_COST 1

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

@end
