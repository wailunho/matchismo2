//
//  PlayingCard.m
//  Matchismo
//
//  Created by William Ho on 8/22/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

+(NSArray*)validSuits
{
    return @[@"♠", @"♣", @"♥", @"♦"];
}

+(NSArray*) rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4",@"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+(NSUInteger)maxRank
{
    return [PlayingCard rankStrings].count -1;
}

-(NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString: self.suit];
}

-(NSString*) suit
{
    return _suit ? _suit : @"?";
}
-(void) setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

-(void) setRank:(NSUInteger)rank
{
    if(rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}


//overriding the method matches in Card.h
-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    //compare the suit and rank between two cards
    //get score if suit or rank matched
    if([otherCards count] == 1)
    {
        id otherCard = [otherCards lastObject];
        if([otherCard isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *otherPlayingCard = (PlayingCard*)otherCard;
            if([otherPlayingCard.suit isEqualToString:self.suit])
            {
                score = 1;
            }
            else if(otherPlayingCard.rank == self.rank)
            {
                score = 4;
            }
        }
    }
    return score;
}
@end
