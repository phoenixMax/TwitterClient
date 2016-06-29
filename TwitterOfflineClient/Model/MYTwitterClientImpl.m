//
//  MYTwitterLoginService.m
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import "MYTwitterClientImpl.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "MYCoreDataStack.h"
#import "MYTweet+CoreDataProperties.h"
#import "MYUser+CoreDataProperties.h"

@implementation MYTwitterClientImpl

- (RACSignal *)userSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            [subscriber sendError:nil];
        }
        ACAccount *twitterAccount = [self twitterAccount];
        if (twitterAccount) {
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
            
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:@"0" forKey:@"include_entities"];
            [params setObject:@"1" forKey:@"skip_status"];
            [params setObject:@"1" forKey:@"include_email"];
            
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodGET
                                                              URL:url
                                                       parameters:params];
            [request setAccount:twitterAccount];
            [request performRequestWithHandler:^(NSData *responseData,
                                                 NSHTTPURLResponse *urlResponse,
                                                 NSError *error) {
                if (responseData) {
                    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseData
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:NULL];
                    [subscriber sendNext:userInfo];
                }
            }];
        }
        return [RACDisposable disposableWithBlock:^{}];
    }];
}

- (RACSignal *)getFeedSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            [subscriber sendError:nil];
        }
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:
                                      ACAccountTypeIdentifierTwitter];
        
        [accountStore requestAccessToAccountsWithType:accountType
                                         options:nil
                                      completion:^(BOOL granted, NSError *error)
        {
            if (granted) {
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                NSDictionary *params = @{@"include_rts" : @"1",
                                         @"trim_user" : @"1"};
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodGET
                                                                  URL:url
                                                           parameters:params];
                ACAccount *twitterAccount = [self twitterAccount];
                if (twitterAccount) {
                    [request setAccount:twitterAccount];
                    
                    [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        if (responseData) {
                            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                NSError *jsonError;
                                NSDictionary *feedData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                         options:NSJSONReadingAllowFragments
                                                                                           error:&jsonError];
                                if (feedData) {
                                    [subscriber sendNext:feedData];
                                }
                                else {
                                    [subscriber sendError:jsonError];
                                }
                            }
                            else {
                                [subscriber sendError:error];
                            }
                            [subscriber sendCompleted];
                        }
                    }];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:@"Twitter Error" code:400 userInfo:@{@"description": @"Setup twiiter account in Settings app."}]];
                }
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"Twitter Error" code:400 userInfo:@{@"description": @"Access to Twitter was not granted."}]];
            }
        }];

        return [RACDisposable disposableWithBlock:^{}];
    }];
}

- (RACSignal *)persistFeedSignal:(NSArray *)feedData {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSManagedObjectContext *moc = [MYCoreDataStack defaultStack].managedObjectContext;
        for (NSDictionary *tweetInfo in feedData) {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSString *sid = tweetInfo[@"id_str"];
            [request setEntity:[NSEntityDescription entityForName:@"MYTweet" inManagedObjectContext:moc]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sid == %@", sid];
            [request setPredicate:predicate];
            NSArray *results = [moc executeFetchRequest:request error:nil];
            MYTweet *tweet = results.firstObject;
            if (!tweet) {
                tweet = [NSEntityDescription insertNewObjectForEntityForName:@"MYTweet" inManagedObjectContext:moc];
                tweet.sid = sid;
            }
            tweet.text = tweetInfo[@"text"];
            tweet.created_at = [self dateFromString:tweetInfo[@"created_at"]];
            
            NSDictionary *userInfo = tweetInfo[@"user"];
            sid = userInfo[@"id_str"];
            [request setEntity:[NSEntityDescription entityForName:@"MYUser" inManagedObjectContext:moc]];
            predicate = [NSPredicate predicateWithFormat:@"sid == %@", sid];
            [request setPredicate:predicate];
            results = [moc executeFetchRequest:request error:nil];
            
            MYUser *user = results.firstObject;
            if (!user) {
                user = [NSEntityDescription insertNewObjectForEntityForName:@"MYUser" inManagedObjectContext:moc];
                user.sid = sid;
            }
            user.name = userInfo[@"name"];
            [user addTweetsObject:tweet];
        }
        [[MYCoreDataStack defaultStack] saveContext];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

- (RACSignal *)updateFeedSignal {
    return [[self getFeedSignal] flattenMap:^RACStream *(NSArray *feedData) {
        return [self persistFeedSignal:feedData];
    }];
}

- (RACSignal *)postTweetSignal:(NSString *)tweet {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [account requestAccessToAccountsWithType:accountType
                                         options:nil
                                      completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 ACAccount *twitterAccount = [self twitterAccount];
                 if (twitterAccount) {
                     NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                     SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                 requestMethod:SLRequestMethodPOST
                                                                           URL:requestURL
                                                                    parameters:@{@"status": tweet}];
                     postRequest.account = twitterAccount;
                     
                     [postRequest performRequestWithHandler:^(NSData *responseData,
                                                              NSHTTPURLResponse *urlResponse, NSError *error) {
                          NSLog(@"HTTP Response: %li", (long)[urlResponse statusCode]);
                         [subscriber sendNext:responseData];
                      }];
                 }
             }
        }];
        
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
}

#pragma mark - Helpers

- (ACAccount *)twitterAccount {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
    
    if (twitterAccounts.count) {
        return [twitterAccounts lastObject];
    }
    return nil;
}

- (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter= [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    
   return [dateFormatter dateFromString:dateString];
}

@end
