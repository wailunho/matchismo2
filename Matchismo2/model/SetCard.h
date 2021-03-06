//
//  SetCard.h
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property(strong, nonatomic) NSString *symbol;
@property(nonatomic) int numOfSymbol;
@property(strong, nonatomic) NSString *color;
@property(strong, nonatomic) NSString *shading;

+(NSArray*)validSymbols;
+(NSArray*)validColors;
+(NSArray*)validShadings;
+(int)maxNumOfSymbol;

@end
