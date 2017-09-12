//
//  TLConfirmPriceVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLConfirmPriceVC.h"
#import "TLOrderParameterCell.h"
#import "TLOrderDataManager.h"
#import "TLOrderCollectionViewHeader.h"
#import "TLUIHeader.h"
#import "TLOrderBigTitleHeader.h"
#import "TLProgressHUD.h"
#import "NBNetwork.h"
#import "TLProduct.h"
#import "TLOrderModel.h"
#import "TLPriceHeaderView.h"
#import "TLGongYiChooseVC.h"
#import "TLAlert.h"
#import "TLButtonHeaderView.h"
#import "NSNumber+TLAdd.h"
#import "TLCalculatePriceManager.h"
#import "AppConfig.h"
#import "TLRefreshEngine.h"
#import "TLMianLiaoChooseVC.h"

@interface TLConfirmPriceVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate,TLPriceHeaderViewDelegate,TLButtonHeaderViewDelegate,TLGongYiChooseVCDelegate>

@property (nonatomic, strong)  TLOrderDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *orderDetailCollectionView;
@property (nonatomic, strong) NSMutableArray <TLProduct *>*productRoom;

@property (nonatomic, strong) NSMutableArray *currentArr;
@property (nonatomic, strong) NSMutableDictionary *currentDict;

//
@property (nonatomic, strong) TLProduct *currentProductModel;
@property (nonatomic, strong) TLCalculatePriceManager *calculatePriceManager;

//需要修改的组
@property (nonatomic, strong) TLGroup *gongYiPriceGroup;
@property (nonatomic, strong) TLGroup *totalPriceGroup;
//@property (nonatomic, strong) TLGroup *mianLiaoCountGroup;
@property (nonatomic, strong) TLGroup *mianLiaoDanJiaGroup;

//@property (nonatomic, strong) TLGroup *jiaGongPriceGroup;
//@property (nonatomic, strong) TLGroup *kuaiDiFeiGroup;
//@property (nonatomic, strong) TLGroup *baoZhuangFeiGroup;
//
//@property (nonatomic, assign) float kuaiDiFei;
//@property (nonatomic, assign) float baoZhuangFei;

@property (nonatomic, strong) TLGongYiChooseVC *gongYiChooseVC;

@end


@implementation TLConfirmPriceVC


- (TLGongYiChooseVC *)gongYiChooseVC {

    if (!_gongYiChooseVC) {
        
        _gongYiChooseVC = [[TLGongYiChooseVC alloc] init];
        //只能初始化的时候赋值
        _gongYiChooseVC.order = self.order;
    }
    
    return _gongYiChooseVC;

}

//
- (void)configModel {

    if (!self.productRoom || self.productRoom.count <= 0) {
        NSLog(@"必须有产品才能配置Model");
        return;
    }
    
    //
    CGSize headerBigSize = CGSizeMake(SCREEN_WIDTH, 75);
    CGSize headerMiddleSize = CGSizeMake(SCREEN_WIDTH, 45);
    CGSize headerSmallSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    //***********定制信息 ******************************//
    CGFloat horizonMargin = 18;
    CGFloat middleMargin = 15;
    UIEdgeInsets paramterEdgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);
    CGFloat parameterCellWidth = (SCREEN_WIDTH - paramterEdgeInsets.left * 2 - 2*horizonMargin)/3.0;
    
    //
    NSMutableArray *productMutableArr = [[NSMutableArray alloc] init];
    
        //前端从产品界面进入，预约的时候已经有产品
        [self.productRoom enumerateObjectsUsingBlock:^(TLProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ( (self.order.productList && self.order.productList.count > 0) && [self.order.productList[0].modelCode isEqualToString:obj.code]) {

                TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                parameterModel.code = obj.code;
                parameterModel.name = obj.name;
                parameterModel.pic = obj.advPic;
                parameterModel.yuSelected = YES;
                parameterModel.isSelected = YES;
                [productMutableArr addObject:parameterModel];
                self.currentProductModel = obj;
                
            } else {
            
                TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                parameterModel.code = obj.code;
                parameterModel.name = obj.name;
                parameterModel.pic = obj.advPic;
                [productMutableArr addObject:parameterModel];
            }
      
            
        }];
 
    
    //
    TLGroup *productGroup = [[TLGroup alloc] init];
    productGroup.canEdit =  YES;
    productGroup.editting = YES;
    productGroup.dataModelRoom = productMutableArr;
    [self.dataManager.groups addObject:productGroup];
    productGroup.title =  @"请选择产品";
    productGroup.content = self.order.modelName ?  : nil;

    productGroup.headerSize = headerSmallSize;
    productGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    productGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    productGroup.minimumLineSpacing = horizonMargin;
    productGroup.minimumInteritemSpacing = middleMargin;
    productGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    productGroup.editingEdgeInsets = paramterEdgeInsets;
    productGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //面料单耗
