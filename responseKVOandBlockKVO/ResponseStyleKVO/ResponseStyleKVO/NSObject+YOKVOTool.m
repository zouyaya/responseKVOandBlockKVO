//
//  NSObject+YOKVOTool.m
//  ResponseStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//


#import "NSObject+YOKVOTool.h"
#import <objc/message.h>

/**派生类的前缀*/
static NSString *const kYOKVOPrefix = @"YOKVONotifying_";
/**分类的关联对象关键字*/
static NSString *const kYOKVOAssiociateKey = @"kYOKVO_AssiociateKey";


@implementation NSObject (YOKVOTool)


-(void)customYO_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(YOKeyValueObservingOptions)options context:(void *)context
{
    
     // 1: 验证是否存在setter方法 : 不让实例进来
    [self judgeTheCurrentPropertyOrIvarsIsHaveSetterAccordingToTheKeyPath:keyPath];
    
    //2动态生成子类信息
   Class newClass =  [self createNewChildClassWithTheKeyPath: keyPath];
    
    // 3: isa的指向 : LGKVONotifying_LGPerson
    object_setClass(self, newClass);
    
    //4 保存观察者信息
    YOKVOInfoTool *itemInfo = [[YOKVOInfoTool alloc]initWitObserver:observer forKeyPath:keyPath options:options];
    
    NSMutableArray *observeArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kYOKVOAssiociateKey));
    
    if (!observeArray) {
        
        observeArray = [NSMutableArray arrayWithCapacity:1];
        [observeArray addObject:itemInfo];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kYOKVOAssiociateKey), observeArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
}


-(void)customYO_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    
}


-(void)customYO_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    NSMutableArray *observeArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kYOKVOAssiociateKey));
    
    if (!observeArray.count) { return; }
    
    for (YOKVOInfoTool *itemInfo in observeArray) {
        
        if ([itemInfo.keyPath isEqualToString:keyPath]) {
            
            [observeArray removeObject:itemInfo];
            objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kYOKVOAssiociateKey), observeArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
            
        }
        
    }
    
    if (observeArray.count <= 0) {
        
        Class superClass = [self class];
        object_setClass(self, superClass);
        
    }
    

    
}



#pragma mark ------判断当前属性下是否存在相应的setter方法
/**
 通过传入的属性或者成员变量
 判断是否存在相应的setter方法
 */
-(void)judgeTheCurrentPropertyOrIvarsIsHaveSetterAccordingToTheKeyPath:(NSString *)keyPath
{
    //1 因为当前的self是分类，所以需要获取相应的父类，也就是响应KVO的控制器
    Class superClass = object_getClass(self);
    
    //2 取出相应的SEL
    SEL setterSeletor = NSSelectorFromString(getTheSetterMethordFromGetter(keyPath));
    
    
    //3 获取相应的method
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    
    //4 再判断是否有相应的setter 如果没有，抛出相应的异常
    if (!setterMethod) {
        
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"当前的属性不存在%@的setter方法",keyPath] userInfo:nil];
        
    }
    
    
    
}



#pragma mark ----通过keyPath生成相应的子类
/**
 通过相应的属性传递 动态生成相应的子类
 添加相关属性的方法 setter 和getter
 */
-(Class)createNewChildClassWithTheKeyPath:(NSString *)keyPath
{
    //1 取出原来的旧类
    NSString *oldClassName = NSStringFromClass([self class]);
    
    //2生成新的派生类YOKVONotifying_YOPerson
    NSString *newClassName = [NSString stringWithFormat:@"%@%@",kYOKVOPrefix,oldClassName];
    
    //3 把字符串转为相应的类信息
    Class newClass = NSClassFromString(newClassName);
    
    //4防止重复创建，先判断
    if (newClass) { return newClass; }
    
    //5申请新类
    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    
    //6注册类对
    objc_registerClassPair(newClass);
    
    /**
     *因为生成的派生类会重写父类的有关方法
     *class
     *setter
     *isKVOA
     *ISA
     */
    
    //7添加class 指向YOPerson
         //7.1获取类的sel
        SEL classSel = NSSelectorFromString(@"class");
        
        //7.2 //获取相应sel下的方法
        Method classMethod = class_getInstanceMethod([self class], classSel);
        
        //7.3获取相应方法下的type
        const char *classType  = method_getTypeEncoding(classMethod);
        
        //7.4添加方法
        class_addMethod([self class], classSel, (IMP)customYO_class, classType);
        

    //8 添加相应的setter方法
          //8.1获取类的sel
           SEL setterSel = NSSelectorFromString(getTheSetterMethordFromGetter(keyPath));
           
           //8.2 //获取相应sel下的方法
           Method setterMethod = class_getInstanceMethod([self class], setterSel);
           
           //8.3获取相应方法下的type
           const char *setterType  = method_getTypeEncoding(setterMethod);
           
           //8.4添加方法
           class_addMethod([self class], setterSel, (IMP)customYO_setter, setterType);
    
    
    return newClass;
}






