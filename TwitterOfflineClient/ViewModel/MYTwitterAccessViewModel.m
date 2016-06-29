//
//  MYTwitterAccessViewModel.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import "MYTwitterAccessViewModel.h"
#import "MYTwitterFeedViewModel.h"
#import "MYCoreDataStack.h"

@interface MYTwitterAccessViewModel()

@property (weak, nonatomic) id<MYViewModelServices> services;
@property (strong, nonatomic) RACSignal *executeFeedSave;

@end

@implementation MYTwitterAccessViewModel

- (instancetype)initWithServices:(id<MYViewModelServices>)services {
    if (self = [super init]) {
        _services = services;
        [self initialize];
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    self.executeFeedAccess = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self executeFeedSignal];
    }];
}

- (RACSignal *)executeFeedSignal {
    return [[[[[[self.services twitterService] getFeedSignal] flattenMap:^RACStream *(NSArray *feedData) {
        return [[self.services twitterService] persistFeedSignal:feedData];
    }] deliverOnMainThread] doCompleted:^ {
        MYTwitterFeedViewModel *feedViewModel = [[MYTwitterFeedViewModel alloc] initWithModel:[MYCoreDataStack defaultStack].managedObjectContext services:self.services];
        [self.services pushViewModel:feedViewModel];
    }] doError:^(NSError *error) {
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:error.domain
                                                                 message:error.userInfo[@"description"]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
        [errorAlertView show];
    }];
}

@end
