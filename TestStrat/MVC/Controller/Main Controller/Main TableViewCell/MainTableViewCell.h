//
//  MainTableViewCell.h
//  TestStrat
//
//  Created by John Lester Celis on 9/11/15.
//  Copyright (c) 2015 John Lester Celis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_imageView;
@property (weak, nonatomic) IBOutlet UILabel *label_yearReleased;

@property (weak, nonatomic) IBOutlet UILabel *label_Title;

@end
