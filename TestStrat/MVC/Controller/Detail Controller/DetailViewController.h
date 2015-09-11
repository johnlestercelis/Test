//
//  DetailViewController.h
//  TestStrat
//
//  Created by John Lester Celis on 9/10/15.
//  Copyright (c) 2015 John Lester Celis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *yearReleased;
@property (strong, nonatomic) NSString *Rating;
@property (strong, nonatomic) NSString *Overview;
@property (strong, nonatomic) NSString *imageSlug;
@end

