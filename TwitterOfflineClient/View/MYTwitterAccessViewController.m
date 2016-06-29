//
//  MYTwitterAccessViewController.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import "MYTwitterAccessViewController.h"

@interface MYTwitterAccessViewController()

@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

@property (weak, nonatomic) MYTwitterAccessViewModel *viewModel;

@end

@implementation MYTwitterAccessViewController

- (instancetype)initWithModel:(MYTwitterAccessViewModel *)viewModel {
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    
    return self;
}

- (void)setupViewModel:(MYTwitterAccessViewModel *)viewModel {
    self.viewModel = viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [self performTwitterButtonAnimation];
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(performTwitterButtonAnimation)
                                   userInfo:nil
                                    repeats:YES];
    
    [self bindViewModel];
}

- (void)performTwitterButtonAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.125;
    animation.repeatCount = 3;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)];
    [self.twitterButton.layer addAnimation:animation forKey:nil];
}

- (void)bindViewModel {
    self.twitterButton.rac_command = self.viewModel.executeFeedAccess;
}

@end
