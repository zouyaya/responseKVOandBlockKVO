//
//  YOKVOInfoTool.h
//  ResponseStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, YOKeyValueObservingOptions) {

    YOKeyValueObservingOptionNew = 0x01,
    YOKeyValueObservingOptionOld = 0x02,
};


NS_ASSUME_NONNULL_BEGIN

@interface YOKVOInfoTool : NSObject

@property (strong, nonatomic) NSObject *observer;

@property (strong, nonatomic) NSString *keyPath;

@property (assign, nonatomic) YOKeyValueObservingOptions options;

-(instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(YOKeyValueObservingOptions)options;


@end

NS_ASSUME_NONNULL_END
