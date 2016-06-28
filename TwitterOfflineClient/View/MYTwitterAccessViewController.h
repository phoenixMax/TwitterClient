//
//  MYTwitterAccessViewController.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYTwitterAccessViewModel.h"

@interface MYTwitterAccessViewController : UIViewController

- (instancetype)initWithModel:(MYTwitterAccessViewModel *)viewModel;

- (void)setupViewModel:(MYTwitterAccessViewModel *)viewModel;

@end
