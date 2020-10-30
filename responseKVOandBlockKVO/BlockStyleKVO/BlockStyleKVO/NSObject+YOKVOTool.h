//
//  NSObject+YOKVOTool.h
//  BlockStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YOKVORespondBlock)(id observer,NSString *keyPath,id oldValue,id newValue);

@interface NSObject (YOKVORespondBlock)

- (void)customYO_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(YOKVORespondBlock)block;

- (void)customYO_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
