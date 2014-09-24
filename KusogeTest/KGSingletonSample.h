//
//  KGSingletonSample.h
//  KusogeTest
//
//  Created by naoyashiga on 2014/09/24.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGSingletonSample : NSObject

+ (KGSingletonSample *)sharedManager;
@property(nonatomic,assign) int score;

@end
