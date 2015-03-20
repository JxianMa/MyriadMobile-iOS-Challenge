//
//  KingdomInfo.m
//  MyriadMobileTest
//
//  Created by MaJixian on 3/17/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "KingdomInfo.h"
#import "AFNetworking.h"

static NSString *const KINGDOMINFOURL = @"https://challenge2015.myriadapps.com/api/v1/kingdoms";

@interface KingdomInfo ()
@property (readwrite, nonatomic, copy) NSString *imageURLString;
@end

@implementation KingdomInfo

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    self.kingdomId = (NSInteger)[[attributes valueForKey:@"id"] integerValue];
    self.kingdomName = [attributes valueForKey:@"name"];
    self.imageURLString = [attributes valueForKey:@"image"];
    return self;
}

// Convert fetched URL stirng in JSON to NSURL
- (NSURL *)kingdomImageURL {
    return [NSURL URLWithString:self.imageURLString];
}

+ (void)getKingdomInfoWithBlock:(void (^)(NSArray *responseArray, NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:KINGDOMINFOURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray *responseMutableArray = [[NSMutableArray alloc] init];
        for (NSDictionary *attributes in responseObject)
        {
            KingdomInfo *kingdomInfo = [[KingdomInfo alloc] initWithAttributes:attributes];
            //NSLog(@"kingdomInfo:%@",attributes);
            [responseMutableArray addObject:kingdomInfo];
            //NSLog(@"responseMutableArray:%@",kingdomInfo);
        }
        if (block) {
            block([NSArray arrayWithArray:responseMutableArray],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        if (block)
        {
            block([NSArray array], error);
        }
    }];
}

@end
