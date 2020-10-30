//
//  YOListenKVOViewController.m
//  ResponseStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//

#import "YOListenKVOViewController.h"
#import "YOPerson.h"
#import "YOKVOInfoTool.h"
#import "NSObject+YOKVOTool.h"
#import <objc/message.h>

#define k_ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define k_ScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface YOListenKVOViewController ()

@property (strong, nonatomic) YOPerson *person;


@end

@implementation YOListenKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTheOperareKVOChangeButton];
    
    [self initialzieTheRelatePersonData];
    
    

}


#pragma mark --------------------相关初始化
/**
 初始化相关的监听对象数据
 */
-(void)initialzieTheRelatePersonData
{
    self.person = [[YOPerson alloc]init];
    
    
    [self.person customYO_addObserver:self forKeyPath:@"fullName" options:(YOKeyValueObservingOptionNew|YOKeyValueObservingOptionOld) context:NULL];
    
    [self printClassAllMethod:[YOPerson class]];
      
    [self printClasses:[YOPerson class]];
    
    self.person.fullName = @"yangou";
    self.person->fingerCount    = @"10";

}


/**
 初始化点击按钮
 */
-(void)initTheOperareKVOChangeButton
{
    UIButton *operateButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 200, k_ScreenWidth - 60,k_ScreenWidth - 60)];
    operateButton.backgroundColor = [UIColor blueColor];
    operateButton.layer.cornerRadius = 10;
    operateButton.clipsToBounds = YES;
    [operateButton setTitle:@"请点击监听KVO数据变化" forState:UIControlStateNormal];
    operateButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [operateButton addTarget:self action:@selector(pressToOperateKVO:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:operateButton];
    
    
}




#pragma mark - 遍历方法-ivar-property
- (void)printClassAllMethod:(Class)cls{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"%@-%p",NSStringFromSelector(sel),imp);
    }
    free(methodList);
}

#pragma mark - 遍历类以及子类
- (void)printClasses:(Class)cls{
    
    /// 注册类的总数
    int count = objc_getClassList(NULL, 0);
    /// 创建一个数组， 其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    /// 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    NSLog(@"classes = %@", mArray);
}


#pragma mark --------------------相关方法

-(void)pressToOperateKVO:(UIButton *)button
{
    NSLog(@"实际情况:%@-%@",self.person.fullName,self.person->fingerCount);
}

#pragma mark --------------------相关代理方法

-(void)customYO_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"KVO 相应回调  %@",change);

}



-(void)dealloc
{
    [self.person customYO_removeObserver:self forKeyPath:@"fullName"];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
