//
//  YOPerson.h
//  ResponseStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YOPerson : NSObject{
    
    @public
    NSString *fingerCount; //手指数量，声明一个成员变量
    
}


@property (copy, nonatomic) NSString *fullName; //属性，全名

//单利初始化
+ (instancetype)shareInstancePerson;


@end

NS_ASSUME_NONNULL_END
