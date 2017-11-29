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
#import "TLMianLiaoModel.h"
#import "TLGuiGeXiaoLei.h"
#import "UIScrollView+TLAdd.h"
#import "TLOrderBigTitleHeader.h"
#import "TLCiXiuTextInputCell.h"


#define MIAN_LIAO_MARK @"MIAN_LIAO_MARK"
#define GONG_YI_MARK @"GONG_YI_MARK"


#define HEADER_SIZE CGSizeMake(SCREEN_WIDTH, 45)
@interface TLConfirmPriceVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate,TLPriceHeaderViewDelegate,TLButtonHeaderViewDelegate,TLGongYiChooseVCDelegate,TLMianLiaoChooseVCDelegate>

@property (nonatomic, strong) TLOrderDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *confirmPriceCollectionView;
@property (nonatomic, strong) NSMutableArray <TLProduct *>*productRoom;

@property (nonatomic, strong) TLProduct *currentProductModel;
@property (nonatomic, strong) TLCalculatePriceManager *calculatePriceManager;

// 固定group
@property (nonatomic, strong) TLGroup *productGroup;
@property (nonatomic, strong) TLGroup *confirmBtnGroup;
@property (nonatomic, strong) TLGroup *totalPriceGroup;

@property (nonatomic, strong) TLGroup *receiveAddressGroup;
@property (nonatomic, strong) TLGroup *remarkGroup;
@property (nonatomic, strong) TLGroup *dingJiaRuleGroup;

@property (nonatomic, assign) float times;

@end


@implementation TLConfirmPriceVC

#pragma mark- 面料选择 TLMianLiaoChooseVCDelegate
- (void)didFinishChooseWithMianLiaoModel:(TLMianLiaoModel *)mianLiaoModel vc:(UIViewController *)vc {
    
    //回来的时候，判断是哪个的面料
    [vc.navigationController popViewControllerAnimated:YES];
    
    //哪个产品的面料
    __block TLInnerProduct *innerProduct = nil;
    [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.code isEqualToString:mianLiaoModel.modelSpecsCode]) {
            //是该产品的model
            innerProduct = obj;
            obj.mianLiaoModel = mianLiaoModel;
            *stop = YES;
        }
        
    }];
    
    if (!innerProduct) {
        [TLAlert alertWithInfo:@"innerProduct 不应该为空"];
        return;
    }
    
    //根据找出了面料对应的产品,进行价格刷新
    [self.dataManager.groups enumerateObjectsUsingBlock:^(TLGroup * _Nonnull mianLiaoPriceGroup, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (mianLiaoPriceGroup.mark && [mianLiaoPriceGroup.mark isEqualToString:MIAN_LIAO_MARK] && [mianLiaoPriceGroup.dateModel isEqual:innerProduct]) {
            //找出面料的group
            mianLiaoPriceGroup.content = [NSString stringWithFormat:@"￥%@",[mianLiaoModel.price convertToRealMoney]];
            *stop = YES;
            [self.confirmPriceCollectionView reloadData];
        }
        
    }];
    
    [self calculateTotalPriceWhenCan];
    
}


#pragma mark- 选择工艺Delegate
- (void)didFinishChooseWith:(NSMutableArray <TLGuiGeXiaoLei *> *)arr ciXiuDict:(NSDictionary *)ciXiuDict  vc:(UIViewController *)vc {
    
    [vc.navigationController popViewControllerAnimated:YES];

    if (arr.count <= 0) {
        [TLAlert alertWithInfo:@"该产品还未添加工艺"];
        return;
    }
    
    //哪个产品的工艺
    __block TLInnerProduct *innerProduct = nil;
    [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.code isEqualToString:arr[0].modelSpecsCode]) {
            //是该产品的model
            innerProduct = obj;
            *stop = YES;
        }
        
    }];
    
    if (!innerProduct) {
        [TLAlert alertWithInfo:@"innerProduct 不应该为空"];
        return;
    }
    
    //
    innerProduct.ciXiuDict = ciXiuDict;
    innerProduct.guiGeXiaoLeiRoom = arr;
    
    //计算价格
    
    //改变group价格
    //根据找出了面料对应的产品,进行价格刷新
    [self.dataManager.groups enumerateObjectsUsingBlock:^(TLGroup * _Nonnull gongYiGroup, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (gongYiGroup.mark && [gongYiGroup.mark isEqualToString:GONG_YI_MARK] && [gongYiGroup.dateModel isEqual:innerProduct]) {
            //找出面料的group
            
            gongYiGroup.content = [NSString stringWithFormat:@"￥%.2f",[innerProduct calculateGongYiPrice]];
            *stop = YES;
            [self.confirmPriceCollectionView reloadData];
        }
        
    }];
    
    [self calculateTotalPriceWhenCan];

}