#pragma mark -------------响应setter方法，把改变的值通过关联对象回调到父类中
/**
 *自定分类相应setter方法
 *通过关联对象回调到主控制】
 *处理相关的回调
 *从而达到监听KVO的作用
 */
static void customYO_setter(id self,SEL _cmd,id newValue){
    
    NSLog(@"来到了customYO_setter,新值:%@",newValue);
    /**
     消息转发 : 转发给父类
     */
    
    // 改变父类的值 --- 可以强制类型转换
    
    //1 取出相应的属性
    NSString *keyPath = getTheGetterMethordFromSetter(NSStringFromSelector(_cmd));
    
    //2 取出旧值
    id oldValue = [self valueForKey:keyPath];
    
    //3 自定义相关的父类发送消息API 重写objc_msgSendSuper()
    void (* customYo_msgSendSuper)(void *,SEL,id) = (void *)objc_msgSendSuper;
    
    
    struct objc_super superStruct = {
        
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
        
    };
    
     //objc_msgSendSuper(&superStruct,_cmd,newValue)
    customYo_msgSendSuper(&superStruct,_cmd,newValue);
    
    
    //4 拿到相关的观察者；
    NSMutableArray *observeArray = objc_getAssociatedObject(self,  (__bridge const void * _Nonnull)(kYOKVOAssiociateKey));
    
    for (YOKVOInfoTool *itemInfo in observeArray) {
        
        if ([itemInfo.keyPath isEqualToString:keyPath]) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableDictionary<NSKeyValueChangeKey,id> *change = [NSMutableDictionary dictionaryWithCapacity:1];
                //5对新旧值进行处理
                if (itemInfo.options & YOKeyValueObservingOptionNew) {
                    
                    [change setObject:newValue forKey:NSKeyValueChangeNewKey];
                }
                
                if (itemInfo.options & YOKeyValueObservingOptionOld) {
                    
                    [change setObject:@"" forKey:NSKeyValueChangeOldKey];
                    if (oldValue) {
                        
                        [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
                        
                    }
                    
                }
                
                //6将消息发送给观察者
                SEL observeSel = @selector(customYO_observeValueForKeyPath:ofObject:change:context:);
                objc_msgSend(itemInfo.observer,observeSel,keyPath,self,change,NULL);
                
                
            });
            
        }
        
    }
    
    
}




#pragma mark ------------重写类的指向
/**
 如果此处不重写类的指向，
 则父类的指向永远都回不去
 isa指针指向的类永远都是YOKVONotifying_YOPerson
 */
Class customYO_class(id self,SEL _cmd){
   
    return class_getSuperclass(object_getClass(self));
}



#pragma mark -----------从当前的get方法中获取setter方法
/**
 从当前属性的get方法中获取相应的set方法
 即 Key ===>>> setKey:
 此处是调用系统的API，
 所以使用相应的c++函数实现
 */
static NSString *getTheSetterMethordFromGetter(NSString *getter){
    
    //1 先判断，如果不存在getter 直接返回nil
    if (getter.length < 0) {return nil;}
    
    //2 取出属性的第一个字符，把他转换为大写字母，因为属性的第一个字母是大写
    NSString *firstCharacter = [[getter substringToIndex:1]uppercaseString];
    
    //3 取出剩余的部分字符，进行相应的拼接
    NSString *leftCharacter = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstCharacter,leftCharacter];
    
}


/**
从当前属性的set方法中获取相应的get方法
即 setKey: ===>>> Key
此处是调用系统的API，
所以使用相应的c++函数实现
*/
static NSString *getTheGetterMethordFromSetter(NSString *setter){
    
    //1 先判断，如果不存在getter 直接返回nil
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
    
}


@end

