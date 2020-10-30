//
//  YOKVOInfoTool.m
//  ResponseStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//

#import "YOKVOInfoTool.h"

@implementation YOKVOInfoTool


-(instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(YOKeyValueObservingOptions)options
{
    self = [super init];
    if (self) {
        
        self.observer = observer;
        self.keyPath = keyPath;
        self.options = options;
        
    }
    
    return self;
    
}

@end