//    TLGroup *mianLiaoXiaoHaoGroup = [[TLGroup alloc] init];
//    self.mianLiaoCountGroup = mianLiaoXiaoHaoGroup;
//    mianLiaoXiaoHaoGroup.canEdit = NO;
//    mianLiaoXiaoHaoGroup.content =  @"0";
//    mianLiaoXiaoHaoGroup.dataModelRoom = [NSMutableArray new];
//    [self.dataManager.groups addObject:mianLiaoXiaoHaoGroup];
//    mianLiaoXiaoHaoGroup.title = @"面料单耗";
//    mianLiaoXiaoHaoGroup.headerSize = headerSmallSize;
//    mianLiaoXiaoHaoGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
//    mianLiaoXiaoHaoGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
//    mianLiaoXiaoHaoGroup.minimumLineSpacing = horizonMargin;
//    mianLiaoXiaoHaoGroup.minimumInteritemSpacing = middleMargin;
//    mianLiaoXiaoHaoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
//    mianLiaoXiaoHaoGroup.editingEdgeInsets = paramterEdgeInsets;
//    mianLiaoXiaoHaoGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //加工费
//    TLGroup *jiaGongPriceGroup = [[TLGroup alloc] init];
//    self.jiaGongPriceGroup = jiaGongPriceGroup;
//    jiaGongPriceGroup.canEdit = NO;
//    jiaGongPriceGroup.content =  @"0";
//    jiaGongPriceGroup.dataModelRoom = [NSMutableArray new];
//    [self.dataManager.groups addObject:jiaGongPriceGroup];
//    jiaGongPriceGroup.title = @"加工费";
//    jiaGongPriceGroup.headerSize = headerSmallSize;
//    jiaGongPriceGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
//    jiaGongPriceGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
//    jiaGongPriceGroup.minimumLineSpacing = horizonMargin;
//    jiaGongPriceGroup.minimumInteritemSpacing = middleMargin;
//    jiaGongPriceGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
//    jiaGongPriceGroup.editingEdgeInsets = paramterEdgeInsets;
//    jiaGongPriceGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //快递费
//    TLGroup *kuaiDiPriceGroup = [[TLGroup alloc] init];
//    kuaiDiPriceGroup.canEdit = NO;
//    self.kuaiDiFeiGroup = kuaiDiPriceGroup;
//    kuaiDiPriceGroup.dataModelRoom = [NSMutableArray new];
//    [self.dataManager.groups addObject:kuaiDiPriceGroup];
//    kuaiDiPriceGroup.title = @"快递费";
//    kuaiDiPriceGroup.content =  @"0";
//    kuaiDiPriceGroup.headerSize = headerSmallSize;
//    kuaiDiPriceGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
//    kuaiDiPriceGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
//    kuaiDiPriceGroup.minimumLineSpacing = horizonMargin;
//    kuaiDiPriceGroup.minimumInteritemSpacing = middleMargin;
//    kuaiDiPriceGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
//    kuaiDiPriceGroup.editingEdgeInsets = paramterEdgeInsets;
//    kuaiDiPriceGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //包装费
//    TLGroup *baoZhuangPriceGroup = [[TLGroup alloc] init];
//    baoZhuangPriceGroup.canEdit = NO;
//    self.baoZhuangFeiGroup = baoZhuangPriceGroup;
//    baoZhuangPriceGroup.dataModelRoom = [NSMutableArray new];
//    [self.dataManager.groups addObject:baoZhuangPriceGroup];
//    baoZhuangPriceGroup.title = @"包装费";
//    baoZhuangPriceGroup.content =  @"0";
//    baoZhuangPriceGroup.headerSize = headerSmallSize;
//    baoZhuangPriceGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
//    baoZhuangPriceGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
//    baoZhuangPriceGroup.minimumLineSpacing = horizonMargin;
//    baoZhuangPriceGroup.minimumInteritemSpacing = middleMargin;
//    baoZhuangPriceGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
//    baoZhuangPriceGroup.editingEdgeInsets = paramterEdgeInsets;
//    baoZhuangPriceGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //工艺费
    TLGroup *gongYiPriceGroup = [[TLGroup alloc] init];
    self.gongYiPriceGroup = gongYiPriceGroup;
    gongYiPriceGroup.canEdit = YES;
    gongYiPriceGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:gongYiPriceGroup];
    gongYiPriceGroup.title = @"工艺费";
    gongYiPriceGroup.content =  @"0";
    gongYiPriceGroup.headerSize = headerSmallSize;
    gongYiPriceGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    gongYiPriceGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
    gongYiPriceGroup.minimumLineSpacing = horizonMargin;
    gongYiPriceGroup.minimumInteritemSpacing = middleMargin;
    gongYiPriceGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    gongYiPriceGroup.editingEdgeInsets = paramterEdgeInsets;
    gongYiPriceGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    
    //面料单价
    TLGroup *mianLiaoDanJiaGroup = [[TLGroup alloc] init];
    self.mianLiaoDanJiaGroup = mianLiaoDanJiaGroup;
    mianLiaoDanJiaGroup.canEdit = YES;
    mianLiaoDanJiaGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:mianLiaoDanJiaGroup];
    mianLiaoDanJiaGroup.title = @"面料费";
    mianLiaoDanJiaGroup.content =  @"0";
    mianLiaoDanJiaGroup.headerSize = headerSmallSize;
    mianLiaoDanJiaGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    mianLiaoDanJiaGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
    mianLiaoDanJiaGroup.minimumLineSpacing = horizonMargin;
    mianLiaoDanJiaGroup.minimumInteritemSpacing = middleMargin;
    mianLiaoDanJiaGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    mianLiaoDanJiaGroup.editingEdgeInsets = paramterEdgeInsets;
    mianLiaoDanJiaGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //总价
    TLGroup *zongJiaGroup = [[TLGroup alloc] init];
    self.totalPriceGroup = zongJiaGroup;
    zongJiaGroup.canEdit = NO;
    zongJiaGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:zongJiaGroup];
    zongJiaGroup.title = @"总价";
    zongJiaGroup.content =  @"0";
    zongJiaGroup.headerSize = headerSmallSize;
    zongJiaGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    zongJiaGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
    zongJiaGroup.minimumLineSpacing = horizonMargin;
    zongJiaGroup.minimumInteritemSpacing = middleMargin;
    zongJiaGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    zongJiaGroup.editingEdgeInsets = paramterEdgeInsets;
    zongJiaGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //确定按钮
    TLGroup *confirmBtnGroup = [[TLGroup alloc] init];
    confirmBtnGroup.canEdit = NO;
    confirmBtnGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:confirmBtnGroup];
    
    confirmBtnGroup.title = @"确定";
    confirmBtnGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 80);
    confirmBtnGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    confirmBtnGroup.headerReuseIdentifier = [TLButtonHeaderView headerReuseIdentifier];
    confirmBtnGroup.minimumLineSpacing = horizonMargin;
    confirmBtnGroup.minimumInteritemSpacing = middleMargin;
    confirmBtnGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    confirmBtnGroup.editingEdgeInsets = paramterEdgeInsets;
    confirmBtnGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
}

