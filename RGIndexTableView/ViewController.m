//
//  ViewController.m
//  RGIndexTableView
//
//  Created by yangrui on 2019/11/4.
//  Copyright © 2019 yangrui. All rights reserved.
//

#import "ViewController.h"
#import "TestIndexViewController.h"

#import "NSString+HanZi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)btnClick:(id)sender {
    
    TestIndexViewController *indexVC = [[TestIndexViewController alloc] init];
    [self.navigationController pushViewController:indexVC animated:YES];
    
}
- (IBAction)change:(id)sender {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"city_cn.txt" withExtension:@""];
           NSData *cityData = [NSData dataWithContentsOfURL:url];
           
     NSMutableDictionary *dicM = [NSJSONSerialization JSONObjectWithData:cityData options:NSJSONReadingMutableContainers error:nil];
    
    
    [dicM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMutableArray *cityArr, BOOL * _Nonnull stop) {
        
//        obj[@"city_pinyin"] = [obj[@"city"]  hanZiPinYin];
//        NSLog(@"key: %@,  value: %@", key, obj);
        
        [cityArr enumerateObjectsUsingBlock:^(NSMutableDictionary  *dM, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSLog(@"%@",[dM class]);
            
            dM[@"city_pinyin"] = [dM[@"city"]  hanZiPinYin];
            
            NSLog(@"");
        }];
         NSLog(@"key: %@,  value: %@", key, cityArr);
    }];
    
    [NSURL fileURLWithPath:@"/Users/yangrui/Desktop/cityCn.txt"];

    
    NSData *dta = [NSJSONSerialization dataWithJSONObject:dicM options:NSJSONWritingPrettyPrinted error:nil];

}
@end
