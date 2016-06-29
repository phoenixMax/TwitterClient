//
//  MYTwitterShareViewModel.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/28/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVMViewModel.h"
#import "MYViewModelServices.h"

@interface MYTwitterShareViewModel : RVMViewModel

@property (strong, nonatomic) NSString *contentText;
@property (strong, nonatomic, readonly) RACSignal *postSignail;

- (instancetype)initWithServices:(id<MYViewModelServices>)services;

- (RACSignal *)postTweetSignal;
- (RACSignal *)updateFeedSignal;

@end