#pragma mark- 每次选择后判断是否要进行总价计算 —— 当然是在合适的时候
- (void)calculateTotalPriceWhenCan {

    @try {
        
        // 大类下可能，有多个小件
        [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
//            if (!obj.mianLiaoModel || obj.guiGeXiaoLeiRoom.count <= 0) {
//
//                @throw [NSException exceptionWithName:@"暂时不能计算" reason:nil userInfo:nil];
//
//            }
            
            //2.0.2 工艺默认为 0
            if (!obj.mianLiaoModel) {
                
                @throw [NSException exceptionWithName:@"暂时不能计算" reason:nil userInfo:nil];
                
            }
            
        }];
        
        //都选择了
        __block float totalPrice = 0;
        [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //添加每个产品的 价格
            totalPrice +=  [obj calculateTotalPrice];
            
        }];
        
        if (self.currentProductModel.productType == TLProductTypeHAdd) {
            // 会员价只针对
            if ([self.order isVipOrder]) {
                
                //会员价乘 -- 0.7
                totalPrice = self.times*totalPrice;
                //
            }
            
        }
        
        self.totalPriceGroup.content = [NSString stringWithFormat:@"￥%.2f",totalPrice];
        [self.confirmPriceCollectionView reloadData];
        
        //
    } @catch (NSException *exception) {
        
        //
    } @finally {
        
    }
    
}


