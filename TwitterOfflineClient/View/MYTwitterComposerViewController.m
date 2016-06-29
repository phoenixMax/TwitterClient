//
//  MYTwitterComposerViewController.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/28/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import "MYTwitterComposerViewController.h"

@interface MYTwitterComposerViewController()

@property (strong, nonatomic) MYTwitterShareViewModel *viewModel;

@end

@implementation MYTwitterComposerViewController

- (instancetype)initWithViewModel:(MYTwitterShareViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    RAC(self.viewModel, contentText) = self.textView.rac_textSignal;
}

- (void)didSelectCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPost {
    [[self.viewModel postTweetSignal] subscribeNext:^(id x) {
        [[self.viewModel updateFeedSignal] doCompleted:^{
            
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
