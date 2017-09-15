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

#import "TLOrderBigTitleHeader.h"
#import "TLCiXiuTextInputCell.h"


#define MIAN_LIAO_MARK @"MIAN_LIAO_MARK"
#define GONG_YI_MARK @"GONG_YI_MARK"


#define HEADER_SIZE CGSizeMake(SCREEN_WIDTH, 45)
@interface TLConfirmPriceVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate,TLPriceHeaderViewDelegate,TLButtonHeaderViewDelegate,TLGongYiChooseVCDelegate,TLMianLiaoChooseVCDelegate>

@property (nonatomic, strong) TLOrderDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *confirmPriceCollectionView;
@property (nonatomic, strong) NSMutableArray <TLProduct *>*productRoom;

//@property (nonatomic, strong) NSMutableArray *currentArr;
//@property (nonatomic, strong) NSMutableDictionary *currentDict;

//
@property (nonatomic, strong) TLProduct *currentProductModel;
@property (nonatomic, strong) TLCalculatePriceManager *calculatePriceManager;

//需要修改的组
//@property (nonatomic, strong) TLGroup *gongYiPriceGroup;

//@property (nonatomic, strong) TLGroup *mianLiaoDanJiaGroup;

//@property (nonatomic, strong) TLGroup *mianLiaoCountGroup;

//@property (nonatomic, strong) TLGroup *jiaGongPriceGroup;
//@property (nonatomic, strong) TLGroup *kuaiDiFeiGroup;
//@property (nonatomic, strong) TLGroup *baoZhuangFeiGroup;
//
//@property (nonatomic, assign) float kuaiDiFei;
//@property (nonatomic, assign) float baoZhuangFei;

// 固定group
@property (nonatomic, strong) TLGroup *productGroup;
@property (nonatomic, strong) TLGroup *confirmBtnGroup;
@property (nonatomic, strong) TLGroup *totalPriceGroup;
@property (nonatomic, strong) TLGroup *receiveAddressGroup;



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
            mianLiaoPriceGroup.content = [mianLiaoModel.price convertToRealMoney];
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
            
            gongYiGroup.content = [NSString stringWithFormat:@"%.2f",[innerProduct calculateGongYiPrice]];
            *stop = YES;
            [self.confirmPriceCollectionView reloadData];
        }
        
    }];
    
    [self calculateTotalPriceWhenCan];

}