- (void)configModel {

    if (!self.productRoom || self.productRoom.count <= 0) {
        NSLog(@"必须有产品才能配置Model");
        return;
    }
    
    //
//    CGSize headerBigSize = CGSizeMake(SCREEN_WIDTH, 75);
//    CGSize headerMiddleSize = CGSizeMake(SCREEN_WIDTH, 45);
    CGSize headerSmallSize = HEADER_SIZE;
    
    //***********定制信息 ******************************//
    CGFloat horizonMargin = 18;
    CGFloat middleMargin = 0;
    UIEdgeInsets paramterEdgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);
    CGFloat parameterCellWidth = (SCREEN_WIDTH - paramterEdgeInsets.left * 2 - 2*horizonMargin)/3.0;
    
    //
    NSMutableArray *productMutableArr = [[NSMutableArray alloc] init];
    
    //前端从产品界面进入，预约的时候已经有产品
    [self.productRoom enumerateObjectsUsingBlock:^(TLProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
        parameterModel.code = obj.code;
        parameterModel.name = obj.name;
        parameterModel.pic = obj.pic;
        [productMutableArr addObject:parameterModel];
        
    }];
    
    //
    TLGroup *productGroup = [[TLGroup alloc] init];
    self.productGroup = productGroup;
    productGroup.canEdit =  YES;
    productGroup.editting = YES;
    productGroup.dataModelRoom = productMutableArr;
    [self.dataManager.groups addObject:productGroup];
    productGroup.title =  @"定制产品";
    productGroup.content = self.order.modelName ?  : nil;
    productGroup.headerSize = headerSmallSize;
    productGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    productGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    productGroup.minimumLineSpacing = horizonMargin;
    productGroup.minimumInteritemSpacing = middleMargin;
    productGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    productGroup.editingEdgeInsets = paramterEdgeInsets;
    productGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth + TLOrderParameterCellBottomH);
    
    //总价
    TLGroup *zongJiaGroup = [[TLGroup alloc] init];
    self.totalPriceGroup = zongJiaGroup;
    zongJiaGroup.canEdit = NO;
    zongJiaGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:zongJiaGroup];
    if ([self.order isVipOrder]) {
        
        zongJiaGroup.title = @"会员价";

    } else {
        
        zongJiaGroup.title = @"售价";
        
    }
    zongJiaGroup.content =  @"--";
    zongJiaGroup.headerSize = headerSmallSize;
    zongJiaGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    zongJiaGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
    zongJiaGroup.minimumLineSpacing = horizonMargin;
    zongJiaGroup.minimumInteritemSpacing = middleMargin;
    zongJiaGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    zongJiaGroup.editingEdgeInsets = paramterEdgeInsets;
    zongJiaGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
   
    //
    TLGroup *receiveGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:receiveGroup];
    self.receiveAddressGroup = receiveGroup;
    TLInputDataModel *inputDataModel = [[TLInputDataModel alloc] init];
    inputDataModel.canEdit = YES;
    inputDataModel.value = [self.order getDetailAddress];
    receiveGroup.dataModelRoom = @[inputDataModel].mutableCopy;
    receiveGroup.title = @"收货地址";
    receiveGroup.content = self.dataManager.shouHuoValue;
    receiveGroup.editting = YES;
    receiveGroup.headerSize = headerSmallSize;
    receiveGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    receiveGroup.cellReuseIdentifier = [TLCiXiuTextInputCell cellReuseIdentifier];
    receiveGroup.minimumLineSpacing = horizonMargin;
    receiveGroup.minimumInteritemSpacing = middleMargin;
    receiveGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, 0, paramterEdgeInsets.right);
    receiveGroup.editingEdgeInsets = receiveGroup.editedEdgeInsets;
    receiveGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    //remark
    TLGroup *remarkGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:remarkGroup];
    self.remarkGroup = remarkGroup;
    TLInputDataModel *remarkInputDataModel = [[TLInputDataModel alloc] init];
    remarkInputDataModel.canEdit = YES;
    remarkGroup.dataModelRoom = @[remarkInputDataModel].mutableCopy;
    remarkGroup.title = @"备注";
    remarkGroup.content = self.dataManager.shouHuoValue;
    remarkGroup.editting = YES;
    remarkGroup.headerSize = headerSmallSize;
    remarkGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    remarkGroup.cellReuseIdentifier = [TLCiXiuTextInputCell cellReuseIdentifier];
    remarkGroup.minimumLineSpacing = horizonMargin;
    remarkGroup.minimumInteritemSpacing = middleMargin;
    remarkGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, 0, paramterEdgeInsets.right);
    remarkGroup.editingEdgeInsets = remarkGroup.editedEdgeInsets;
    remarkGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    //
//    TLGroup *dingJiaRuleGroup = [[TLGroup alloc] init];
//    [self.dataManager.groups addObject:dingJiaRuleGroup];
//    self.dingJiaRuleGroup = dingJiaRuleGroup;
//
//    TLInputDataModel *inputDataModel1 = [[TLInputDataModel alloc] init];
//    inputDataModel1.canEdit = NO;
//    inputDataModel1.value = @"售价 = 基础价格 + 工艺价格";
//
//     TLInputDataModel *inputDataModel2 = [[TLInputDataModel alloc] init];
//    inputDataModel2.canEdit = NO;
//    inputDataModel2.value = [NSString stringWithFormat:@"会员价 = %.f X 售价",self.times];
//
//    remarkInputDataModel.canEdit = YES;
//    dingJiaRuleGroup.dataModelRoom = @[inputDataModel1,inputDataModel2].mutableCopy;
//    dingJiaRuleGroup.title = @"定价规则";
//    dingJiaRuleGroup.content = self.dataManager.shouHuoValue;
//    dingJiaRuleGroup.editting = YES;
//    dingJiaRuleGroup.headerSize = headerSmallSize;
//    dingJiaRuleGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
//    dingJiaRuleGroup.cellReuseIdentifier = [TLCiXiuTextInputCell cellReuseIdentifier];
//    dingJiaRuleGroup.minimumLineSpacing = horizonMargin;
//    dingJiaRuleGroup.minimumInteritemSpacing = middleMargin;
//    dingJiaRuleGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, 0, paramterEdgeInsets.right);
//    dingJiaRuleGroup.editingEdgeInsets = remarkGroup.editedEdgeInsets;
//    dingJiaRuleGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    
    //确定按钮
    TLGroup *confirmBtnGroup = [[TLGroup alloc] init];
    self.confirmBtnGroup = confirmBtnGroup;
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

