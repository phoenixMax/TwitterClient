//
//  TwitterClientImplSpecs.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/29/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "MYTwitterClientImpl.h"

SPEC_BEGIN(TwitterClientImplSpecs)

describe(@"In a twitter client implementation", ^{
    
    __block MYTwitterClientImpl *twitterClientImpl;
    __block RACSignal *userSignal;
    __block RACSignal *feedSignal;
    
    beforeEach(^{
        twitterClientImpl = [[MYTwitterClientImpl alloc] init];
    });
    
    context(@"when creating user signal", ^{
        
        it(@"user signal should exist and", ^{
            twitterClientImpl = [[MYTwitterClientImpl alloc] init];
            userSignal = [twitterClientImpl userSignal];
            [userSignal shouldNotBeNil];
        });
        
        it(@"user signal must return valid user info and", ^{
            [userSignal subscribeNext:^(NSDictionary *userInfo) {
                [userInfo shouldNotBeNil];
            }];
        });
    });
    
    context(@"when creating twitter feed signal", ^{
        
        it(@"feed signal should exist and", ^{
            twitterClientImpl = [[MYTwitterClientImpl alloc] init];
            feedSignal = [twitterClientImpl getFeedSignal];
            [feedSignal shouldNotBeNil];
        });
        
        it(@"must return feed info", ^{
            [feedSignal subscribeNext:^(NSDictionary *feedInfo) {
                [feedInfo shouldNotBeNil];
            }];
        });
    });
});

SPEC_END
