//
//  MYTweet.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/28/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MYUser;

NS_ASSUME_NONNULL_BEGIN

@interface MYTweet : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "MYTweet+CoreDataProperties.h"
