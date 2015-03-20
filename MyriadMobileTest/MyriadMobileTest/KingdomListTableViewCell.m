//
//  KingdomListTableViewCell.m
//  MyriadMobileTest
//
//  Created by MaJixian on 3/17/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "KingdomListTableViewCell.h"
#import "KingdomInfo.h"
#import "UIImageView+AFNetworking.h"

#define Rgb2UIColor(r, g, b, a)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
@implementation KingdomListTableViewCell


- (void)setKingdomInfo:(KingdomInfo *)kingdomInfo
{
    _kingdomInfo = kingdomInfo;
    self.textLabel.text = _kingdomInfo.kingdomName;
    self.detailTextLabel.text = [@(_kingdomInfo.kingdomId) stringValue];
    [self.imageView setImageWithURL: _kingdomInfo.kingdomImageURL placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self setNeedsLayout];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = Rgb2UIColor(26,179,189,1.0f);
    self.detailTextLabel.textColor = Rgb2UIColor(255, 255, 255,0.0f);
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 60.0f, 60.0f);
    self.textLabel.frame = CGRectMake(100.0f, 25.0f, 240.0f, 20.0f);
}



@end