#pragma mark- 价格delegate PriceHeaderDelegate
- (void)didSelected:(NSInteger)section priceHeaderView:(TLPriceHeaderView *)priceHeaderView;
 {
    
    @try {
        
        if ([self.dataManager.groups[section] isEqual:self.productGroup] || [self.dataManager.groups[section] isEqual:self.totalPriceGroup]) {
            
            return;
        }
        
        //1.必须已经选择了产品
        __block TLParameterModel *currentChooseModel = nil;
        [self.dataManager.groups[0].dataModelRoom enumerateObjectsUsingBlock:^(TLParameterModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.isSelected) {
                
                currentChooseModel = obj;
                
            }
        }];
        
        if (!currentChooseModel) {
            
            [TLAlert alertWithMsg:@"请选择产品"];
            return;
        }
        
        //2.判断是面料选择，还是工艺选择
        if ([self.dataManager.groups[section].mark isEqualToString:MIAN_LIAO_MARK] /* 面料选择*/) {
            
            //面料选择
            TLMianLiaoChooseVC *mianLiaoChooseVC =  [[TLMianLiaoChooseVC alloc] init];
            TLInnerProduct *innerProduct = self.dataManager.groups[section].dateModel;
            mianLiaoChooseVC.innnerProduct = innerProduct;
            mianLiaoChooseVC.delegate = self;
            [self.navigationController pushViewController:mianLiaoChooseVC animated:YES];
            
        } else {
            //工艺选择
        
            TLGongYiChooseVC *vc = [[TLGongYiChooseVC alloc] init];
            vc.innerProduct = self.dataManager.groups[section].dateModel;
            //需要确定的
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        return;

    } @catch (NSException *exception) {
        
        [TLAlert alertWithMsg:exception.name];
        
    } @finally {
        
    }
    
}



//- (void)didFinishChooseWith:(NSMutableArray *)arr dict:(NSMutableDictionary *)dict gongYiPrice:(float)gongYiPrice  vc:(UIViewController *)vc  {
//    
//    self.currentArr = arr;
//    self.currentDict = dict;
//    
//
//
//        self.calculatePriceManager.gongYiPrice = gongYiPrice;
//        //计算价格 -------- 选择产品后需要计算，改变公益后需要计算
//        float totalPrice = [self.calculatePriceManager calculate];
//        
//        //改变数据模型
//        self.totalPriceGroup.content = [NSString stringWithFormat:@"%.2f",totalPrice];
//        //刷新数据
//        [self.confirmPriceCollectionView reloadData];
//    
//    [self.confirmPriceCollectionView reloadData];
//    [vc.navigationController popViewControllerAnimated:YES];
//    
//}

