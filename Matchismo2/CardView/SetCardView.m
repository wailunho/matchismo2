//
//  SetCardView.m
//  Matchismo2
//
//  Created by William Ho on 9/5/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Initialization

- (void)setup
{
    // do initialization here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

#pragma mark - Setters

-(void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

-(void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

-(void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

-(void)setNumOfSymbol:(int)numOfSymbol
{
    _numOfSymbol = numOfSymbol;
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - Helpers

#pragma mark - Drawing

#define CORNER_RADIUS 12.0

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    if(!self.selected)
        [[UIColor whiteColor] setFill];
    else
        [[UIColor orangeColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawSymbols];
}

-(void)drawSymbols
{
    
}

@end