#pragma mark- 每次选择后判断是否要进行总价计算当然是在合适的时候
- (void)calculateTotalPriceWhenCan {

    @try {
        
        [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (!obj.mianLiaoModel || obj.guiGeXiaoLeiRoom.count <= 0) {
                
                @throw [NSException exceptionWithName:@"暂时不能计算" reason:nil userInfo:nil];
                
            }
            
        }];
        
        //都选择了
        __block float totalPrice = 0;
        [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            totalPrice +=  [obj calculateTotalPrice];
            
        }];
        
        self.totalPriceGroup.content = [NSString stringWithFormat:@"%.2f",totalPrice];
        [self.confirmPriceCollectionView reloadData];
        
        
    } @catch (NSException *exception) {
        
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
    CGFloat middleMargin = 15;
    UIEdgeInsets paramterEdgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);
    CGFloat parameterCellWidth = (SCREEN_WIDTH - paramterEdgeInsets.left * 2 - 2*horizonMargin)/3.0;
    
    //
    NSMutableArray *productMutableArr = [[NSMutableArray alloc] init];
    
        //前端从产品界面进入，预约的时候已经有产品
        [self.productRoom enumerateObjectsUsingBlock:^(TLProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
//            if ( (self.order.productList && self.order.productList.count > 0) && [self.order.productList[0].modelCode isEqualToString:obj.code]) {
//
//                TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
//                parameterModel.code = obj.code;
//                parameterModel.name = obj.name;
//                parameterModel.pic = obj.advPic;
//                parameterModel.yuSelected = YES;
//                parameterModel.isSelected = YES;
//                [productMutableArr addObject:parameterModel];
//                self.currentProductModel = obj;
//                
//            } else {
            
                TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                parameterModel.code = obj.code;
                parameterModel.name = obj.name;
                parameterModel.pic = obj.advPic;
                [productMutableArr addObject:parameterModel];
//            }
      
            
        }];
 
    
    //
    TLGroup *productGroup = [[TLGroup alloc] init];
    self.productGroup = productGroup;
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
    
    //总价
    TLGroup *zongJiaGroup = [[TLGroup alloc] init];
    self.totalPriceGroup = zongJiaGroup;
    zongJiaGroup.canEdit = NO;
    zongJiaGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:zongJiaGroup];
    zongJiaGroup.title = @"总价";
    zongJiaGroup.content =  @"--";
    zongJiaGroup.headerSize = headerSmallSize;
    zongJiaGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    zongJiaGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
    zongJiaGroup.minimumLineSpacing = horizonMargin;
    zongJiaGroup.minimumInteritemSpacing = middleMargin;
    zongJiaGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    zongJiaGroup.editingEdgeInsets = paramterEdgeInsets;
    zongJiaGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //收货地址
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
            mianLiaoChooseVC.innnerProductCode = innerProduct.code;
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
    NSMutableArray *parameterList = [[NSMutableArray alloc] init];
    
    //
    @try {
        
        [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *singleDict = [[NSMutableDictionary alloc] init];
            singleDict[@"modelSpecs"] = obj.code;
            if (!obj.mianLiaoModel) {
                
                @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@面料未选择",obj.name] reason:nil userInfo:nil];
                
            }
            singleDict[@"clothCode"] = obj.mianLiaoModel.code;
            
            //
            if (obj.guiGeXiaoLeiRoom.count <= 0) {
                
                @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@工艺未选择",obj.name] reason:nil userInfo:nil];
                
            }
//            singleDict[@"codeList"] = obj
            
            
        }];
        
        
        //检查收货地址
        TLInputDataModel * receiveAddressModel = self.receiveAddressGroup.dataModelRoom[0];
        if (!receiveAddressModel.value || receiveAddressModel.value.length <= 0 ) {
            
            [TLAlert alertWithInfo:@"请填写收货地址"];
            return;
        }
        
        
        //各项都选择完成
        // NEW 一代定价
        NBCDRequest *req = [[NBCDRequest alloc] init];
        req.code = @"620203";
        req.parameters[@"modelCode"] = self.currentProductModel.code;
        req.parameters[@"orderCode"] = self.order.code;
        req.parameters[@"quantity"] = @"1";
        req.parameters[@"updater"] = [TLUser user].userId;
        //先默认取量体地址
        req.parameters[@"address"] = receiveAddressModel.value;
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        

        [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray *codeList = [[NSMutableArray alloc] initWithCapacity:obj.guiGeXiaoLeiRoom.count];
            [obj.guiGeXiaoLeiRoom enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [codeList addObject:obj.code];
            }];
            
       
           NSDictionary *dict = @{
                  @"clothCode" : obj.mianLiaoModel.code,
                  @"codeList" : codeList,
                  @"map" : obj.ciXiuDict? : @"",
                  @"modelSpecsCode" : obj.code
                  };
           [list addObject:dict];
            
        }];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:list options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *reqListStr = 
        req.parameters[@"reqList"] = list;
//        [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
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
    self.calculatePriceManager = [[TLCalculatePriceManager alloc] init];
    
    [TLProgressHUD showWithStatus:nil];
//    NBCDRequest *kuaiDiReq2 = [[NBCDRequest alloc] init];
//    kuaiDiReq2.code = @"620918";
//    kuaiDiReq2.parameters[@"keyList"] = @[@"KDF",@"BZF"]; ;
//    kuaiDiReq2.parameters[@"companyCode"] = [AppConfig config].systemCode;
//    kuaiDiReq2.parameters[@"systemCode"] = [AppConfig config].systemCode;
    
    //获取产品列表
    NBCDRequest *xhReq = [[NBCDRequest alloc] init];
//    xhReq.code = @"620012";
    xhReq.code = @"620014";
    xhReq.parameters[@"status"] = @"1";
    
    //
