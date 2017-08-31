//
//  TLOrderVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderVC.h"
#import "TLUIHeader.h"
#import "ZHSegmentView.h"
#import "TLOrderCategoryVC.h"
#import "TLSearchView.h"
#import "TLOrderDetailVC2.h"
#import "OrderSearchVC.h"
#import "NSString+Extension.h"
#import "TLAlert.h"

@interface TLOrderVC ()<ZHSegmentViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *isAdd ;
@property (nonatomic, strong) UIScrollView *switchScrollView;
@property (nonatomic, strong) TLSearchView *searchView;

@property (nonatomic, copy) NSArray<NSNumber *> *orderStatusArr;

@end


@implementation TLOrderVC

#pragma mark- 搜索
- (void)search {

    if (![self.searchView.textField.text valid]) {
        [TLAlert alertWithInfo:@"请输入搜索内容"];
        return;
    }
    //
    OrderSearchVC *vc = [[OrderSearchVC alloc] init];
    vc.searchInfo = self.searchView.textField.text;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单";
   
    self.view.backgroundColor = [UIColor whiteColor];
    //
    self.searchView = [[TLSearchView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 88)];
    [self.view addSubview:self.searchView];
    [self.searchView.searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    //
    ZHSegmentView *segmentView =  [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, self.searchView.yy, SCREEN_WIDTH, 40)];
    [self.view addSubview:segmentView];
    segmentView.delegate = self;
    segmentView.tagNames = @[@"全部订单",@"待量体",@"待支付",@"待录入",@"待复核"];
    
    //
    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentView.yy, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - segmentView.bottom)];
    self.switchScrollView.delegate = self;
    [self.view addSubview:self.switchScrollView];
    self.switchScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * segmentView.tagNames.count, self.switchScrollView.height);
    self.switchScrollView.scrollEnabled = NO;
    self.switchScrollView.showsHorizontalScrollIndicator = NO;

    
    self.isAdd = [@[@1 ,@0 ,@0 ,@0,@0] mutableCopy];
    
    self.orderStatusArr = @[@(TLOrderStatusAll),@(TLOrderStatusWillMeasurement),@(TLOrderStatusWillPay),@(TLOrderStatusWillSubmit),@(TLOrderStatusWillCheck)];
    
    TLOrderCategoryVC *vc = [[TLOrderCategoryVC alloc] init];
    vc.status = [self.orderStatusArr[0] integerValue];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.switchScrollView.height);
    [self.switchScrollView addSubview:vc.view];
    
}

- (BOOL)segmentSwitch:(NSInteger)idx {

    [self.switchScrollView setContentOffset:CGPointMake(idx * SCREEN_WIDTH, 0) animated:YES];
    
    if ([self.isAdd[idx] isEqual:@0]) {
        
        TLOrderCategoryVC *vc = [[TLOrderCategoryVC alloc] init];
        vc.status = [self.orderStatusArr[idx] integerValue];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, self.switchScrollView.height);
        [self.switchScrollView addSubview:vc.view];
        
        self.isAdd[idx] = @1;
        
    }
    
    return YES;

}

//- (void)setUpSearchView {
//
//    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 88)];
//    [self.view addSubview:searchBgView];
//    self.searchBgView = searchBgView;
//    
//    //
//    UIView *searchTfBgView = [[UIView alloc] initWithFrame:CGRectMake(18, 10,SCREEN_WIDTH - 110, 40)];
//    [self.view addSubview:searchTfBgView];
//    searchTfBgView.layer.borderColor = [UIColor colorWithHexString:@"#a0a0a0"].CGColor;
//    searchTfBgView.layer.borderWidth = 1;
//    searchTfBgView.layer.cornerRadius = 5;
//    searchTfBgView.layer.masksToBounds = YES;
//    
//    //
//    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, searchTfBgView.width - 32, searchTfBgView.height)];
//    
//    [searchTfBgView addSubview:tf];
//    tf.font = FONT(14);
//    tf.placeholder = @"请输入订单编号、客户姓名或手机号";
//    
//    //
//    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchTfBgView.right + 10, searchTfBgView.top, 63, tf.height) title:@"搜索" backgroundColor:[UIColor themeColor]];
//    searchBtn.layer.cornerRadius = 5;
//    searchBtn.layer.masksToBounds = YES;
//    [searchBgView addSubview:searchBtn];
//    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//
//}




@end
