//
//  TLCustomerVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLCustomerVC.h"
#import "TLUIHeader.h"
#import "TLSearchView.h"
#import "TLCustomerCategoryVC.h"
#import "NSString+Extension.h"
#import "TLAlert.h"
#import "TLCustomerSearchVC.h"

#define NORMAL_TITLE_COLOR  [UIColor colorWithHexString:@"#b3b3b3"]
#define SELECT_TITLE_COLOR  [UIColor themeColor]

#define SWITCH_BACKGROUND_COLOR  [UIColor colorWithHexString:@"#f2f2f2"]

@interface TLCustomerVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *switchScrollView;
@property (nonatomic, strong) TLSearchView *searchView;
@property (nonatomic, strong) UIScrollView *smallChooseScrollView;
@property (nonatomic, strong) NSMutableArray *tagLbls;
@property (nonatomic, copy) NSArray *statusRoom;
@property (nonatomic, strong) UIButton *lasBtn;
@property (nonatomic,strong) NSMutableArray <NSNumber *>*isHaveChildVC;

@end

@implementation TLCustomerVC

- (void)search {
    
    if (![self.searchView.textField.text valid]) {
        [TLAlert alertWithInfo:@"请输入搜索内容"];
        return;
    }
    
    TLCustomerSearchVC *vc = [[TLCustomerSearchVC alloc] init];
    vc.searchInfo = self.searchView.textField.text;
    [self.navigationController pushViewController:vc animated:YES];
    
    //

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户";
    
    // [self setUpSearchView];
    self.searchView = [[TLSearchView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 88)];
    [self.view addSubview:self.searchView];
    self.searchView.textField.placeholder = @"请输入客户姓名、昵称或手机号";
    [self.searchView.searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];

    
    NSArray *typeNames =  @[@"全部客户",@"新用户",@"老客户",@"活跃老客户",@"非常活跃老客户",@"预流失客户",@"流失客户"];
    self.statusRoom = @[@"",@"1",@"2",@"3",@"4",@"5",@"6"];
    self.isHaveChildVC = [NSMutableArray array];
    for (NSInteger i = 0; i < typeNames.count; i ++) {
        if (i == 0) {
            
            [self.isHaveChildVC addObject:@1];
            
        } else {
            
            [self.isHaveChildVC addObject:@0];
            
        }
        
    }
    

    
    //
    UIScrollView *smallChooseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.searchView.yy, SCREEN_WIDTH, 40)];
    smallChooseView.backgroundColor = SWITCH_BACKGROUND_COLOR;
    [self.view addSubview:smallChooseView];
    smallChooseView.showsHorizontalScrollIndicator = NO;
    self.smallChooseScrollView = smallChooseView;
    self.smallChooseScrollView.delegate = self;
    
    //
    self.tagLbls = [NSMutableArray array];
    __block UIButton *lastMarkBtn = [UIButton new];
    [typeNames enumerateObjectsUsingBlock:^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUInteger i = idx;
        //每个起点
        //计算宽度
        CGFloat w = [name calculateStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:FONT(13)].width + 30;
        CGFloat x;
        if (i == 0) {
            
            x = 0;
            
        } else {
            
            x = lastMarkBtn.xx;
            
        }
        
        //
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, w, 40) title:name backgroundColor:SWITCH_BACKGROUND_COLOR];
        [btn setTitleColor:NORMAL_TITLE_COLOR forState:UIControlStateNormal];
        [smallChooseView addSubview:btn];
        btn.tag = 1000 + i;
        btn.titleLabel.font = FONT(13);
        [btn addTarget:self action:@selector(smallChoose:) forControlEvents:UIControlEventTouchUpInside];
        //--
        [self.tagLbls addObject:btn];
        //记录上一次的btn
        lastMarkBtn = btn;
        
        if (i == typeNames.count - 1) {
            if (btn.xx > smallChooseView.width) {
                
                smallChooseView.contentSize = CGSizeMake(btn.xx, 40);
                
            } else {
                smallChooseView.contentSize = CGSizeMake(smallChooseView.width, 40);
            }
        }
        
        if (0 == i) {
            self.lasBtn = btn;
            [btn setTitleColor: SELECT_TITLE_COLOR forState:UIControlStateNormal];
            
        }
        
    }];
    
    
    //
    self.switchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, smallChooseView.yy, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - smallChooseView.bottom)];
    self.switchScrollView.delegate = self;
    self.switchScrollView.showsHorizontalScrollIndicator = NO;
    self.switchScrollView.pagingEnabled =  YES;
    [self.view addSubview:self.switchScrollView];
    self.switchScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * typeNames.count, self.switchScrollView.height);
    
    TLCustomerCategoryVC *vc = [[TLCustomerCategoryVC alloc] init];
    [self addChildViewController:vc];
    vc.status = self.statusRoom[0];
    vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.switchScrollView.height);
    [self.switchScrollView addSubview:vc.view];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    //--//
    //取出
    if ([self.isHaveChildVC[index] isEqualToNumber:@0]) {
        
        TLCustomerCategoryVC *defaultVC2 = [[TLCustomerCategoryVC alloc] init];
        [self addChildViewController:defaultVC2];
        defaultVC2.status = self.statusRoom[index];
        defaultVC2.view.frame = CGRectMake(SCREEN_WIDTH*index, 0, self.switchScrollView.width, self.switchScrollView.height);
        [self.switchScrollView addSubview:defaultVC2.view];
        self.isHaveChildVC[index] = @1;
        
    }
    
}


