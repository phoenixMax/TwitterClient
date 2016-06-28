//
//  MYTwitterAccessViewModel.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MYViewModelServices.h"

@interface MYTwitterAccessViewModel : NSObject

- (instancetype)initWithServices:(id<MYViewModelServices>)services;

@property (strong, nonatomic) RACCommand *executeFeedAccess;

@end
