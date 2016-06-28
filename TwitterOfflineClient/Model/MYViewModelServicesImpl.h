//
//  MYViewModelServicesImpl.h
//  TwitterOfflineClient
//
//  Created by Maxim Yakovlev on 6/27/16.
//  Copyright © 2016 Maksym Yakovlev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYViewModelServices.h"

@interface MYViewModelServicesImpl : NSObject<MYViewModelServices>

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end
