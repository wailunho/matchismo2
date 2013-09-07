//
//  PlayingCardCollectionViewCell.h
//  Matchismo2
//
//  Created by William Ho on 8/31/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchingCardView.h"

@interface MatchingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet MatchingCardView *matchingCardView;

@end
