//
//  MYViewModelClients.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYTwitterClient.h"

@protocol MYViewModelServices <NSObject>

- (id<MYTwitterClient>)twitterService;

- (void)pushViewModel:(id)viewModel;

@end