#pragma mark- TLButtonHeaderView delegate 代理方法
- (void)didSelected:(TLButtonHeaderView *)btnHeaderView section:(NSInteger)secction {
    
    //都是套装，单品只是套装的特殊情况
  
    //1.先选产品
    if (!self.currentProductModel) {
        [TLAlert alertWithInfo:@"请先选择产品"];
        return;
    }
    
    //2.判断工艺是否选择
//    NSMutableArray *parameterList = [[NSMutableArray alloc] init];
    
    //
    @try {
        
        [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *singleDict = [[NSMutableDictionary alloc] init];
            singleDict[@"modelSpecs"] = obj.code;
            if (!obj.mianLiaoModel) {
                
                @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@面料未选择",obj.name] reason:nil userInfo:nil];
                
            }
            singleDict[@"clothCode"] = obj.mianLiaoModel.code;
            
            //2.0.2 改为，非必填 服务端取默认参数
//            if (obj.guiGeXiaoLeiRoom.count <= 0) {
//
//                @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@工艺未选择",obj.name] reason:nil userInfo:nil];
//
//            }
//            singleDict[@"codeList"] = obj
            
            
        }];
        
        
        //检查收货地址
        TLInputDataModel * receiveAddressModel = self.receiveAddressGroup.dataModelRoom[0];
        if (!receiveAddressModel.value || receiveAddressModel.value.length <= 0 ) {
            
            [TLAlert alertWithInfo:@"请填写收货地址"];
            return;
        }
        TLInputDataModel *remarkModel = self.remarkGroup.dataModelRoom[0];
//        if (!remarkModel.value || remarkModel.value.length <= 0 ) {
//
//            [TLAlert alertWithInfo:@"请填写收货地址"];
//            return;
//        }
        //
        
        
        //各项都选择完成
        // NEW 一代定价
        NBCDRequest *req = [[NBCDRequest alloc] init];
        req.code = @"620203";
        req.parameters[@"modelCode"] = self.currentProductModel.code;
        req.parameters[@"orderCode"] = self.order.code;
        req.parameters[@"quantity"] = @"1";
        req.parameters[@"updater"] = [TLUser user].userId;
        req.parameters[@"token"] = [TLUser user].token;
        //先默认取量体地址
        req.parameters[@"address"] = receiveAddressModel.value;
        req.parameters[@"remark"] = remarkModel.value;
        NSMutableArray *list = [[NSMutableArray alloc] init];
        

        [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *codeList = [[NSMutableArray alloc] initWithCapacity:obj.guiGeXiaoLeiRoom.count];
            [obj.guiGeXiaoLeiRoom enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [codeList addObject:obj.code];
            }];
            
       
           NSDictionary *dict = @{
                  @"clothCode" : obj.mianLiaoModel.code,
                  @"codeList" : codeList,
                  @"map" : obj.ciXiuDict? : [NSDictionary dictionary],
                  @"modelSpecsCode" : obj.code
                  };
           [list addObject:dict];
            
        }];
        
        req.parameters[@"reqList"] = list;
        
        
//#warning qudiao
//        return;
        [TLProgressHUD showWithStatus:nil];

    
        [req startWithSuccess:^(__kindof NBBaseRequest *request) {
            [TLProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
            [TLRefreshEngine engine].refreshTag = 100;

        } failure:^(__kindof NBBaseRequest *request) {
            [TLProgressHUD dismiss];

        }];
        
        
        
    } @catch (NSException *exception) {
        
        [TLAlert alertWithInfo:exception.name];
        
    } @finally {
        
    }
    

}

