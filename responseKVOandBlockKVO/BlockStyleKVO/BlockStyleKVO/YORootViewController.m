//
//  YORootViewController.m
//  BlockStyleKVO
//
//  Created by yangou on 2020/10/30.
//  Copyright © 2020 hello. All rights reserved.
//

#import "YORootViewController.h"
#import "YOListenKVOViewController.h"


#define k_ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define k_ScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface YORootViewController ()

@end

@implementation YORootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *jumpButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 200,k_ScreenWidth - 20 , 50)];
    jumpButton.backgroundColor = [UIColor brownColor];
    jumpButton.layer.cornerRadius = 10;
    jumpButton.clipsToBounds = YES;
    [jumpButton setTitle:@"跳转操作KVO" forState:UIControlStateNormal];
    [jumpButton addTarget:self action:@selector(pressToJumpKVOVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpButton];
    
}



/**
 点击跳转
 */
-(void)pressToJumpKVOVC:(UIButton *)button
{
    YOListenKVOViewController *kvoVC = [[YOListenKVOViewController alloc]init];
    [self.navigationController pushViewController:kvoVC animated:YES];
    
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
