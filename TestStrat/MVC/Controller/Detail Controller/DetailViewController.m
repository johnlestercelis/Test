//
//  DetailViewController.m
//  TestStrat
//
//  Created by John Lester Celis on 9/10/15.
//  Copyright (c) 2015 John Lester Celis. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView_backdrop;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_cover;
@property (weak, nonatomic) IBOutlet UILabel *label_Title;
@property (weak, nonatomic) IBOutlet UILabel *label_yearReleased;
@property (weak, nonatomic) IBOutlet UITextView *textView_Overview;
@end

@implementation DetailViewController
#pragma mark - Overridden Setter
@synthesize imageSlug;
@synthesize Title;
@synthesize yearReleased;
@synthesize Rating;
@synthesize Overview;
#pragma mark - Overridden Getter

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *URLstringCover = [NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/5624850/movielist/images/%@-cover.jpg",imageSlug];
    NSURL *urlCover = [NSURL URLWithString:[URLstringCover stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *dataCover = [NSData dataWithContentsOfURL:urlCover];
    self.imageView_cover.image = [UIImage imageWithData:dataCover];
    
    NSString *URLstringBackdrop = [NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/5624850/movielist/images/%@-backdrop.jpg",imageSlug];
    NSURL *urlBackdrop = [NSURL URLWithString:[URLstringBackdrop stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *dataBackdrop = [NSData dataWithContentsOfURL:urlBackdrop];
    self.imageView_backdrop.image = [UIImage imageWithData:dataBackdrop];
    
    self.label_Title.text = Title;
    self.label_yearReleased.text = [NSString stringWithFormat:@"%@ | %@",yearReleased,Rating];
    self.textView_Overview.text = Overview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
