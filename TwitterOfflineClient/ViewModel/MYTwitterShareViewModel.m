//
//  MYTwitterShareViewModel.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/28/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import "MYTwitterShareViewModel.h"
#import "MYViewModelServices.h"

@interface MYTwitterShareViewModel()

@property (strong, nonatomic, readwrite) RACSignal *postSignail;
@property (strong, nonatomic) id<MYViewModelServices> services;

@end

@implementation MYTwitterShareViewModel

- (instancetype)initWithServices:(id<MYViewModelServices>)services {
    if (self = [super init]) {
        _services = services;
        
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    RACObserve(self, contentText);
}

- (RACSignal *)postTweetSignal {
    return [self.services.twitterService postTweet:self.contentText];
}

- (RACSignal *)updateFeedSignal {
    return [self.services.twitterService updateFeed];
}

@end
