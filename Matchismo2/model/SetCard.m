//
//  SetCard.m
//  Matchismo
//
//  Created by William Ho on 8/26/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetCard.h"

#define SetTypeSymbol 1
#define SetTypeNumOfSymbol 2
#define SetTypeColor 3
#define SetTypeShading 4
#define SetTypeDifferentSymbol 5
#define SetTypeDifferentNumOfSymbol 6
#define SetTypeDifferentColor 7
#define SetTypeDifferentShading 8

#define MaxNumberOfSymbol 3

@implementation SetCard

@synthesize symbol = _symbol, color = _color, shading = _shading;

#pragma mark - Getters

-(NSString*) symbol
{
    return _symbol ? _symbol : @"?";
}

-(NSString *)color
{
    return _color ? _color : @"?";
}

-(NSString *)shading
{
    return _shading ? _shading : @"?";
}

#pragma mark - Setters

-(void) setSymbol:(NSString *)symbol
{
    if([[SetCard validSymbols] containsObject:symbol])
    {
        _symbol = symbol;
    }
}

-(void) setColor:(NSString *)color
{
    if([[SetCard validColors] containsObject:color])
    {
        _color = color;
    }
}

-(void) setShading:(NSString *)shading
{
    if([[SetCard validShadings] containsObject:shading])
    {
        _shading = shading;
    }
}

#pragma mark - Helpers

+(NSArray*)validSymbols
{
    return @[@"diamond", @"squiggle", @"oval"];
}

+(int)maxNumOfSymbol
{
    return MaxNumberOfSymbol;
}

+(NSArray*)validColors
{
    return @[@"red", @"green", @"purple"];
}

+(NSArray*)validShadings
{
    return @[@"solid", @"striped", @"open"];
}

-(NSString *)contents
{
    return [NSString stringWithFormat:@"%d %@ %@ %@", self.numOfSymbol, self.symbol, self.color, self.shading];
}

#pragma mark - Main Functions

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    //Among all four: symbol, number of symbol, color and shading. Each of them is either all matched
    //or none matched.
    if(([self matchASet:SetTypeSymbol withCards:otherCards] || [self matchASet:SetTypeDifferentSymbol withCards:otherCards]) &&
       ([self matchASet:SetTypeNumOfSymbol withCards:otherCards] || [self matchASet:SetTypeDifferentNumOfSymbol withCards:otherCards]) &&
       ([self matchASet:SetTypeColor withCards:otherCards] || [self matchASet:SetTypeDifferentColor withCards:otherCards]) &&
       ([self matchASet:SetTypeShading withCards:otherCards] || [self matchASet:SetTypeDifferentShading withCards:otherCards]))
        score = 1;
    
    return score;
}

-(BOOL)matchASet:(int)type withCards:(NSArray*)otherCards
{
    BOOL isMatch = NO;
    
    if([otherCards count] == 2)
    {
        id secondCard = [otherCards objectAtIndex:0];
        id thirdCard = [otherCards lastObject];
        if([secondCard isKindOfClass:[SetCard class]] && [thirdCard isKindOfClass:[SetCard class]])
        {
            SetCard *secondSetCard = (SetCard*)secondCard;
            SetCard *thirdSetCard = (SetCard*) thirdCard;
            switch (type) {
                case SetTypeSymbol:
                    //Three cards have the same symbol.
                    if([secondSetCard.symbol isEqualToString:self.symbol] && [thirdSetCard.symbol isEqualToString:self.symbol])
                        isMatch = YES;
                    break;
                    
                case SetTypeNumOfSymbol:
                    //Three cards have the same number of symbol.
                    if(secondSetCard.numOfSymbol == self.numOfSymbol && thirdSetCard.numOfSymbol == self.numOfSymbol)
                        isMatch = YES;
                    break;
                    
                case SetTypeColor:
                    //Three cards have the same color.
                    if([secondSetCard.color isEqualToString:self.color] && [thirdSetCard.color isEqualToString:self.color])
                        isMatch = YES;
                    break;
                    
                case SetTypeShading:
                    //Three cards have the same shading.
                    if([secondSetCard.shading isEqualToString: self.shading] && [thirdSetCard.shading isEqualToString: self.shading])
                        isMatch = YES;
                    break;
                    
                case SetTypeDifferentSymbol:
                    //Three cards have different symbol.
                    if(![secondSetCard.symbol isEqualToString:self.symbol] && ![thirdSetCard.symbol isEqualToString:self.symbol] && ![secondSetCard.symbol isEqualToString:thirdSetCard.symbol])
                        isMatch = YES;
                    break;
                    
                case SetTypeDifferentNumOfSymbol:
                    //Three cards have different number of symbol.
                    if(secondSetCard.numOfSymbol != self.numOfSymbol && thirdSetCard.numOfSymbol != self.numOfSymbol && secondSetCard.numOfSymbol != thirdSetCard.numOfSymbol)
                        isMatch = YES;
                    break;
                    
                case SetTypeDifferentColor:
                    //Three cards have different colors.
                    if(![secondSetCard.color isEqualToString:self.color] && ![thirdSetCard.color isEqualToString:self.color] && ![secondSetCard.color isEqualToString:thirdSetCard.color])
                        isMatch = YES;
                    break;
                    
                case SetTypeDifferentShading:
                    //Three cards have different shadings.
                    if(![secondSetCard.shading isEqualToString: self.shading] && ![thirdSetCard.shading isEqualToString: self.shading] && ![secondSetCard.shading isEqualToString: thirdSetCard.shading])
                        isMatch = YES;
                    break;
                    
                default:
                    break;
            }        
        }
    }
    return isMatch;
}

@end
