//
//  KGSingletonSample.m
//  KusogeTest
//
//  Created by naoyashiga on 2014/09/24.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

#import "KGSingletonSample.h"

@implementation KGSingletonSample

static KGSingletonSample *sharedData_ = nil;

+ (KGSingletonSample *)sharedManager{
    @synchronized(self){
        if(!sharedData_){
            sharedData_ = [KGSingletonSample new];
            sharedData_.score = 0;
        }
    }
    
    return sharedData_;
}

- (id)init{
    self = [super init];
    if (self) {
        //初期化
    }
    
    return self;
}
@end
