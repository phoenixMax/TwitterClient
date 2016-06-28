//
//  MYTwitterFeedViewModel.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import "MYTwitterFeedViewModel.h"
#import "MYTweet.h"
#import "MYUser.h"

@interface MYTwitterFeedViewModel()<NSFetchedResultsControllerDelegate>

@property (nonatomic, readwrite) RACCommand *refreshCommand;
@property (strong, nonatomic) RACSubject *updatedContentSignal;
@property (nonatomic, readwrite) RACSignal *userSignal;
@property (weak, nonatomic) id<MYViewModelServices> services;
@property (readonly, weak, nonatomic) NSManagedObjectContext *model;

@end

@implementation MYTwitterFeedViewModel

- (instancetype)initWithModel:(NSManagedObjectContext *)model services:(id<MYViewModelServices>)services {
    if (self = [super init]) {
        _services = services;
        _model = model;
        
        self.userSignal = [self.services.twitterService userSignal];
    
        self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"MYTwitterFeedViewModel updatedContentSignal"];
        @weakify(self)
        self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[self.services.twitterService updateFeed] doCompleted:^{
                [(RACSubject *)self.updatedContentSignal sendNext:nil];
            }];
        }];
        
        [self.didBecomeActiveSignal subscribeNext:^(id x) {
            @strongify(self);
            [self.fetchedResultsController performFetch:nil];
        }];
    }
    return self;
}

- (NSInteger)numberOfSections {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)userNameAtIndexPath:(NSIndexPath *)indexPath {
    MYTweet *tweet = [self tweetAtIndexPath:indexPath];
    MYUser *user = tweet.user;
    return [user valueForKey:@keypath(user, name)];
}

- (NSString *)userImageAtIndexPath:(NSIndexPath *)indexPath {
    MYTweet *tweet = [self tweetAtIndexPath:indexPath];
    MYUser *user = [tweet valueForKey:@keypath(tweet, user)];
    return [user valueForKey:@keypath(user, profile_image_url)];
}

- (NSString *)textAtIndexPath:(NSIndexPath *)indexPath {
    MYTweet *tweet = [self tweetAtIndexPath:indexPath];
    return [tweet valueForKey:@keypath(tweet, text)];
}

- (MYTweet *)tweetAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MYTweet" inManagedObjectContext:self.model];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.model
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [(RACSubject *)self.updatedContentSignal sendNext:nil];
}

@end
