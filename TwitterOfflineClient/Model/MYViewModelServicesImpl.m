//
//  MYViewModelServicesImpl.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import "MYViewModelServicesImpl.h"
#import "MYTwitterClientImpl.h"
#import "MYTwitterFeedViewController.h"
#import "AppDelegate.h"

@interface MYViewModelServicesImpl()

@property (strong, nonatomic) MYTwitterClientImpl *twitterClient;
@property (weak, nonatomic) UINavigationController *navigationController;

@end

@implementation MYViewModelServicesImpl

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        _twitterClient = [[MYTwitterClientImpl alloc] init];
        _navigationController = navigationController;
    }
    return self;
}

- (id<MYTwitterClient>)twitterService {
    return self.twitterClient;
}

- (void)pushViewModel:(id)viewModel {
    id viewController;
    
    if ([viewModel isKindOfClass:[MYTwitterFeedViewModel class]]) {
        viewController = [[MYTwitterFeedViewController alloc] initWithViewModel:viewModel];
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
