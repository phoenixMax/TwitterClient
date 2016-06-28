//
//  ViewController.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import "MYTwitterFeedViewController.h"

@interface MYTwitterFeedViewController ()

@property (strong, nonatomic) MYTwitterFeedViewModel *viewModel;

@end

@implementation MYTwitterFeedViewController

- (instancetype)initWithViewModel:(MYTwitterFeedViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.rac_command = self.viewModel.refreshCommand;
    
    @weakify(self);
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel.userSignal subscribeNext:^(NSDictionary *userInfo) {
        self.title = [NSString stringWithFormat:@"@%@", userInfo[@"screen_name"]];
    }];
    
    self.viewModel.active = YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - TODO: Show more info about tweet

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //cell.textLabel.text = [self.viewModel userNameAtIndexPath:indexPath];
    cell.textLabel.text = [self.viewModel textAtIndexPath:indexPath];
}

@end
