//
//  MasterViewController.m
//  TestStrat
//
//  Created by John Lester Celis on 9/10/15.
//  Copyright (c) 2015 John Lester Celis. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MainTableViewCell.h"

@interface MasterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *objects;
@property (strong, nonatomic) IBOutlet UITableView *tableView_table;
@property (strong, nonatomic) NSArray *arrayOfJson;
@property (strong, nonatomic) NSMutableArray *arrayMutable;
@property (strong, nonatomic) NSDictionary *dictData;
@end

@implementation MasterViewController
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


- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    /*UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self callParsing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.dictData = [self.arrayMutable objectAtIndex:indexPath.row];
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        
        DetailViewController *destinedViewController = segue.destinationViewController;
        destinedViewController.Title = self.dictData[@"title"];
        destinedViewController.yearReleased = [NSString stringWithFormat:@"%@",self.dictData[@"year"]];
        destinedViewController.Rating = [NSString stringWithFormat:@"%@",self.dictData[@"rating"]];
        destinedViewController.Overview = self.dictData[@"overview"];
        destinedViewController.imageSlug = self.dictData[@"slug"];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfJson.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
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
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:     [NSURL URLWithString:URLstring]]];
        
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

/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}*/

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