#pragma mark- PriceHeaderDelegate
- (void)didSelected:(NSInteger)section {

    @try {
        
        
        if (section == 1) {
            
            __block TLParameterModel *currentChooseModel = nil;
            [self.dataManager.groups[0].dataModelRoom enumerateObjectsUsingBlock:^(TLParameterModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj.isSelected) {
                    
                    currentChooseModel = obj;
                    
                }
            }];
            
            if (!currentChooseModel) {
                
                [TLAlert alertWithMsg:@"请选择产品"];
            }
            
            
            //需要处理工艺
//            TLGongYiChooseVC *vc = [[TLGongYiChooseVC alloc] init];
            //需要确定的
            self.gongYiChooseVC.delegate = self;
            self.gongYiChooseVC.productCode = currentChooseModel.code;
            
            [self.navigationController pushViewController:self.gongYiChooseVC animated:YES];
            
        }
        
        
        if (section == 2) {
            //面料选择
            
            TLMianLiaoChooseVC *mianLiaoChooseVC =  [[TLMianLiaoChooseVC alloc] init];
            [self.navigationController pushViewController:mianLiaoChooseVC animated:YES];
            
        }

        
    } @catch (NSException *exception) {
        
        [TLAlert alertWithMsg:exception.name];
        
    } @finally {
        
        
    }
    
}


