//
//  MainiPadController.m
//  TestStrat
//
//  Created by John Lester Celis on 9/11/15.
//  Copyright (c) 2015 John Lester Celis. All rights reserved.
//

#import "MainiPadController.h"
#import "MainTableViewCell.h"
#import "DetailiPadViewController.h"

@interface MainiPadController ()
@property (strong, nonatomic) NSArray *arrayOfJson;
@property (strong, nonatomic) NSMutableArray *arrayMutable;
@property (strong, nonatomic) NSDictionary *dictData;
@property (strong, nonatomic) DetailiPadViewController *detailViewController;
@end

@implementation MainiPadController
#pragma mark - Overridden Setter
@synthesize arrayOfJson = _arrayOfJson;
@synthesize arrayMutable = _arrayMutable;
@synthesize dictData = _dictData;

#pragma mark - Overridden Getter
- (NSDictionary *)dictData{
    if (!_dictData) {
        _dictData = [[NSDictionary alloc] init];
    }
    return _dictData;
}

- (NSMutableArray *)arrayMutable{
    if (!_arrayMutable) {
        _arrayMutable = @[].mutableCopy;
    }
    return _arrayMutable;
}

- (NSArray *)arrayOfJson {
    if (!_arrayOfJson) {
        _arrayOfJson = @[];
    }
    return _arrayOfJson;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self callParsing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrayOfJson.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    NSArray *arrSubviews = [cell.contentView subviews];
     for (UIView *view in arrSubviews) {
     [view removeFromSuperview];
     }
    
    if (cell == nil)
    {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:MyIdentifier];
    }
    
    self.dictData = [self.arrayMutable objectAtIndex:indexPath.row];
    
    cell.label_Title.text = self.dictData[@"title"];
    cell.label_yearReleased.text = [NSString stringWithFormat:@"%@",self.dictData[@"year"]];
    
    cell.img_imageView.image = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // retrive image on global queue
        NSString *URLstring = [NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/5624850/movielist/images/%@-backdrop.jpg",self.dictData[@"slug"]];
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:URLstring]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            MainTableViewCell * cell = (MainTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            // assign cell image on main thread
            cell.img_imageView.image = img;
        });
    });
    
    [cell.contentView addSubview:cell.img_imageView];
    [cell.contentView addSubview:cell.label_Title];
    [cell.contentView addSubview:cell.label_yearReleased];
    
    return cell;

}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetails" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.dictData = [self.arrayMutable objectAtIndex:indexPath.row];
        DetailiPadViewController *controller = (DetailiPadViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:self.dictData];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }

}


#pragma mark - Parsing
- (void)callParsing
{
    NSString *strJson = @"https://dl.dropboxusercontent.com/u/5624850/movielist/list_movies_page1.json";
    
    NSData *allCoursesData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strJson]];
    NSError *error;
    NSMutableDictionary *allCourses = [NSJSONSerialization
                                       JSONObjectWithData:allCoursesData
                                       options:NSJSONReadingMutableContainers
                                       error:&error];
    
    NSString *arrayData = [allCourses valueForKey:@"data"];
    self.arrayOfJson = [arrayData valueForKey:@"movies"];
    
    [self gettingValueWith:self.arrayOfJson];
}

- (void)gettingValueWith: (NSArray *)array {
    
    for (NSDictionary *dict in array) {
        [self.arrayMutable addObject:dict];
    }
    
}

@end
