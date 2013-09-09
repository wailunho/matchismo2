//
//  SetCardView.h
//  Matchismo2
//
//  Created by William Ho on 9/5/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property(strong, nonatomic) NSString *symbol;
@property(nonatomic) int numOfSymbol;
@property(strong, nonatomic) NSString *color;
@property(strong, nonatomic) NSString *shading;
@property(nonatomic) BOOL hintOn;
@property(nonatomic) BOOL selected;

@end
