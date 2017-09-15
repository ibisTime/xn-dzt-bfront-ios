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
#import "TLAlert.h"
#import "TLProgressHUD.h"

@interface TLMianLiaoChooseVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//
@property (nonatomic, strong) UICollectionView *mianLiaoCollectionView;
@property (nonatomic, strong) UITableView *leftTableView;

//
@property (nonatomic, strong) NSArray <NSString *>*mianLiaoArr;
@property (nonatomic, copy) NSArray <TLMianLiaoModel *>*mianLiaoRoom;

//
@property (nonatomic, strong) TLMianLiaoModel *currentMianLiaoModel;

//
@property (nonatomic, copy) NSArray < NSDictionary <NSString *, NSArray<TLMianLiaoModel *>*>*>  *mianLiaoAndTypeRoom;

@end

@implementation TLMianLiaoChooseVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}


- (void)tl_placeholderOperation {

    //根据产品查面料
    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *mianLiaoReq = [[NBCDRequest alloc] init];
    mianLiaoReq.code = @"620032";
    mianLiaoReq.parameters[@"modelSpecsCode"] = self.innnerProductCode;
    mianLiaoReq.parameters[@"status"] = @"1";
    [mianLiaoReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        [self removePlaceholderView];

        [TLProgressHUD dismiss];
        self.mianLiaoRoom = [TLMianLiaoModel tl_objectArrayWithDictionaryArray:request.responseObject[@"data"]];
        self.mianLiaoAndTypeRoom = @[
                                     @{@"80支棉" : self.mianLiaoRoom},
                                     @{@"100支棉" : self.mianLiaoRoom},
                                     @{@"棉真丝" : self.mianLiaoRoom},
                                     @{@"棉弹力" : self.mianLiaoRoom},
                                     
                                     ];
        
        
        [self setUpUI];
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

    } failure:^(__kindof NBBaseRequest *request) {
        [TLProgressHUD dismiss];
        [self addPlaceholderView];

    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择面料";
    self.mianLiaoArr = @[@"80支棉",@"100支棉",@"棉真丝",@"棉弹力",];
    
    //
    if (!self.innnerProductCode) {
        [TLAlert alertWithInfo:@"请传入产品编号"];
        return;
    }
    
    //
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];
    [self tl_placeholderOperation];
    
  
    
}

#pragma mark- 确定事件
- (void)confirm {
    
    if (!self.currentMianLiaoModel) {
        
        [TLAlert alertWithInfo:@"请选择面料"];
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishChooseWithMianLiaoModel:vc:)]) {
        
        [self.delegate didFinishChooseWithMianLiaoModel:self.currentMianLiaoModel vc:self];
        
    }

}

- (void)setUpUI {
    
    //
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.7)];
    topLineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:topLineView];
    


    //左类别tableView
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topLineView.yy, 100,SCREEN_HEIGHT - 64 ) style:UITableViewStylePlain];
    [self.view addSubview:leftTableView];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.leftTableView = leftTableView;
    
    //右CollectionView
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.minimumLineSpacing = 0;
    fl.minimumInteritemSpacing = 0;
    fl.itemSize = CGSizeMake((SCREEN_WIDTH - leftTableView.width)/3.0, 110);
    fl.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    //
    UICollectionView *orderDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(leftTableView.right, leftTableView.y,SCREEN_WIDTH - leftTableView.right, SCREEN_HEIGHT - 64 - 80) collectionViewLayout:fl];
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
        make.height.mas_equalTo(35);
    }];
    
    //注册
    [orderDetailCollectionView registerClass:[TLMianLiaoChooseCell class] forCellWithReuseIdentifier:[TLMianLiaoChooseCell cellReuseIdentifier] ];
    
  

}


#pragma mark- collectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self.mianLiaoRoom enumerateObjectsUsingBlock:^(TLMianLiaoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.isSelected = idx == indexPath.row;
        if (obj.isSelected) {
            self.currentMianLiaoModel = obj;
        }
        
    }];
    [collectionView reloadData];


}

#pragma mark- collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

   NSIndexPath *indexPath = [self.leftTableView indexPathForSelectedRow];
    
    NSDictionary *dict = self.mianLiaoAndTypeRoom[indexPath.row];
    NSArray *arr = dict[dict.allKeys[0]];
    
    return arr.count;

}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    TLMianLiaoChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TLMianLiaoChooseCell cellReuseIdentifier] forIndexPath:indexPath];
    
    NSIndexPath *tableViewSelectedIndexPath = [self.leftTableView indexPathForSelectedRow];
    NSDictionary *dict = self.mianLiaoAndTypeRoom[tableViewSelectedIndexPath.row];
    NSArray *arr = dict[dict.allKeys[0]];
    cell.mianLiaoModel = arr[indexPath.row];
    
    return cell;
    
}

#pragma mark- TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //切换数据类型，刷新右侧数据
    
    [self.mianLiaoCollectionView reloadData];

}

#pragma mark- TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.mianLiaoAndTypeRoom.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        cell.contentView.backgroundColor = cell.backgroundColor;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor themeColor];
//        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(cell.contentView);
//            make.left.equalTo(cell.contentView.mas_left).offset(10);
//            make.right.equalTo(cell.contentView.mas_right).offset(-10);
//        }];
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ImageUtil convertColorToImage:[UIColor whiteColor]]];
        
    }
    
    cell.textLabel.text = self.mianLiaoAndTypeRoom[indexPath.row].allKeys[0];
    
    return cell;
}

@end
