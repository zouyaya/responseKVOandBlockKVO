//
//  NSObject+YOKVOTool.h
//  ResponseStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YOKVOInfoTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YOKVOTool)

/**
 添加观察者
 */
-(void)customYO_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(YOKeyValueObservingOptions)options context:(void *)context;
/**
 *相应观察者
 */
-(void)customYO_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;
/**
 *移除观察者
 */
-(void)customYO_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;


@end

NS_ASSUME_NONNULL_END

