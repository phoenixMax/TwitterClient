//
//  MYTwitterLogin.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol MYTwitterClient <NSObject>

- (RACSignal *)userSignal;
- (RACSignal *)getFeedSignal;
- (RACSignal *)persistFeedSignal:(NSArray *)feedData;
- (RACSignal *)updateFeedSignal;
- (RACSignal *)postTweetSignal:(NSString *)tweet;

@end
