//
//  KingdomDetail.m
//  MyriadMobileTest
//
//  Created by MaJixian on 3/18/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "KingdomDetail.h"
#import "AFNetworking.h"

static NSString *baseURL = @"https://challenge2015.myriadapps.com/api/v1/kingdoms/";
@interface KingdomDetail()
@property (readwrite, nonatomic, copy) NSString *kingdomImgURLString;
@property (readwrite, nonatomic, copy) NSString *questImgURLString;
@property (readwrite, nonatomic, copy) NSArray *questGiverImgURLStringArray;

@end

@implementation KingdomDetail

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    self.kingdomName = [attributes valueForKey:@"name"];
    self.kingdomId = (NSInteger)[[attributes valueForKey:@"id"] integerValue];
    self.kingdomClimate = [attributes valueForKey:@"climate"];
    self.kingdomPopulation = (NSInteger)[[attributes valueForKey:@"population"] integerValue];
    self.kingdomImgURLString = [attributes valueForKey:@"image"];
    NSDictionary *questDict = [attributes valueForKey:@"quests"];
    self.questId = (NSInteger)[questDict valueForKey:@"id"];
    self.questName = [questDict valueForKey:@"name"];
    self.questImgURLString = [questDict valueForKey:@"image"];
    NSDictionary *questGiverDict = [questDict valueForKey:@"giver"];
    self.questGiverId = (NSInteger)[questGiverDict valueForKey:@"id"];
    self.questGiverName = [questGiverDict valueForKey:@"name"];
    self.questGiverImgURLStringArray = [questGiverDict valueForKey:@"image"];
    self.questGiverImgURLArray = [[NSMutableArray alloc]init];
    for(NSString *questGiverImgURLString in self.questGiverImgURLStringArray)
    {
        NSURL *questGiverImgURL = [NSURL URLWithString:questGiverImgURLString];
        [self.questGiverImgURLArray addObject:questGiverImgURL];
    }
    return self;
}

// Convert fetched URL stirng in JSON to NSURL
- (NSURL *)kingdomImgURL {
    return [NSURL URLWithString:self.kingdomImgURLString];
}

- (NSURL *)questImgURL {
    return [NSURL URLWithString:self.questImgURLString];
}

+ (void)getKingdomDetailWithBlock: (void (^)(NSArray *responseArray, NSError *error))block ofKingdomId:(NSUInteger)kingdomId
{
    NSString *htmlString = [NSString stringWithFormat:@"%@%ld",baseURL,kingdomId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:htmlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *responseMutableArray = [[NSMutableArray alloc] init];
            KingdomDetail *kingdomDetail = [[KingdomDetail alloc] initWithAttributes:responseObject];
            //NSLog(@"kingdomInfo:%@",responseObject);
            [responseMutableArray addObject:kingdomDetail];
            //NSLog(@"responseMutableArray:%@",kingdomInfo);
        if (block) {
            block([NSArray arrayWithArray:responseMutableArray],nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
    }





@end