- (void)registerClass {
    
    if (!self.orderDetailCollectionView) {
        NSLog(@"请先创建collectonView");
        return;
    }
    
     //Header
    [self.orderDetailCollectionView registerClass:[TLButtonHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLButtonHeaderView headerReuseIdentifier]];
    
    //
    [self.orderDetailCollectionView registerClass:[TLOrderCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLOrderCollectionViewHeader headerReuseIdentifier]];
    
    //
    [self.orderDetailCollectionView registerClass:[TLPriceHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLPriceHeaderView headerReuseIdentifier]];
    
    //Cell
    [self.orderDetailCollectionView registerClass:[TLOrderParameterCell class] forCellWithReuseIdentifier:[TLOrderParameterCell cellReuseIdentifier]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"定价";
    self.view.backgroundColor = [UIColor whiteColor];
    self.calculatePriceManager = [[TLCalculatePriceManager alloc] init];
    
    [TLProgressHUD showWithStatus:nil];
//    NBCDRequest *kuaiDiReq2 = [[NBCDRequest alloc] init];
//    kuaiDiReq2.code = @"620918";
//    kuaiDiReq2.parameters[@"keyList"] = @[@"KDF",@"BZF"]; ;
//    kuaiDiReq2.parameters[@"companyCode"] = [AppConfig config].systemCode;
//    kuaiDiReq2.parameters[@"systemCode"] = [AppConfig config].systemCode;
    
    //获取产品列表
    NBCDRequest *xhReq = [[NBCDRequest alloc] init];
    xhReq.code = @"620012";
    xhReq.parameters[@"status"] = @"1";
    
    //
    NBCDRequest *orderReq = [[NBCDRequest alloc] init];
    orderReq.code = @"620234";
    orderReq.parameters[@"code"] = self.order.code;
    
    //
    NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[xhReq,orderReq]];
    [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
        
        //
        [TLProgressHUD dismiss];
//        NBCDRequest *kuaiDiReq2 = (NBCDRequest *)batchRequest.reqArray[0];
        
        NBCDRequest *xhReq = (NBCDRequest *)batchRequest.reqArray[0];
        NBCDRequest *orderReq = (NBCDRequest *)batchRequest.reqArray[1];

        TLOrderModel *orderModel = [TLOrderModel tl_objectWithDictionary:orderReq.responseObject[@"data"]];
        self.order = orderModel;
        self.calculatePriceManager.times = [orderModel.times floatValue];
        //
//        self.baoZhuangFei = [kuaiDiReq2.responseObject[@"data"][@"BZF"] floatValue];
//        self.kuaiDiFei = [kuaiDiReq2.responseObject[@"data"][@"KDF"] floatValue];
        //
        NSArray *arr = xhReq.responseObject[@"data"];
        self.productRoom =  [TLProduct tl_objectArrayWithDictionaryArray:arr];
        //
        self.dataManager = [[TLOrderDataManager alloc] init];
        self.dataManager.order = self.order;
        
        //
        [self setUpUI];
        [self registerClass];
        [self configModel];
        [self chooseProductAfter];
        
    } failure:^(NBBatchReqest *batchRequest) {
        [TLProgressHUD dismiss];
        
    }];
    
    
}