// ------------------ //
- (void)registerClass {
    
    if (!self.confirmPriceCollectionView) {
        NSLog(@"请先创建collectonView");
        return;
    }
    
    //Header
    [self.confirmPriceCollectionView registerClass:[TLButtonHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLButtonHeaderView headerReuseIdentifier]];
    
    //
    [self.confirmPriceCollectionView registerClass:[TLOrderCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLOrderCollectionViewHeader headerReuseIdentifier]];
    
    //
    [self.confirmPriceCollectionView registerClass:[TLPriceHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLPriceHeaderView headerReuseIdentifier]];
    
    [self.confirmPriceCollectionView registerClass:[TLOrderBigTitleHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLOrderBigTitleHeader headerReuseIdentifier]];

    
    //Cell
    [self.confirmPriceCollectionView registerClass:[TLOrderParameterCell class] forCellWithReuseIdentifier:[TLOrderParameterCell cellReuseIdentifier]];
    [self.confirmPriceCollectionView registerClass:[TLCiXiuTextInputCell class] forCellWithReuseIdentifier:[TLCiXiuTextInputCell cellReuseIdentifier]];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"定价";
    self.view.backgroundColor = [UIColor whiteColor];
    self.times = 1;
    self.calculatePriceManager = [[TLCalculatePriceManager alloc] init];
    
    [TLProgressHUD showWithStatus:nil];
    
    //获取非会员的价格倍数
    NBCDRequest *timesReq = [[NBCDRequest alloc] init];
    timesReq.code = @"620918";
    timesReq.parameters[@"keyList"] = @[@"FHY"];
    timesReq.parameters[@"companyCode"] = [AppConfig config].systemCode;
    timesReq.parameters[@"systemCode"] = [AppConfig config].systemCode;
    timesReq.parameters[@"token"] = [TLUser user].token;
    
    //获取产品列表
    NBCDRequest *xhReq = [[NBCDRequest alloc] init];
    xhReq.code = @"620014";
    xhReq.parameters[@"status"] = @"1";
    xhReq.parameters[@"orderDir"] = @"asc";
    xhReq.parameters[@"orderColumn"] = @"order_no";
    
    //
//    NBCDRequest *orderDetailReq = [[NBCDRequest alloc] init];
//    orderDetailReq.code = @"620231";
//    orderDetailReq.parameters[@"code"] = self.order.code;
//    [orderDetailReq startWithSuccess:^(__kindof NBBaseRequest *request) {
//        
//        
//    } failure:^(__kindof NBBaseRequest *request) {
//        
//    }];
    
    //获取订单详情
    NBCDRequest *orderReq = [[NBCDRequest alloc] init];
    orderReq.code = @"620231";
    orderReq.parameters[@"code"] = self.order.code;
    
    //
    NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[xhReq,timesReq,orderReq]];
    [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
        
        //
        [TLProgressHUD dismiss];
//        NBCDRequest *kuaiDiReq2 = (NBCDRequest *)batchRequest.reqArray[0];
        
        NBCDRequest *xhReq = (NBCDRequest *)batchRequest.reqArray[0];

        //倍数
        NBCDRequest *timesReqCopy = (NBCDRequest *)batchRequest.reqArray[1];
        NBCDRequest *orderReqCopy = (NBCDRequest *)batchRequest.reqArray[2];
        self.order = [TLOrderModel tl_objectWithDictionary:orderReqCopy.responseObject[@"data"]];
        
        NSDictionary *dict = timesReqCopy.responseObject[@"data"];
        self.times =  [dict[@"FHY"] floatValue];
        
        //获取产品
        NSArray *arr = xhReq.responseObject[@"data"];
        self.productRoom =  [TLProduct tl_objectArrayWithDictionaryArray:arr];
        //
        self.dataManager = [[TLOrderDataManager alloc] init];
        self.dataManager.order = self.order;
        
        //
        [self setUpUI];
        [self registerClass];
        [self configModel];
        
    } failure:^(NBBatchReqest *batchRequest) {
        
        [TLProgressHUD dismiss];
        
    }];
    
}


- (void)setUpUI {
    
    //
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.minimumLineSpacing = 0;
    fl.minimumInteritemSpacing = 0;
    
    //
    UICollectionView *confirmPriceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:fl];
    [self.view addSubview:confirmPriceCollectionView];
    self.confirmPriceCollectionView = confirmPriceCollectionView;
    [confirmPriceCollectionView adjustsContentInsets];
    confirmPriceCollectionView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    confirmPriceCollectionView.delegate = self;
    confirmPriceCollectionView.dataSource = self;
    //
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //产品选择
    // 点击选中把 预选则至为yes
    NSMutableArray <TLParameterModel *>*models = self.dataManager.groups[indexPath.section].dataModelRoom;
    [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        obj.yuSelected = idx == indexPath.row;


    }];

    //
//    [UIView animateWithDuration:0 animations:^{
//        [self.confirmPriceCollectionView  performBatchUpdates:^{
//            [self.confirmPriceCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
//
//        } completion:nil];
//    }];
    
    // ***************** 2.0.2 改了，不用点击确定 ********************** //
    TLGroup *group = self.dataManager.groups[indexPath.section];
    
    //1.先判断是否有产品选中