//#pragma mark- 操作上面
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //    //拖动结束
    if ([scrollView isEqual:self.smallChooseScrollView]) {
        
        //取出离中点最近的一个按钮
        
    } else {
        
        NSInteger index = (targetContentOffset -> x)/SCREEN_WIDTH;
        UIButton *currentBtn = (UIButton *)[self.smallChooseScrollView viewWithTag:1000 + index];
        if ([self.lasBtn isEqual:currentBtn]) {
            return;
        }
        
        [currentBtn setTitleColor:SELECT_TITLE_COLOR forState:UIControlStateNormal];
        [self.lasBtn setTitleColor:NORMAL_TITLE_COLOR forState:UIControlStateNormal];
        self.lasBtn = currentBtn;
        [self smallScroll:currentBtn];
        
    }
    
    
    
}


#pragma mark--上下联动相关,操作--上面--下面--动
- (void)smallChoose:(UIButton *)btn {
    
    if ([self.lasBtn isEqual:btn]) {
        return;
    }
    //下部改变
    [self.switchScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (btn.tag - 1000), 0) animated:NO];
    
    [self.lasBtn setTitleColor:NORMAL_TITLE_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:SELECT_TITLE_COLOR forState:UIControlStateNormal];
    self.lasBtn = btn;
    [self smallScroll:btn];
    
}

- (void)smallScroll:(UIButton *)btn {
    
    //宽度 和 内容宽度
    CGFloat w = self.smallChooseScrollView.width;
    //应当滚动的
    CGFloat  dValue =  btn.centerX - w/2.0;
    //最大滚动之
    CGFloat maxScrollContent = self.smallChooseScrollView.contentSize.width - self.smallChooseScrollView.bounds.size.width;
    
    CGPoint movePoint = CGPointMake(dValue, 0);
    if (dValue < 0) {
        movePoint = CGPointMake(0, 0);
    }
    
    if (dValue > maxScrollContent) {
        movePoint = CGPointMake(maxScrollContent, 0);
    }
    
    [self.smallChooseScrollView setContentOffset:movePoint animated:YES];
    
    
}


//- (BOOL)segmentSwitch:(NSInteger)idx {
//    
//    [self.switchScrollView setContentOffset:CGPointMake(idx * SCREEN_WIDTH, 0) animated:YES];
//    
//    if ([self.isAdd[idx] isEqual:@0]) {
//        
//        TLCustomerCategoryVC *vc = [[TLCustomerCategoryVC alloc] init];
//        [self addChildViewController:vc];
//        vc.view.frame = CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, self.switchScrollView.height);
//        [self.switchScrollView addSubview:vc.view];
//        
//        self.isAdd[idx] = @1;
//        
//    }
//    
//    return YES;
//    
//}

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
