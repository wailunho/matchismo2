//
//  PlayingCardView.h
//  Matchismo2
//
//  Created by William Ho on 8/31/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

@end