#pragma mark- 选择工艺Delegate

- (void)didFinishChooseWith:(NSMutableArray *)arr dict:(NSMutableDictionary *)dict gongYiPrice:(float)gongYiPrice mianLiaoPrice:(float)mianLiaoPrice vc:(UIViewController *)vc {

    self.currentArr = arr;
    self.currentDict = dict;
    
        //已经选择了产品
        if (self.currentProductModel.productType == TLProductTypeChenShan) {
            //为衬衫 价格置0
            [self chooseChenShanChangePrice];
            
        } else {
        
            //为衬衫 H+ 进行价格计算
            self.calculatePriceManager.mianLiaoPrice = mianLiaoPrice;
            self.calculatePriceManager.gongYiPrice = gongYiPrice;
            //获取快递 和 包装费
//            self.calculatePriceManager.kuaiDiPrice = self.kuaiDiFei;
//            self.calculatePriceManager.baoZhuangPrice = self.baoZhuangFei;
            //计算价格 -------- 选择产品后需要计算，改变公益后需要计算
            float totalPrice = [self.calculatePriceManager calculate];
            
            //改变数据模型
            self.gongYiPriceGroup.content = [NSString stringWithFormat:@"%.2f",gongYiPrice];
            self.totalPriceGroup.content = [NSString stringWithFormat:@"%.2f",totalPrice];
            
            self.mianLiaoDanJiaGroup.content = [NSString stringWithFormat:@"%.2f",mianLiaoPrice];
            //刷新数据
            [self.orderDetailCollectionView reloadData];
        
        }

    [self.orderDetailCollectionView reloadData];
    [vc.navigationController popViewControllerAnimated:YES];

}



#pragma mark- TLButtonHeaderView delegate 代理方法
- (void)didSelected:(TLButtonHeaderView *)btnHeaderView section:(NSInteger)secction {

    if (self.currentProductModel && self.currentProductModel.productType == TLProductTypeChenShan) {
        //衬衫定价
        NBCDRequest *req = [[NBCDRequest alloc] init];
        req.code = @"620203";
        req.parameters[@"modelCode"] = self.currentProductModel.code;
        req.parameters[@"orderCode"] = self.order.code;
        req.parameters[@"quantity"] = @"1";
        req.parameters[@"updater"] = [TLUser user].userId;
        [req startWithSuccess:^(__kindof NBBaseRequest *request) {
            
            [TLAlert alertWithSucces:@"定价成功"];
            [TLRefreshEngine engine].refreshTag = 10;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(__kindof NBBaseRequest *request) {
            
        }];
        return;
    }
    //统一改为都要选择工艺
    

    //h+ 定价
    if(!self.currentDict) {
    
        [TLAlert alertWithMsg:@"请选择工艺"];
        return;
    }
    
    
    NBCDRequest *req = [[NBCDRequest alloc] init];
//    NSMutableArray *otherArr = [[NSMutableArray alloc] init];
    
    req.code = @"620205";
    req.parameters[@"map"] = self.currentDict;
    req.parameters[@"orderCode"] = self.order.code;
    req.parameters[@"quantity"] = @"1";
    req.parameters[@"updater"] = [TLUser user].userId;    
    __block TLParameterModel *currentChooseModel = nil;
    [self.dataManager.groups[0].dataModelRoom enumerateObjectsUsingBlock:^(TLParameterModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isSelected) {
            
            currentChooseModel = obj;
            
        }
    }];
    
    if (!currentChooseModel) {
        
        [TLAlert alertWithMsg:@"请选择产品"];
    }

    [self.currentArr addObject:currentChooseModel.code];
    req.parameters[@"codeList"] = self.currentArr;

    [TLProgressHUD showWithStatus:nil];
    [req startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        [TLProgressHUD dismiss];
        [TLAlert alertWithSucces:@"定价成功"];
        [TLRefreshEngine engine].refreshTag = 10;
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(__kindof NBBaseRequest *request) {
        [TLProgressHUD dismiss];

    }];

    
}

