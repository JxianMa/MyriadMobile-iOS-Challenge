//
//  KingdomDetailViewController.h
//  MyriadMobileTest
//
//  Created by MaJixian on 3/18/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KingdomDetail.h"

@interface KingdomDetailViewController : UIViewController
{
    BOOL pageControlBeingUsed;
}

@property (strong,nonatomic) KingdomDetail *kingdomDetail;
@property (nonatomic,assign) NSUInteger passedKingdomId;
@property (nonatomic,strong) NSString *kingdomDetailViewTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *questScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *questGiverImgView;
@property (weak, nonatomic) IBOutlet UIImageView *kingdomImgView;
@property (weak, nonatomic) IBOutlet UILabel *populationLabel;
@property (weak, nonatomic) IBOutlet UILabel *climateLabel;

@property (strong, nonatomic) IBOutlet UILabel *questNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *questGiverNameLabel;

@property (strong, nonatomic) IBOutlet UIPageControl *questPageControl;


@end
