//
//  TLMianLiaoChooseVC.m
//  CustomB
//
//  Created by  tianlei on 2017/9/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMianLiaoChooseVC.h"
#import "TLUIHeader.h"
#import "TLMianLiaoChooseCell.h"
#import <CDCommon/UIView+Frame.h>
#import <NBHTTP/NBNetwork.h>
#import <CDCommon/ImageUtil.h>
#import "TLMianLiaoModel.h"

@interface TLMianLiaoChooseVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray <NSString *>*mianLiaoArr;
@property (nonatomic, copy) NSArray <TLMianLiaoModel *>*mianLiaoRoom;

@property (nonatomic, strong) UICollectionView *mianLiaoCollectionView;

@end

@implementation TLMianLiaoChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mianLiaoArr = @[@"80支棉",@"100支棉",@"棉真丝",@"棉弹力",];
    self.title = @"选择面料";
    
    
    NBCDRequest *mianLiaoReq = [[NBCDRequest alloc] init];
    mianLiaoReq.code = @"620032";
    mianLiaoReq.parameters[@"modelCode"] = self.productCode;
    mianLiaoReq.parameters[@"status"] = @"1";
    [mianLiaoReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        self.mianLiaoRoom = [TLMianLiaoModel tl_objectArrayWithDictionaryArray:request.responseObject[@"data"]];
        
        [self setUpUI];
        
    } failure:^(__kindof NBBaseRequest *request) {
        
        
    }];
    
  
    
}

#pragma mark- 确定事件
- (void)confirm {


}

- (void)setUpUI {

    //左类别tableView
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100,SCREEN_HEIGHT - 64 ) style:UITableViewStylePlain];
    [self.view addSubview:leftTableView];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    //右CollectionView
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.minimumLineSpacing = 0;
    fl.minimumInteritemSpacing = 0;
    fl.itemSize = CGSizeMake((SCREEN_WIDTH - leftTableView.width)/3.0, 110);
    fl.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    //
    UICollectionView *orderDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(leftTableView.right, 0,SCREEN_WIDTH - leftTableView.right, SCREEN_HEIGHT - 64 - 80) collectionViewLayout:fl];
    [self.view addSubview:orderDetailCollectionView];
    self.mianLiaoCollectionView = orderDetailCollectionView;
    orderDetailCollectionView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    orderDetailCollectionView.delegate = self;
    orderDetailCollectionView.dataSource = self;
    orderDetailCollectionView.backgroundColor = [UIColor whiteColor];
    
    //
    UIButton *confirmBtn = [[UIButton alloc] init];
    [self.view addSubview:confirmBtn];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.backgroundColor = [UIColor themeColor];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    confirmBtn.titleLabel.font = FONT(14);
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mianLiaoCollectionView.mas_bottom).offset(20);
        make.left.equalTo(self.mianLiaoCollectionView.mas_left).offset(20);
        make.right.equalTo(self.mianLiaoCollectionView.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    //注册
    [orderDetailCollectionView registerClass:[TLMianLiaoChooseCell class] forCellWithReuseIdentifier:[TLMianLiaoChooseCell cellReuseIdentifier] ];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
    });

}


#pragma mark- collectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self.mianLiaoRoom enumerateObjectsUsingBlock:^(TLMianLiaoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.isSelected = idx == indexPath.row;
        
    }];
    [collectionView reloadData];


}

#pragma mark- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.mianLiaoRoom.count;

}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TLMianLiaoChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TLMianLiaoChooseCell cellReuseIdentifier] forIndexPath:indexPath];
    
    cell.mianLiaoModel = self.mianLiaoRoom[indexPath.row];
    return cell;
    
}

#pragma mark- TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.mianLiaoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        cell.contentView.backgroundColor = cell.backgroundColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor themeColor];
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView.mas_left).offset(10);
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
        }];
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ImageUtil convertColorToImage:[UIColor whiteColor]]];
        //
//        UIView *line = [[UIView alloc] init];
//        line.backgroundColor = [UIColor themeColor];
//        [cell.contentView addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(cell.contentView.mas_left).offset(0);
//            make.right.equalTo(cell.contentView.mas_right).offset(0);
//            make.height.mas_equalTo(0.7);
//            make.bottom.equalTo(cell.contentView.mas_bottom);
//        }];
        
    }
    
    cell.textLabel.text = self.mianLiaoArr[indexPath.row];
    return cell;
}

@end
