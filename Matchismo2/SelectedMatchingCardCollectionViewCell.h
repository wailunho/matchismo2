//
//  SelectedMatchingCardCollectionViewCell.h
//  Matchismo2
//
//  Created by William Ho on 9/2/13.
//  Copyright (c) 2013 William Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchingCardView.h"

@interface SelectedMatchingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet MatchingCardView *selectedMatchingCardView;
@end
