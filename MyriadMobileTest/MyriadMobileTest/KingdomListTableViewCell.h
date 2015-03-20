//
//  KingdomListTableViewCell.h
//  MyriadMobileTest
//
//  Created by MaJixian on 3/17/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KingdomInfo;

@interface KingdomListTableViewCell : UITableViewCell

@property (nonatomic,strong) KingdomInfo *kingdomInfo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
