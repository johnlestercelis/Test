//
//  DetailiPadViewController.m
//  TestStrat
//
//  Created by John Lester Celis on 9/11/15.
//  Copyright (c) 2015 John Lester Celis. All rights reserved.
//

#import "DetailiPadViewController.h"

@interface DetailiPadViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *img_backdrop;
@property (weak, nonatomic) IBOutlet UIImageView *img_cover;
@property (weak, nonatomic) IBOutlet UILabel *label_Title;
@property (weak, nonatomic) IBOutlet UILabel *label_yearReleased;
@property (weak, nonatomic) IBOutlet UITextView *textView_Overview;
@end

@implementation DetailiPadViewController
@synthesize detailItem = _detailItem;
#pragma mark - Overridden Setter

- (void)setDetailItem:(NSDictionary *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self setMovies:_detailItem];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshWithDictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Overridden setters
- (void)setMovies:(NSDictionary *)movies
{
    [self refreshWithDictionary];
}

#pragma mark - New Methods
-(void)refreshWithDictionary
{
 
    if (self.detailItem) {
        NSString *URLstringCover = [NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/5624850/movielist/images/%@-cover.jpg",self.detailItem[@"slug"]];
        NSURL *urlCover = [NSURL URLWithString:[URLstringCover stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *dataCover = [NSData dataWithContentsOfURL:urlCover];
        self.img_cover.image = [UIImage imageWithData:dataCover];
        
        NSString *URLstringBackdrop = [NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/5624850/movielist/images/%@-backdrop.jpg",self.detailItem[@"slug"]];
        NSURL *urlBackdrop = [NSURL URLWithString:[URLstringBackdrop stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *dataBackdrop = [NSData dataWithContentsOfURL:urlBackdrop];
        self.img_backdrop.image = [UIImage imageWithData:dataBackdrop];
        
        self.label_Title.text = self.detailItem[@"title"];
        self.label_yearReleased.text = [NSString stringWithFormat:@"%@ | %@",self.detailItem[@"year"],self.detailItem[@"year"]];
        self.textView_Overview.text = self.detailItem[@"overview"];

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
