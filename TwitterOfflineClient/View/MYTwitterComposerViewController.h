//
//  MYTwitterComposerViewController.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/28/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <Social/Social.h>
#import "MYTwitterShareViewModel.h"

@interface MYTwitterComposerViewController : SLComposeServiceViewController

- (instancetype)initWithViewModel:(MYTwitterShareViewModel *)viewModel;

@end