- (void)setUpUI {
    
    //
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.minimumLineSpacing = 0;
    fl.minimumInteritemSpacing = 0;
    
    //
    UICollectionView *orderDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:fl];
    [self.view addSubview:orderDetailCollectionView];
    self.orderDetailCollectionView = orderDetailCollectionView;
    
    orderDetailCollectionView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    orderDetailCollectionView.delegate = self;
    orderDetailCollectionView.dataSource = self;
    //
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //产品选择
    NSMutableArray <TLParameterModel *>*models = self.dataManager.groups[indexPath.section].dataModelRoom;
    [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.yuSelected = idx == indexPath.row;
        
        
    }];
    
    [UIView animateWithDuration:0 animations:^{
        [self.orderDetailCollectionView  performBatchUpdates:^{
            [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            
        } completion:nil];
    }];
    
    
    
}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.dataManager.groups[indexPath.section].itemSize;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return self.dataManager.groups[section].edgeInsets;
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.dataManager.groups[section].minimumLineSpacing;
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section  {
    
    return self.dataManager.groups[section].minimumInteritemSpacing;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return self.dataManager.groups[section].headerSize;
    
}

- (void)chooseChenShanChangePrice {

    self.gongYiPriceGroup.content = @"0";
    self.totalPriceGroup.content = [self.currentProductModel.price convertToRealMoney];
    
//    self.mianLiaoCountGroup.content = @"0";
//    self.mianLiaoDanJiaGroup.content = @"0";
//    self.jiaGongPriceGroup.content = @"0";
//    self.kuaiDiFeiGroup.content =  @"0";
//    self.baoZhuangFeiGroup.content = @"0";

}

#pragma mark- 必须在配置完 模型 和 产品之后调用
- (void)chooseProductAfter {

    if (!self.currentProductModel) {
        
        NSLog(@"还未选择产品");
        return;
        
    }
    //产品切换，把数据清除掉
    self.gongYiChooseVC = nil;
    self.currentArr = nil;
    self.currentDict = nil;
    
    //
//    if ( self.currentProductModel.productType == TLProductTypeHAdd) {
    
        //工艺是否可编辑
        self.gongYiPriceGroup.canEdit = YES;
        
        //改变面料单消耗
//        self.mianLiaoCountGroup.content = [NSString stringWithFormat:@"%@",self.currentProductModel.loss];
        self.calculatePriceManager.mianLiaoCount = [self.currentProductModel.loss floatValue];
        
        //是否有面料费
        if (self.order.resultMap && self.order.resultMap.DINGZHI && self.order.resultMap.DINGZHI[@"1-02"]) {
            NSDictionary *dict =  self.order.resultMap.DINGZHI[@"1-02"];
            self.mianLiaoDanJiaGroup.content = [dict[@"price"] convertToRealMoney];
            
        }
        
        //改变加工费
//        self.jiaGongPriceGroup.content = [NSString stringWithFormat:@"%@",[self.currentProductModel.processFee convertToRealMoney]];
    
//        self.calculatePriceManager.jiaGongPrice = [[self.currentProductModel.processFee convertToRealMoney] floatValue];
        //
//        self.kuaiDiFeiGroup.content = [NSString stringWithFormat:@"%.2f",self.kuaiDiFei];
//        self.baoZhuangFeiGroup.content = [NSString stringWithFormat:@"%.2f",self.baoZhuangFei];
//        self.calculatePriceManager.kuaiDiPrice = self.kuaiDiFei;
//        self.calculatePriceManager.baoZhuangPrice = self.baoZhuangFei;
    
        self.totalPriceGroup.content = @"0";

//    } else {
//        //选择的为衬衫
//        //工艺是否可编辑
//        self.gongYiPriceGroup.canEdit = NO;
//        [self chooseChenShanChangePrice];
//    }

}

