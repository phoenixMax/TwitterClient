//
//  MYTweet+CoreDataProperties.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/28/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MYTweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface MYTweet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sid;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *created_at;
@property (nullable, nonatomic, retain) MYUser *user;

@end

NS_ASSUME_NONNULL_END