//    NBCDRequest *orderReq = [[NBCDRequest alloc] init];
//    orderReq.code = @"620234";
//    orderReq.parameters[@"code"] = self.order.code;
    
    //
    NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[xhReq]];
    [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
        
        //
        [TLProgressHUD dismiss];
//        NBCDRequest *kuaiDiReq2 = (NBCDRequest *)batchRequest.reqArray[0];
        
        NBCDRequest *xhReq = (NBCDRequest *)batchRequest.reqArray[0];
//        NBCDRequest *orderReq = (NBCDRequest *)batchRequest.reqArray[1];
//
//        TLOrderModel *orderModel = [TLOrderModel tl_objectWithDictionary:orderReq.responseObject[@"data"]];
//        self.order = orderModel;
//        self.calculatePriceManager.times = [orderModel.times floatValue];
        //

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
    
    confirmPriceCollectionView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    confirmPriceCollectionView.delegate = self;
    confirmPriceCollectionView.dataSource = self;
    //
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //产品选择
    NSMutableArray <TLParameterModel *>*models = self.dataManager.groups[indexPath.section].dataModelRoom;
    [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.yuSelected = idx == indexPath.row;
        
        
    }];
    
    [UIView animateWithDuration:0 animations:^{
        [self.confirmPriceCollectionView  performBatchUpdates:^{
            [self.confirmPriceCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            
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



#pragma mark-  TLOrderEditHeaderDelegate
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
            
        case EditTypeConfirm: {
            
            TLGroup *group = self.dataManager.groups[reusableView.section];

            //1.先判断是否有产品选中
          __block  BOOL isSelectedProduct = NO;
            NSMutableArray <TLParameterModel *>*models =  group.dataModelRoom;
            [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if(obj.yuSelected) {
                    isSelectedProduct = YES;
                    *stop = YES;
                } else if (idx == models.count - 1) {
                //没有产品被选中
                    isSelectedProduct = NO;
                }
                
                
            }];
            if (!isSelectedProduct) {
                
                [TLAlert alertWithInfo:@"您还未进行选择"];
                return;
            }
            
       
            [reusableView edited];
            //2.
            self.dataManager.groups[reusableView.section].editting = NO;
                //以下是选择
                [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.yuSelected) {
                        
                        obj.isSelected = YES;
                        group.content = obj.name;
                        //
                        TLProduct *currentProduct = self.productRoom[idx];
                        //当前选中的_产品
                        self.currentProductModel = currentProduct;

                        
                    } else {
                        
                        obj.isSelected = NO;
                        
                    }
                    
                }];
                            
       
            
            //
            NSMutableArray *groupArr = [[NSMutableArray alloc] init];
            [groupArr addObject:self.productGroup];
            
            [self.currentProductModel.modelSpecsList enumerateObjectsUsingBlock:^(TLInnerProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                //面料
                TLGroup *mianLiaoGroup = [[TLGroup alloc] init];
                [groupArr addObject:mianLiaoGroup];
                mianLiaoGroup.canEdit = YES;
                mianLiaoGroup.dataModelRoom = [NSMutableArray new];
                mianLiaoGroup.title = [NSString stringWithFormat:@"%@面料费",obj.name];
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
                gongYiGroup.content =  @"--";
                gongYiGroup.dateModel = obj;
                gongYiGroup.mark = GONG_YI_MARK;
                gongYiGroup.headerSize = HEADER_SIZE;
                gongYiGroup.headerReuseIdentifier = [TLPriceHeaderView headerReuseIdentifier];
                
            }];
            //添加总价
            
            [groupArr addObject:self.totalPriceGroup];
            [groupArr addObject:self.receiveAddressGroup];
            [groupArr addObject:self.confirmBtnGroup];
            
            self.dataManager.groups = groupArr;

            //
            [UIView animateWithDuration:0 animations:^{
                
                [self.confirmPriceCollectionView  reloadData];
                
            }];
 
        } break;
            
        case EditTypeCancle: {
            [reusableView edited];
            
            self.dataManager.groups[reusableView.section].editting = NO;
            [UIView animateWithDuration:0 animations:^{
                [self.confirmPriceCollectionView  performBatchUpdates:^{
                    [self.confirmPriceCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];
                    
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