//    NSMutableArray <TLParameterModel *>*paraModels =  group.dataModelRoom;

    
    TLOrderCollectionViewHeader *reusableView = (TLOrderCollectionViewHeader *)[self.confirmPriceCollectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
//
    [reusableView edited];
    
    //2.
    self.dataManager.groups[indexPath.section].editting = NO;
//    //以下是选择
    [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.yuSelected) {

            obj.isSelected = YES;
            group.content = obj.name;
            //
            TLProduct *currentProduct = self.productRoom[idx];
            //当前选中的_产品
            if (self.currentProductModel) {
                [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj clearSelected];
                }];
            }
            self.totalPriceGroup.content = @"--";
            self.currentProductModel = currentProduct;


        } else {

            obj.isSelected = NO;

        }

    }];
//
//    //
    NSMutableArray *groupArr = [[NSMutableArray alloc] init];
    [groupArr addObject:self.productGroup];
//
//    //获取面料和工艺
    [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        //面料
        TLGroup *mianLiaoGroup = [[TLGroup alloc] init];
        [groupArr addObject:mianLiaoGroup];
        mianLiaoGroup.canEdit = YES;
        mianLiaoGroup.dataModelRoom = [NSMutableArray new];
        mianLiaoGroup.title = [NSString stringWithFormat:@"%@基础价格",obj.name];
        mianLiaoGroup.content =  @"--";
        mianLiaoGroup.mark = MIAN_LIAO_MARK;
        mianLiaoGroup.headerSize = HEADER_SIZE;
        mianLiaoGroup.dateModel = obj;
        mianLiaoGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];

        //工艺
        TLGroup *gongYiGroup = [[TLGroup alloc] init];
        [groupArr addObject:gongYiGroup];
        gongYiGroup.canEdit = YES;
        gongYiGroup.dataModelRoom = [NSMutableArray new];
        gongYiGroup.title = [NSString stringWithFormat:@"%@工艺费",obj.name];
        gongYiGroup.content =  @"0.00";
        gongYiGroup.dateModel = obj;
        gongYiGroup.mark = GONG_YI_MARK;
        gongYiGroup.headerSize = HEADER_SIZE;
        gongYiGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];

    }];

   //添加总价
    [groupArr addObject:self.totalPriceGroup];
    [groupArr addObject:self.receiveAddressGroup];
    [groupArr addObject:self.remarkGroup];
    [groupArr addObject:self.confirmBtnGroup];
    self.dataManager.groups = groupArr;
//
    [UIView animateWithDuration:0 animations:^{

        [self.confirmPriceCollectionView  reloadData];

    }];
    
}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.dataManager.groups[indexPath.section].itemSize;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return self.dataManager.groups[section].edgeInsets;
    
    
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//
//    return self.dataManager.groups[section].minimumLineSpacing;
//
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section  {
//
//    return self.dataManager.groups[section].minimumInteritemSpacing;
//
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return self.dataManager.groups[section].headerSize;
    
}

//- (void)chooseChenShanChangePrice {
//
////    self.gongYiPriceGroup.content = @"0";
//    self.totalPriceGroup.content = [self.currentProductModel.price convertToRealMoney];
//    
////    self.mianLiaoCountGroup.content = @"0";
////    self.mianLiaoDanJiaGroup.content = @"0";
////    self.jiaGongPriceGroup.content = @"0";
////    self.kuaiDiFeiGroup.content =  @"0";
////    self.baoZhuangFeiGroup.content = @"0";
//
//}



