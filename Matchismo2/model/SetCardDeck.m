//
//  SetCardDeck.m
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

//initialize with 81 cards (a set deck)
-(id)init
{
    self = [super init];
    if(self)
    {
        for(NSString *symbol in [SetCard validSymbols]){
            for(int i = 1; i <= [SetCard maxNumOfSymbol]; i++){
                for(NSString *color in [SetCard validColors]){
                    for(NSString *shading in [SetCard validShadings]){
                        SetCard * card  = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.color = color;
                        card.shading = shading;
                        card.numOfSymbol = i;
                        [self addCards:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
