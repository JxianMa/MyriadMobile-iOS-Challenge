//
//  KingdomInfo.h
//  MyriadMobileTest
//
//  Created by MaJixian on 3/17/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KingdomInfo : NSObject

@property (nonatomic, assign)NSUInteger kingdomId;
@property (nonatomic, strong)NSString   *kingdomName;
@property (nonatomic, unsafe_unretained)NSURL *kingdomImageURL;


+ (void)getKingdomInfoWithBlock: (void (^)(NSArray *responseArray, NSError *error))block;

@end
