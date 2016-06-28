//
//  MYUser+CoreDataProperties.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/28/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MYUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *profile_image_url;
@property (nullable, nonatomic, retain) NSSet<MYTweet *> *tweets;

@end

@interface MYUser (CoreDataGeneratedAccessors)

- (void)addTweetsObject:(MYTweet *)value;
- (void)removeTweetsObject:(MYTweet *)value;
- (void)addTweets:(NSSet<MYTweet *> *)values;
- (void)removeTweets:(NSSet<MYTweet *> *)values;

@end

NS_ASSUME_NONNULL_END