#pragma mark-  TLOrderEditHeaderDelegate
- (void)actionWithView:(TLOrderCollectionViewHeader *)reusableView type:(EditType)type {
    
    switch (type) {
        case EditTypeGoEdit: {
            [reusableView editing];
            
            TLGroup *group = self.dataManager.groups[reusableView.section];
            group.editting = YES;
            [UIView animateWithDuration:0 animations:^{
                [self.orderDetailCollectionView  performBatchUpdates:^{
                    [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];
                    
                } completion:nil];
            }];
            
        } break;
            
        case EditTypeConfirm: {
            [reusableView edited];
            
            self.dataManager.groups[reusableView.section].editting = NO;
            
            TLGroup *group = self.dataManager.groups[reusableView.section];
            
                //以下是选择
                NSMutableArray <TLParameterModel *>*models =  group.dataModelRoom;
                [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.yuSelected) {
                        
                        obj.isSelected = YES;
                        group.content = obj.name;
                        //
                        TLProduct *currentProduct = self.productRoom[idx];
                        //当前选中的_产品
                        self.currentProductModel = currentProduct;

                        [self chooseProductAfter];
                        
                    } else {
                        
                        obj.isSelected = NO;
                        
                    }
                    
                }];
                            
            //
            [UIView animateWithDuration:0 animations:^{
                
                [self.orderDetailCollectionView  reloadData];
                
            }];
            
        } break;
            
        case EditTypeCancle: {
            [reusableView edited];
            
            self.dataManager.groups[reusableView.section].editting = NO;
            [UIView animateWithDuration:0 animations:^{
                [self.orderDetailCollectionView  performBatchUpdates:^{
                    [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];
                    
                } completion:nil];
            }];
            
        } break;
            
    }
    
}




#pragma mark- UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
 
    NSString *reuseIdentifier = self.dataManager.groups[indexPath.section].headerReuseIdentifier;
    
    id header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                   withReuseIdentifier:reuseIdentifier
                                                          forIndexPath:indexPath];
    
    if ([header isKindOfClass:[ TLOrderCollectionViewHeader class]]) {
        
        TLOrderCollectionViewHeader *trueHeader = header;
        trueHeader.delegate = self;
        trueHeader.section = indexPath.section;
        trueHeader.contentLbl.font = [UIFont systemFontOfSize:14];
        trueHeader.titleLbl.font = trueHeader.contentLbl.font;
        trueHeader.group = self.dataManager.groups[indexPath.section];
        
    } else if ([header isKindOfClass:[TLPriceHeaderView class]]) {
        
        TLPriceHeaderView *trueHeader = header;
        trueHeader.section = indexPath.section;
        trueHeader.delegate = self;
        trueHeader.group = self.dataManager.groups[indexPath.section];
        
    } else if ([header isKindOfClass:[TLButtonHeaderView class]]) {
    
        
        TLButtonHeaderView *trueHeader = header;
        trueHeader.section = indexPath.section;
        trueHeader.delegate = self;
        trueHeader.title = self.dataManager.groups[indexPath.section].title;
        
    
        
    }
    return header;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataManager.groups[section].itemCount;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = self.dataManager.groups[indexPath.section].cellReuseIdentifier;
    TLOrderBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                      forIndexPath:indexPath];
    
    cell.model = self.dataManager.groups[indexPath.section].dataModelRoom[indexPath.row];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataManager.groups.count;
    
}


@end
