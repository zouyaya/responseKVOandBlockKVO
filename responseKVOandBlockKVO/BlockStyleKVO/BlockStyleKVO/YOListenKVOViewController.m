//
//  YOListenKVOViewController.m
//  BlockStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//

#import "YOListenKVOViewController.h"
#import "YOPerson.h"
#import "NSObject+YOKVOTool.h"
#import <objc/runtime.h>

#define k_ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define k_ScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface YOListenKVOViewController ()

@property (strong, nonatomic) YOPerson *person;

@end

@implementation YOListenKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initTheOperareKVOChangeButton];
    
    
    self.person = [[YOPerson alloc] init];
    [self.person customYO_addObserver:self forKeyPath:@"fullName" block:^(id  _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"%@-%@",oldValue,newValue);
    }];
    
    self.person.fullName = @"yangou";
    
    
}



-(void)dealloc
{
    
    [self.person customYO_removeObserver:self forKeyPath:@"fullName"];
    
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



#pragma mark --------------------相关方法

-(void)pressToOperateKVO:(UIButton *)button
{
    self.person.fullName = [NSString stringWithFormat:@"%@+",self.person.fullName];
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
