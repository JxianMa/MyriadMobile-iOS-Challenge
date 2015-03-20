//
//  KingdomDetail.h
//  MyriadMobileTest
//
//  Created by MaJixian on 3/18/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface KingdomDetail : NSObject


@property (nonatomic, assign) NSUInteger kingdomId;
@property (nonatomic, strong) NSString *kingdomName;
@property (nonatomic, unsafe_unretained)NSURL *kingdomImgURL;
@property (nonatomic, strong) NSString *kingdomClimate;
@property (nonatomic, assign) NSUInteger kingdomPopulation;

@property (nonatomic, assign) NSUInteger questId;
@property (nonatomic, strong) NSArray *questName;
@property (nonatomic, strong) NSArray *questDesc;
@property (nonatomic, unsafe_unretained)NSURL *questImgURL;

@property (nonatomic, assign) NSUInteger questGiverId;
@property (nonatomic, strong) NSArray *questGiverName;
//@property (nonatomic, unsafe_unretained)NSURL *questGiverImgURL;
@property (nonatomic, strong) NSMutableArray *questGiverImgURLArray;

+ (void)getKingdomDetailWithBlock: (void (^)(NSArray *responseArray, NSError *error))block ofKingdomId:(NSUInteger)kingdomId;

@end
