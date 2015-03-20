//
//  KingdomDetailViewController.m
//  MyriadMobileTest
//
//  Created by MaJixian on 3/18/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "KingdomDetailViewController.h"
#import "KingdomDetail.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#define SCROLLVIEWLAYOUT_FLEXIBLEHEIGHT 150
#define Rgb2UIColor(r, g, b, a)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

@interface KingdomDetailViewController()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *detailArray;
@end

@implementation KingdomDetailViewController

# pragma mark Data fetch
// Fetch data from KingdomDetail model
- (void)loadData
{
    //NSLog(@"passedKingdomId:%lu",(unsigned long)self.passedKingdomId);
    [KingdomDetail getKingdomDetailWithBlock:^(NSArray *responseArray, NSError *error) {
        if (!error) {
            self.detailArray = responseArray;
            [self setDataWithRetrievedArray: responseArray];
            [self prepareForQuestBoard];
        }else
        {
            UIAlertView *checkConnectionAlertView = [[UIAlertView alloc]initWithTitle:@"Connection problem" message:@"Something wrong with the connection, please retry later" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
            [checkConnectionAlertView show];
        }
    }ofKingdomId:self.passedKingdomId];

}

// Setup the basic UI content in the view based on fetched data
- (void)setDataWithRetrievedArray:(NSArray *)retrievedArray
{
    self.kingdomDetail = (KingdomDetail *)[self.detailArray objectAtIndex:0];
    [self.kingdomImgView setImageWithURL:self.kingdomDetail.kingdomImgURL placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
   // NSLog(@"detailArray:%@",self.kingdomDetail.questName);
    self.populationLabel.text = [NSString stringWithFormat:@"%@",[@(self.kingdomDetail.kingdomPopulation) stringValue]];
    self.climateLabel.text = [NSString stringWithFormat:@"%@",self.kingdomDetail.kingdomClimate];
}

#pragma mark Load view
- (void)viewDidLoad
{
    [super viewDidLoad];
    pageControlBeingUsed = NO;
    [self prepareForUIElements];
    [self loadData];
}

// Prepare for the basic UI, quest board is not included
- (void)prepareForUIElements
{
    self.populationLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.populationLabel.numberOfLines = 0;
    self.climateLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.climateLabel.numberOfLines = 0;
    CALayer *questGiverImgLayer = self.questGiverImgView.layer;
    [questGiverImgLayer setCornerRadius:self.questGiverImgView.frame.size.width/2];
    [questGiverImgLayer setMasksToBounds:YES];
    [self setTitle:self.kingdomDetailViewTitle];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

# pragma mark Questboard setup
// Prepare for the quest board. I used UIScrollView+PageControl to display several quests in one board
// I allowed the ScrollView to enable both horizontally scroll and vertically scroll. Horizontally scroll is for switching between quests. Vertically scroll is for: a. Fit different screen sizes, so that all of the quests info can be presented completely no matter on iPhone 4S or iPhone 6 Plus. b. Leave some room to add more features on quest board.
- (void)prepareForQuestBoard
{
    CGSize scrollViewSize = CGSizeMake(self.questScrollView.frame.size.width * [self.kingdomDetail.questName count], self.questScrollView.frame.size.height+SCROLLVIEWLAYOUT_FLEXIBLEHEIGHT);
    [self.questScrollView setContentSize:scrollViewSize];
    self.questScrollView.delegate = self;

    self.questPageControl.numberOfPages = [self.kingdomDetail.questName count];
    self.questPageControl.currentPage = 0;


    for (NSUInteger i = 1; i <= [self.kingdomDetail.questName count]; i++)
    {
        
        UILabel *questNameLabelScroll = [[UILabel alloc]initWithFrame:CGRectMake(self.questNameLabel.frame.origin.x+(i-1)*self.questScrollView.frame.size.width, self.questNameLabel.frame.origin.y, self.questNameLabel.frame.size.width, self.questNameLabel.frame.size.height)];
        questNameLabelScroll.text = [self.kingdomDetail.questName objectAtIndex:i-1];
        questNameLabelScroll.font = self.questNameLabel.font;
        questNameLabelScroll.textAlignment = self.questNameLabel.textAlignment;
        [self.questScrollView addSubview:questNameLabelScroll];
        
        
#warning no description data from database, change the value when data is set. No quest imge in database.
        UILabel *questDescLabelScroll = [[UILabel alloc]initWithFrame:CGRectMake(self.questDescLabel.frame.origin.x+(i-1)*self.questScrollView.frame.size.width, self.questDescLabel.frame.origin.y, self.questDescLabel.frame.size.width, self.questDescLabel.frame.size.height)];
        questDescLabelScroll.text = @"Quest Description:..........................................................................";
        questDescLabelScroll.font = self.questDescLabel.font;
        questDescLabelScroll.textAlignment = self.questDescLabel.textAlignment;
        [self.questScrollView addSubview:questDescLabelScroll];
        
        
        UILabel *questGiverLabelScroll = [[UILabel alloc]initWithFrame:CGRectMake(self.questGiverNameLabel.frame.origin.x+(i-1)*self.questScrollView.frame.size.width, self.questGiverNameLabel.frame.origin.y, self.questGiverNameLabel.frame.size.width, self.questGiverNameLabel.frame.size.height)];
        questGiverLabelScroll.text = [self.kingdomDetail.questGiverName objectAtIndex:i-1];
        questGiverLabelScroll.font = self.questGiverNameLabel.font;
        questGiverLabelScroll.textAlignment = self.questGiverNameLabel.textAlignment;
        [self.questScrollView addSubview:questGiverLabelScroll];
        
        
        UIImageView *questGiverImgViewScroll = [[UIImageView alloc]initWithFrame:CGRectMake(self.questGiverImgView.frame.origin.x+(i-1)*self.questScrollView.frame.size.width, self.questGiverImgView.frame.origin.y, self.questGiverImgView.frame.size.width, self.questGiverImgView.frame.size.height)];
        CALayer *questGiverImgLayer = questGiverImgViewScroll.layer;
        [questGiverImgLayer setCornerRadius:questGiverImgViewScroll.frame.size.width/2];
        [questGiverImgLayer setMasksToBounds:YES];
        [questGiverImgViewScroll setImageWithURL:[self.kingdomDetail.questGiverImgURLArray objectAtIndex:i-1] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self.questScrollView addSubview:questGiverImgViewScroll];
    }
}

// ScrollView delegation method implementation
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.questPageControl.currentPage = page;
    if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 ){
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
}
}

@end
