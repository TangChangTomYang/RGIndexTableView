//
//  TestIndexViewController.m
//  RGIndexTableView
//
//  Created by yangrui on 2019/11/4.
//  Copyright © 2019 yangrui. All rights reserved.
//

#import "TestIndexViewController.h"
#import "NSString+HanZi.h"

@interface TestIndexViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *cityContainer;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@property (weak, nonatomic) IBOutlet UIView *indexContainer;
@property (weak, nonatomic) IBOutlet UITableView *indexTableView;

@property (strong, nonatomic) NSMutableDictionary *cityDicM;
@property (strong, nonatomic) NSArray *cityIndexArr;


@property (weak, nonatomic) IBOutlet UITextField *searchCityField;
@property (strong, nonatomic) NSDictionary *selectedCity;

@property (assign, nonatomic)NSInteger currentIndex;


@end

@implementation TestIndexViewController

-(NSMutableDictionary *)cityDicM{
    if (!_cityDicM) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"city_cn.txt" withExtension:@""];
        NSData *cityData = [NSData dataWithContentsOfURL:url];
        
        NSMutableDictionary *dicM = [NSJSONSerialization JSONObjectWithData:cityData options:NSJSONReadingMutableLeaves error:nil];
        _cityDicM = dicM;
    }
    return _cityDicM;
}

-(NSArray *)cityIndexArr{
    if (!_cityIndexArr) {
       _cityIndexArr = [[self.cityDicM allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString  *obj1,NSString *obj2) {
            return  [obj1 compare:obj2];
        }];
    }
    return _cityIndexArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cityIndexArr];
    [self setupCityTableView];
    [self setupIndexTableView];
    
    
    self.searchCityField.delegate = self;
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.indexContainer addGestureRecognizer:pan];
    self.currentIndex = -1;
    self.indexContainer.layer.borderColor = [UIColor redColor].CGColor;
    self.indexContainer.layer.borderWidth = 1.0;
}
 
-(void)setupCityTableView{
    self.cityTableView.dataSource = self;
    self.cityTableView.delegate = self;
    //[self.cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"city"];
    self.cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)setupIndexTableView{
    self.indexTableView.dataSource = self;
    self.indexTableView.delegate = self;
    [self.indexTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"index"];
    self.indexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.indexTableView.scrollEnabled = NO;
    
    
}

#pragma mark- UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.cityTableView]) {
        return  [self city_numberOfSectionsInTableView:tableView];
    }
    return  [self index_numberOfSectionsInTableView:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.cityTableView]) {
        return  [self city_tableView:tableView numberOfRowsInSection:section];
    }
    return  [self index_tableView:tableView numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.cityTableView]) {
        return  [self city_tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return  [self index_tableView:tableView heightForRowAtIndexPath:indexPath];
}
 

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:self.cityTableView]) {
          return  self.cityIndexArr[section];
      }
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.cityTableView]) {
        return  [self city_tableView:tableView cellForRowAtIndexPath: indexPath];
    }
    return  [self index_tableView:tableView cellForRowAtIndexPath: indexPath];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{ 
    if ([tableView isEqual:self.cityTableView]) {
        [self city_tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    [self index_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
    //return [tableView isEqual:self.cityContainer];
}




#pragma mark-city相关  UITableViewDelegate, UITableViewDataSource
-(NSInteger)city_numberOfSectionsInTableView:(UITableView *)tableView{
   
    return self.cityDicM.allKeys.count;
}

-(NSInteger)city_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *cityIndex = self.cityIndexArr[section];
    NSArray *cityArr = self.cityDicM[cityIndex];
    return cityArr.count;
}


-(CGFloat)city_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(UITableViewCell *)city_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"city"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"city"];
    }
    NSString *cityIndex = self.cityIndexArr[indexPath.section];
    
    NSArray *cityArr = self.cityDicM[cityIndex];
    NSDictionary *city = cityArr[indexPath.row];
    cell.textLabel.text = city[@"city"];
    cell.detailTextLabel.text = city[@"country"];
    return cell;
}
 


-(void)city_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
    NSString *cityIndex = self.cityIndexArr[indexPath.section];
    NSArray *cityArr = self.cityDicM[cityIndex];
    self.selectedCity = cityArr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchCityField.text = [NSString stringWithFormat:@"%@-%@",self.selectedCity[@"city"], self.selectedCity[@"country"] ];
    
}


#pragma mark-index相关  UITableViewDelegate, UITableViewDataSource
-(NSInteger)index_numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)index_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.cityIndexArr.count;
}

-(CGFloat)index_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  tableView.frame.size.height / self.cityIndexArr.count;
}


-(UITableViewCell *)index_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"index" forIndexPath:indexPath];
    cell.textLabel.text = self.cityIndexArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)index_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      
    
    [self cityTableViewScroll2section:indexPath.row];
}


-(void)cityTableViewScroll2section:(NSInteger)section{
    
    NSIndexPath *cityIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    [self.cityTableView scrollToRowAtIndexPath:cityIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}



#pragma mark- panGestureRecognizerAction
-(void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan{
    
    if(pan.state == UIGestureRecognizerStateBegan ){
        [self panGesture_beginAction:pan];
    }
    else if(pan.state == UIGestureRecognizerStateChanged ){
           [self panGesture_changeAction:pan];
    }
    else{
        [self panGesture_endAction:pan];
    }
}
-(void)panGesture_beginAction:(UIPanGestureRecognizer *)pan{
  
    [self updateIndexForPanGesture:pan];
}
-(void)panGesture_changeAction:(UIPanGestureRecognizer *)pan{
    
   [self updateIndexForPanGesture:pan];
}

-(void)panGesture_endAction:(UIPanGestureRecognizer *)pan{
   [self updateIndexForPanGesture:pan];
    self.currentIndex = -1;
}

-(void)updateIndexForPanGesture:(UIPanGestureRecognizer *)pan{

    CGPoint point = [pan locationInView:self.indexContainer];
    NSInteger row = [self.indexTableView indexPathForRowAtPoint:point].row;
    
    
    NSLog(@"-------row: %ld", row);
    if (row != self.currentIndex) {
        self.currentIndex = row;
        [self cityTableViewScroll2section:row];
    }
}


#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}          // called when 'return' key pressed. return NO to ignore.

@end
 
