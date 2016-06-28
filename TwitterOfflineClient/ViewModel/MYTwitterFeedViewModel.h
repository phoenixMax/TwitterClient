//
//  MYTwitterFeedViewModel.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MYViewModelServices.h"
#import "RVMViewModel.h"

@interface MYTwitterFeedViewModel : RVMViewModel

@property (nonatomic, readonly) RACCommand *refreshCommand;
@property (nonatomic, readonly) RACSignal *updatedContentSignal;
@property (nonatomic, readonly) RACSignal *userSignal;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithModel:(NSManagedObjectContext *)model services:(id<MYViewModelServices>)services;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (NSString *)userNameAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)userImageAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)textAtIndexPath:(NSIndexPath *)indexPath;

@end
