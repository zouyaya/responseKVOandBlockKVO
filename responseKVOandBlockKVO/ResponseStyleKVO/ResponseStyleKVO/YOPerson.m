//
//  YOPerson.m
//  ResponseStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//

#import "YOPerson.h"

@implementation YOPerson



+ (instancetype)shareInstancePerson
{
    static YOPerson *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super allocWithZone:NULL] init] ;
        
    });
    
    return _instance;
    
}


+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [YOPerson shareInstancePerson];
}


-(id)copyWithZone:(struct _NSZone *)zone{
   
   return [YOPerson shareInstancePerson];
}


- (void)setFullName:(NSString *)fullName
{
    NSLog(@"来到了YOPerson 的setter方法 :%@",fullName);
    _fullName = fullName;
    
}

@end
