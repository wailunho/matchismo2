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
-(void)setHintOn:(BOOL)hintOn
{
    _hintOn = hintOn;
    [self setNeedsDisplay];
}

#pragma mark - Helpers

-(UIColor*)getColor
{
    NSDictionary *colorDictionary = @{@"red": [UIColor redColor], @"green": [UIColor greenColor], @"purple": [UIColor purpleColor]};
    return colorDictionary[self.color];
}

-(void)pushContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
}

-(void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Drawing

#define CORNER_RADIUS 12.0
#define HINT_LINE_WIDTH 10

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
    
    if(self.hintOn)
    {
        roundedRect.lineWidth *= HINT_LINE_WIDTH;
        [[UIColor yellowColor] setStroke];
    }
    
    [roundedRect stroke];
    
    [self drawSymbols];
}

#define HOFFSET_FACTOR 0.5

-(void)drawSymbols
{
    [[self getColor] setStroke];
    
    CGFloat offset = self.bounds.size.width / 2 * HOFFSET_FACTOR;
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height /2);
    
    if(self.numOfSymbol == 1)
        [self drawSymbolAtPoint:center];
    else if(self.numOfSymbol == 2)
    {
        [self drawSymbolAtPoint:CGPointMake(center.x - offset / 2, center.y)];
        [self drawSymbolAtPoint:CGPointMake(center.x + offset / 2, center.y)];
    }
    else if(self.numOfSymbol == 3)
    {
        [self drawSymbolAtPoint:CGPointMake(center.x, center.y)];
        [self drawSymbolAtPoint:CGPointMake(center.x - offset, center.y)];
        [self drawSymbolAtPoint:CGPointMake(center.x + offset, center.y)];
    }
}

-(void)drawSymbolAtPoint:(CGPoint)point
{
    if([self.symbol isEqualToString:@"diamond"])
        [self drawDiamondAtPoint:point];
    else if([self.symbol isEqualToString:@"squiggle"])
        [self drawSquiggleAtPoint:point];
    else if([self.symbol isEqualToString:@"oval"])
        [self drawOvalAtPoint:point];
}

#define SYMBOL_WIDTH_FACTOR 0.18
#define SYMBOL_HEIGHT_FACTOR 0.55
#define SYMBOL_LINE_WIDTH 0.02
#define STRIPSOFFSET_FACTOR 0.1

-(void)applyShadingInPath:(UIBezierPath*)path
{
    if([self.shading isEqualToString: @"solid"])
    {
        [[self getColor] setFill];
        [path fill];
    }
    else if([self.shading isEqualToString: @"striped"])
    {
        [path addClip];
        for(CGFloat y = 0; y <= self.bounds.size.height; y += self.bounds.size.height * STRIPSOFFSET_FACTOR)
        {
            [path moveToPoint:CGPointMake(0, y)];
            [path addLineToPoint:CGPointMake(self.bounds.size.width, y)];
        }
    }
}

-(void)drawOvalAtPoint:(CGPoint)point
{
    CGFloat width = self.bounds.size.width * SYMBOL_WIDTH_FACTOR;
    CGFloat height = self.bounds.size.height * SYMBOL_HEIGHT_FACTOR;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - (width/2), point.y - (height/2), width, height)
                                                    cornerRadius:width/2];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self pushContext];
    [self applyShadingInPath:path];
    [path stroke];
    [self popContext];
}

-(void)drawDiamondAtPoint:(CGPoint)point
{
    CGFloat width = self.bounds.size.width * SYMBOL_WIDTH_FACTOR;
    CGFloat height = self.bounds.size.height * SYMBOL_HEIGHT_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(point.x, point.y + height/2)];
    [path addLineToPoint:CGPointMake(point.x + width/2, point.y)];
    [path addLineToPoint:CGPointMake(point.x , point.y - height/2)];
    [path addLineToPoint:CGPointMake(point.x - width/2, point.y)];
    [path closePath];
    
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self pushContext];
    [self applyShadingInPath:path];
    [path stroke];
    [self popContext];
}

#define SQUIGGLE_CURVE_FACTOR 0.8

-(void)drawSquiggleAtPoint:(CGPoint)point
{
    CGFloat width = self.bounds.size.width * SYMBOL_WIDTH_FACTOR;
    CGFloat height = self.bounds.size.height * SYMBOL_HEIGHT_FACTOR;
    CGFloat curveOffset = width * SQUIGGLE_CURVE_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(point.x + width/2, point.y - height/2)];
    [path addCurveToPoint:CGPointMake(point.x + width/2, point.y + height/2)
            controlPoint1:CGPointMake(point.x + width/2 + curveOffset, point.y + height/12)
            controlPoint2:CGPointMake(point.x + width/2 - curveOffset, point.y - height/12)];
    
    [path addQuadCurveToPoint:CGPointMake(point.x - width/2, point.y + height/2)
                 controlPoint:CGPointMake(point.x , point.y + height/2 + curveOffset)];
     
    [path addCurveToPoint:CGPointMake(point.x - width/2, point.y - height/2)
            controlPoint1:CGPointMake(point.x - width/2 - curveOffset, point.y - height/12)
            controlPoint2:CGPointMake(point.x - width/2 + curveOffset, point.y + height/12)];
    [path addQuadCurveToPoint:CGPointMake(point.x + width/2, point.y - height/2)
                 controlPoint:CGPointMake(point.x , point.y - height/2 - curveOffset)];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self pushContext];
    [self applyShadingInPath:path];
    [path stroke];
    [self popContext];
}


@end
