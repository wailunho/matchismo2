//
//  CardGame.m
//  Matchismo
//
//  Created by William Ho on 8/30/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "CardGame.h"

@implementation CardGame

-(Deck *)deck
{
    if(!_deck)_deck = [[Deck alloc] init];
    return _deck;
}

-(NSMutableArray*)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(void)flipCardAtIndex:(NSUInteger) index
{
   //abstract
}

-(id)cardAtIndex:(NSUInteger)index
{
    //return the card in index.
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(void)removeCardAtIndex:(NSUInteger)index
{
    [self.cards removeObjectAtIndex:index];
}

-(void)removeCard:(Card*)card
{
    for(int i = 0; i < [self.cards count]; i++)
    {
        if([[self.cards[i] contents] isEqualToString:card.contents])
            [self removeCardAtIndex:i];
    }
}

-(void)addCard
{
    Card* card = [self.deck drawRandomCard];
    if(card)
        [self.cards addObject:card];
}

-(id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck*) deck
{
    self = [super init];
    if(self)
    {
        self.deck = deck;
        for(int i = 0; i < count; i++)
        {
            Card *card = [self.deck drawRandomCard];
            if(card)
                self.cards[i] = card;
            else
            {
                self = nil;
                break;
            }
        }
    }
    return self;
}

-(void)receivePenalty:(int)points
{
    self.score -= points;
}

@end