#pragma mark-  TLOrderEditHeaderDelegate ———— 确定按钮回调事件
- (void)actionWithView:(TLOrderCollectionViewHeader *)reusableView type:(EditType)type {
    
    switch (type) {
        case EditTypeGoEdit: {
            [reusableView editing];
            
            TLGroup *group = self.dataManager.groups[reusableView.section];
            group.editting = YES;
            [UIView animateWithDuration:0 animations:^{
                [self.confirmPriceCollectionView  performBatchUpdates:^{
                    [self.confirmPriceCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];
                    
                } completion:nil];
            }];
            
        } break;
            
//        case EditTypeConfirm: {
//
//            TLGroup *group = self.dataManager.groups[reusableView.section];
//
//            //1.先判断是否有产品选中
//          __block  BOOL isSelectedProduct = NO;
//            NSMutableArray <TLParameterModel *>*models =  group.dataModelRoom;
//            [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                if(obj.yuSelected) {
//                    isSelectedProduct = YES;
//                    *stop = YES;
//                } else if (idx == models.count - 1) {
//                //没有产品被选中
//                    isSelectedProduct = NO;
//                }
//
//
//            }];
//            if (!isSelectedProduct) {
//
//                [TLAlert alertWithInfo:@"您还未进行选择"];
//                return;
//            }
//
//
//            [reusableView edited];
//            //2.
//            self.dataManager.groups[reusableView.section].editting = NO;
//                //以下是选择
//                [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if (obj.yuSelected) {
//
//                        obj.isSelected = YES;
//                        group.content = obj.name;
//                        //
//                        TLProduct *currentProduct = self.productRoom[idx];
//                        //当前选中的_产品
//                        if (self.currentProductModel) {
//                            [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                                //清楚当前已选择的产品规格
//                                [obj clearSelected];
//
//                            }];
//                        }
//                        self.totalPriceGroup.content = @"--";
//                        self.currentProductModel = currentProduct;
//
//
//                    } else {
//
//                        obj.isSelected = NO;
//
//                    }
//
//                }];
//
//
//            // 动态添加面料 和 工艺选择
//            NSMutableArray *groupArr = [[NSMutableArray alloc] init];
//            [groupArr addObject:self.productGroup];
//
//            [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                //面料
//                TLGroup *mianLiaoGroup = [[TLGroup alloc] init];
//                [groupArr addObject:mianLiaoGroup];
//                mianLiaoGroup.canEdit = YES;
//                mianLiaoGroup.dataModelRoom = [NSMutableArray new];
//                mianLiaoGroup.title = [NSString stringWithFormat:@"%@基础价格",obj.name];
//                mianLiaoGroup.content =  @"--";
//                mianLiaoGroup.mark = MIAN_LIAO_MARK;
//                mianLiaoGroup.headerSize = HEADER_SIZE;
//                mianLiaoGroup.dateModel = obj;
//                mianLiaoGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
//
//                //工艺
//                TLGroup *gongYiGroup = [[TLGroup alloc] init];
//                [groupArr addObject:gongYiGroup];
//                gongYiGroup.canEdit = YES;
//                gongYiGroup.dataModelRoom = [NSMutableArray new];
//                gongYiGroup.title = [NSString stringWithFormat:@"%@工艺费",obj.name];
//                gongYiGroup.content =  @"--";
//                gongYiGroup.dateModel = obj;
//                gongYiGroup.mark = GONG_YI_MARK;
//                gongYiGroup.headerSize = HEADER_SIZE;
//                gongYiGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
//
//            }];
//            //添加总价
//            [groupArr addObject:self.totalPriceGroup];
//            [groupArr addObject:self.receiveAddressGroup];
//            [groupArr addObject:self.remarkGroup];
//            [groupArr addObject:self.confirmBtnGroup];
//
//            self.dataManager.groups = groupArr;
//
//            //
//            [UIView animateWithDuration:0 animations:^{
//
//                [self.confirmPriceCollectionView  reloadData];
//
//            }];
//
//        } break;
            
//        case EditTypeCancle: {
//            [reusableView edited];
//
//            self.dataManager.groups[reusableView.section].editting = NO;
//            [UIView animateWithDuration:0 animations:^{
//                [self.confirmPriceCollectionView  performBatchUpdates:^{
//                    [self.confirmPriceCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];
//
//                } completion:nil];
//            }];
//
//        } break;
            
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
        
    
        
    } else if ([header isKindOfClass:[ TLOrderBigTitleHeader class]]) {
        
        TLOrderBigTitleHeader *trueHeader = header;
        trueHeader.titleLbl.text = self.dataManager.groups[indexPath.section].title;
        
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
