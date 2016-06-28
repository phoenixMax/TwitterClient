//
//  ViewController.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYTwitterFeedViewModel.h"

@interface MYTwitterFeedViewController : UITableViewController

- (instancetype)initWithViewModel:(MYTwitterFeedViewModel *)viewModel;

@end

