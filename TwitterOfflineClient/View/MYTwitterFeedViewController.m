//
//  ViewController.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import "MYTwitterFeedViewController.h"
#import "MYTwitterComposerViewController.h"
#import "MYTwitterShareViewModel.h"
#import "MYViewModelServicesImpl.h"

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
    UIBarButtonItem *composeBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                          target:self
                                                                                          action:@selector(composeTweet)];
    self.navigationItem.rightBarButtonItem = composeBarButtonItem;
    
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

#pragma mark - Helpers

- (void)composeTweet {
    MYViewModelServicesImpl *viewModelServices = [[MYViewModelServicesImpl alloc] initWithNavigationController:self.navigationController];
    MYTwitterShareViewModel *viewModel = [[MYTwitterShareViewModel alloc] initWithServices:viewModelServices];
    MYTwitterComposerViewController *composeVC = [[MYTwitterComposerViewController alloc] initWithViewModel:viewModel];
    composeVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //composeVC.placeholder = @"What's happening?";
    [self.navigationController presentViewController:composeVC animated:YES completion:nil];
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
