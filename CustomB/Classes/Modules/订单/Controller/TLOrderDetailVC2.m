//
//  TLOrderDetailVC2.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderDetailVC2.h"
#import "TLUIHeader.h"
#import "TLOrderModel.h"
#import "TLInputDataModel.h"

#import "TLOrderCollectionViewHeader.h"
#import "TLOrderBigTitleHeader.h"
#import "TLOrderBGTitleHeader.h"
#import "TLOrderDoubleTitleHeader.h"

#import "TLOrderDataManager.h"
#import "TLOrderDetailCell.h"
#import "TLOrderStyleCell.h"

#import "TLOrderParameterCell.h"
#import "TLColorChooseCell.h"
#import "TLMeasureDataCell.h"
#import "TLOrderInfoCell.h"
#import "TLCiXiuTextInputCell.h"

#import "NBNetwork.h"
#import "TLProgressHUD.h"
#import "AppConfig.h"

#import "TLChooseDataModel.h"
#import "TLUser.h"
#import "TLAlert.h"
#import "TLButtonHeaderView.h"
#import "TLUserHeaderView.h"
#import "TLRefreshEngine.h"
#import "Const.h"
#import "NSString+Extension.h"
#import "TLSwitchHeaderView.h"
#import "TLGuiGeDaLei.h"

#define HEADER_SMALL_SIZE CGSizeMake(SCREEN_WIDTH, 45)
#define HEADER_MIDDLE_SIZE CGSizeMake(SCREEN_WIDTH, 45)

#define HEADER_BIG_SIZE CGSizeMake(SCREEN_WIDTH, 75)

//
#define CI_XIU_MARK @"CI_XIU_MARK"
#define DA_LEI_COLOR_MARK @"DA_LEI_COLOR_MARK"

@interface TLOrderDetailVC2 ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate,TLButtonHeaderViewDelegate,TLSwitchHeaderViewDelegate>

@property (nonatomic, strong)  TLOrderDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *orderDetailCollectionView;
@property (nonatomic, strong) TLOrderModel *order;
@property (nonatomic, strong) TLGroup *ciXiuTextGroup;

//
@property (nonatomic, strong) NSMutableArray <TLGroup *>*topGroups;
// 中部是套装随产品改变的group
@property (nonatomic, strong) NSMutableArray <TLGroup *>*bottomGroups;


@end


@implementation TLOrderDetailVC2
- (void)submit {


}
#pragma mark- 提交
- (void)trueSubmit {

    //[TLProgressHUD showWithStatus:nil];
    NBCDRequest *req = [[NBCDRequest alloc] init];
//  NSMutableArray *otherArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *measureDict = [[NSMutableDictionary alloc] init];
    
    req.code = @"620205";
    req.parameters[@"map"] = measureDict;
    req.parameters[@"orderCode"] = self.order.code;
    req.parameters[@"updater"] = [TLUser user].userId;
    req.parameters[@"token"] = [TLUser user].token;

    
    [self.dataManager.measureDataRoom enumerateObjectsUsingBlock:^(TLInputDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.value  || obj.value.length <=0) {
            
            @throw [NSException
                    exceptionWithName:[NSString  stringWithFormat:@"请填写%@",obj.keyName] reason:nil userInfo:nil];
            
        }
        //数据正常
        //            measureDict[obj.keyCode] = @"1111";
        measureDict[obj.keyCode] = obj.value;
        
    }];
    
    //2.形体信息（可选）
    [self.dataManager.xingTiRoom enumerateObjectsUsingBlock:^(TLChooseDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.typeValue) {
            
            measureDict[obj.type] = obj.typeValue;
            
        }
        
    }];
    
    
    
    
    
//    //收货地址
//    NSString *addressType = @"6-04";
//    NSString *addressValue = self.dataManager.shouHuoAddressRoom[0].value;
//    measureDict[addressType] = addressValue;
    
    //备注
//    measureDict[kBeiZhuType] = self.dataManager.remarkRoom[0].value;
    req.parameters[@"remark"] = self.dataManager.remarkRoom[0].value;
    
//    req.parameters[@"codeList"] = otherArr;
    [req startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        [TLProgressHUD dismiss];
        [TLAlert alertWithSucces:@"录入成功"];
        //
        //      [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(__kindof NBBaseRequest *request) {
        [TLProgressHUD dismiss];
        
    }];
    
    
}

- (void)tl_placeholderOperation {
    
    //订单详情
    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *orderReq = [[NBCDRequest alloc] init];
    orderReq.code = @"620231";
    orderReq.parameters[@"code"] = self.orderCode;
    [orderReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        [TLProgressHUD dismiss];

        [self removePlaceholderView];
        //先获取订单信息，在获取其它信息
        self.order = [TLOrderModel tl_objectWithDictionary:request.responseObject[@"data"]];
        
        //根据产品获取产品code
        self.productCode = self.order.product.modelCode;
        
        
        //************* //
        self.dataManager = [[TLOrderDataManager alloc] initWithOrder:self.order];
    
        //************* //

        NBCDRequest *xingTiReq = [[NBCDRequest alloc] init];
        xingTiReq.code = @"620908";
        [xingTiReq startWithSuccess:^(__kindof NBBaseRequest *request) {
            
            //
            [self.dataManager handMeasureDataWithResp:nil];
            [self.dataManager configXingTiDataModelWithResp:request.responseObject];

            //
            [self setUpUI];
            [self registerClass];
            //配置Model
            [self configModel];
        } failure:^(__kindof NBBaseRequest *request) {
            
        }];
        
        
        //重要内容不要删除
        
//        NBCDRequest *req = [[NBCDRequest alloc] init];
//        req.code = @"620054";
//        req.parameters[@"modelCode"] = self.order.productList.count ? self.order.productList[0].modelCode : self.productCode;
//        req.parameters[@"status"] = @"1";
//        
//        //获取形体数据
//        NBCDRequest *xingTiReq = [[NBCDRequest alloc] init];
//        xingTiReq.code = @"620908";
//
//        //面料
//        NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[req,xingTiReq]];
//        [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
//            
//            [TLProgressHUD dismiss];
//
//            NBCDRequest *chooseReq = (NBCDRequest *)batchRequest.reqArray[0];
//            //形体所有选项
//            NBCDRequest *xingTiReq = (NBCDRequest *)batchRequest.reqArray[1];
////            NBCDRequest *mianLiaoReq = (NBCDRequest *)batchRequest.reqArray[2];
//            
//            //初始化
//            self.dataManager = [[TLOrderDataManager alloc] initWithOrder:self.order];
//            
//            //
////            [self.dataManager handleParameterData:chooseReq.responseObject];
//            [self.dataManager handMeasureDataWithResp:nil];
//            [self.dataManager configXingTiDataModelWithResp:xingTiReq.responseObject];
//            
////            [self.dataManager handleMianLiaoData:mianLiaoReq.responseObject];
//            
//            //
//            [self setUpUI];
//            [self registerClass];
//            //配置Model
//            [self configModel];
//            //
//            
//        } failure:^(NBBatchReqest *batchRequest) {
//            
//            [TLProgressHUD dismiss];
//            
//        }];
        
    } failure:^(__kindof NBBaseRequest *request) {
        
        [self addPlaceholderView];
        [TLProgressHUD dismiss];
        
    }];

}

#pragma mark- switchHeaderDelegate
- (void)didSwitchWith:(TLSwitchHeaderView *)switchHeaderView  selectedIdx:(NSInteger)idx {

   //冲新加载group模型
//    int i = 10;
    NSMutableArray *newGroups = [[NSMutableArray alloc] init];
    [newGroups addObjectsFromArray:self.topGroups];
    [newGroups addObjectsFromArray:[self reloadDynamicGroupWhenSwitchXiaoJianWithXiaoJianIdx:idx]];
    [newGroups addObjectsFromArray:self.bottomGroups];
    self.dataManager.groups = newGroups;
    [self.orderDetailCollectionView reloadData];
    
}


- (NSMutableArray <TLGroup *> *)reloadDynamicGroupWhenSwitchXiaoJianWithXiaoJianIdx:(NSInteger )index {
    
    NSMutableArray *middleGroups = [[NSMutableArray alloc] init];

    //***********定制信息 ******************************//
    CGFloat horizonMargin = 18;
    CGFloat middleMargin = 15;
    UIEdgeInsets paramterEdgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);
    CGFloat parameterCellWidth = (SCREEN_WIDTH - paramterEdgeInsets.left * 2 - 2*horizonMargin)/3.0;
    
    
    TLGroup *dingZhiGroup = [[TLGroup alloc] init];
//  [self.dataManager.groups addObject:dingZhiGroup];
    [middleGroups addObject:dingZhiGroup];
    dingZhiGroup.dataModelRoom = [self.dataManager configDefaultModel];
    dingZhiGroup.title = @"定制信息";
    dingZhiGroup.headerSize = HEADER_BIG_SIZE;
    dingZhiGroup.headerReuseIdentifier = [TLOrderDoubleTitleHeader headerReuseIdentifier];
    
    //装载规格的大类
    NSMutableArray <TLGuiGeDaLei *> *cixiuGuiGeDaLeiRoom = [[NSMutableArray alloc] init];
    
    //面料
    TLGroup *mianLiaoGroup = [[TLGroup alloc] init];
    [middleGroups addObject:mianLiaoGroup];
    mianLiaoGroup.canEdit = NO;
    NSMutableArray *xiaoLeiRoom = [[NSMutableArray alloc] init];
    mianLiaoGroup.dataModelRoom = xiaoLeiRoom;
    mianLiaoGroup.title = @"面料编号";
    mianLiaoGroup.content = self.order.product.productVarList[index].mianLiaoModel.modelNum;
    mianLiaoGroup.headerSize = HEADER_SMALL_SIZE;
    mianLiaoGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    mianLiaoGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    mianLiaoGroup.minimumLineSpacing = horizonMargin;
    mianLiaoGroup.minimumInteritemSpacing = middleMargin;
    mianLiaoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    mianLiaoGroup.editingEdgeInsets = paramterEdgeInsets;
    mianLiaoGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //遍历所有大类
    [self.order.product.productVarList[index].guiGeDaLeiRoom enumerateObjectsUsingBlock:^(TLGuiGeDaLei * _Nonnull guiGeDaLei, NSUInteger idx, BOOL * _Nonnull stop) {
        
        switch (guiGeDaLei.guiGeLeiBie) {
            case GuiGeDaLeiTypeDefaultGongYi: {
                
                TLGroup *parameterGroup = [[TLGroup alloc] init];
//                [self.dataManager.groups addObject:parameterGroup];
                [middleGroups addObject:parameterGroup];

                parameterGroup.dateModel = guiGeDaLei;
                parameterGroup.canEdit = NO;
                NSMutableArray *xiaoLeiRoom = [[NSMutableArray alloc] init];
                if (guiGeDaLei.productCraft) {
                    parameterGroup.content = guiGeDaLei.productCraft.name;
                }
                [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull guiGeXiaoLei, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                    parameterModel.pic = guiGeXiaoLei.pic;
                    parameterModel.selectPic = guiGeXiaoLei.selectedPic;
                    parameterModel.name = guiGeXiaoLei.name;
                    parameterModel.dataModel = guiGeXiaoLei;
                    [xiaoLeiRoom addObject:parameterModel];
                    
                }];
                
                //
                parameterGroup.dataModelRoom = xiaoLeiRoom;
                parameterGroup.title = guiGeDaLei.dvalue;
                //        parameterGroup.content = self.dataManager.menJinValue;
                parameterGroup.headerSize = HEADER_SMALL_SIZE;
                parameterGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
                parameterGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                parameterGroup.minimumLineSpacing = horizonMargin;
                parameterGroup.minimumInteritemSpacing = middleMargin;
                parameterGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
                parameterGroup.editingEdgeInsets = paramterEdgeInsets;
                parameterGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
                
                if (guiGeDaLei.colorDaLei && guiGeDaLei.colorDaLei.colorProductCraft) {
                    
                    TLGroup *colorGroup = [[TLGroup alloc] init];
                    colorGroup.mark = DA_LEI_COLOR_MARK;
                    [middleGroups addObject:colorGroup];
                    colorGroup.content = guiGeDaLei.colorDaLei.colorProductCraft.name;
                    colorGroup.dataModelRoom = [[NSMutableArray alloc] init];
                    colorGroup.title = guiGeDaLei.colorDaLei.dvalue;
                    
                    colorGroup.headerSize = HEADER_SMALL_SIZE;
                    colorGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                    colorGroup.canEdit = NO;
                    colorGroup.cellReuseIdentifier = [TLColorChooseCell cellReuseIdentifier];
                    colorGroup.minimumLineSpacing = 11;
                    colorGroup.minimumInteritemSpacing = 15;
                    colorGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 35);
                    colorGroup.editingEdgeInsets = UIEdgeInsetsMake(15, 35, 10, 35);
                    CGFloat colorChooseCellWidth = (SCREEN_WIDTH - colorGroup.edgeInsets.left * 2 - 2* colorGroup.minimumLineSpacing - 10)/3.0;
                    colorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);
                    colorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);
                    
                }
                //判断是否有颜色标识
                //                if ([guiGeDaLei isHaveColorMark]) {
                //
                //                    TLGroup *colorGroup = [[TLGroup alloc] init];
                //                    colorGroup.mark = DA_LEI_COLOR_MARK;
                //                    [self.dataManager.groups addObject:colorGroup];
                //                    NSMutableArray *colorRoom = [[NSMutableArray alloc] init];
                //                    [guiGeDaLei.colorPcList[0].colorCraftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //
                //                        TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                //                        parameterModel.pic = obj.pic;
                //                        parameterModel.selectPic = obj.selectedPic;
                //                        parameterModel.dataModel = obj;
                //                        parameterModel.name = obj.name;
                //                        [colorRoom addObject:parameterModel];
                //
                //                    }];
                //                    colorGroup.dataModelRoom = colorRoom;
                //                    colorGroup.title = guiGeDaLei.colorPcList[0].name;
                ////                    colorGroup.content = self.dataManager.ciXiuColorValue;
                //                    colorGroup.headerSize = headerSmallSize;
                //                    colorGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                //                    colorGroup.canEdit = YES;
                //                    colorGroup.cellReuseIdentifier = [TLColorChooseCell cellReuseIdentifier];
                //                    colorGroup.minimumLineSpacing = 11;
                //                    colorGroup.minimumInteritemSpacing = 15;
                //                    colorGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 35);
                //                    colorGroup.editingEdgeInsets = UIEdgeInsetsMake(15, 35, 10, 35);
                //                    CGFloat colorChooseCellWidth = (SCREEN_WIDTH - colorGroup.edgeInsets.left * 2 - 2* colorGroup.minimumLineSpacing - 10)/3.0;
                //                    colorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);
                //                    colorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);
                //
                //                }
                
            }  break;
                
                // 着装风格
            case GuiGeDaLeiTypeZhuoZhuangFengGe: {
                
                
                TLGroup *styleGroup = [[TLGroup alloc] init];
//                [self.dataManager.groups addObject:styleGroup];
                [middleGroups addObject:styleGroup];
                styleGroup.canEdit = NO;

                NSMutableArray *styleRoom = [[NSMutableArray alloc] init];
                if (guiGeDaLei.productCraft) {
                    styleGroup.content = guiGeDaLei.productCraft.name;
                }
                [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                    parameterModel.name = obj.name;
                    parameterModel.dataModel = obj;
                    [styleRoom addObject:parameterModel];
                    
                }];
                
                styleGroup.dataModelRoom = styleRoom;
                styleGroup.title = @"着装风格";
                styleGroup.headerSize = HEADER_SMALL_SIZE;
                styleGroup.cellReuseIdentifier = [TLOrderStyleCell cellReuseIdentifier];
                styleGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                styleGroup.minimumLineSpacing = horizonMargin;
                styleGroup.minimumInteritemSpacing = middleMargin;
                styleGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
                styleGroup.editingEdgeInsets = paramterEdgeInsets;
                styleGroup.itemSize = CGSizeMake(parameterCellWidth, 30);
                
            }  break;
                
                //
            case GuiGeDaLeiTypeCiXiuText: {
                
                [cixiuGuiGeDaLeiRoom addObject:guiGeDaLei];
                
            }  break;
            case GuiGeDaLeiTypeCiXiuColor: {
                
                [cixiuGuiGeDaLeiRoom addObject:guiGeDaLei];
                
            }  break;
            case GuiGeDaLeiTypeCiXiuOther: {
                
                [cixiuGuiGeDaLeiRoom addObject:guiGeDaLei];
                
            }  break;
                
                
        }
        
    }];
    
    if (cixiuGuiGeDaLeiRoom.count > 0 && cixiuGuiGeDaLeiRoom[0].productCraft) {
        
        //        [self.dataManager handleCiXiu:cixiuGuiGeDaLeiRoom];
        //***********************刺绣内容**************************//
        TLGroup *ciXiuGroup = [[TLGroup alloc] init];
//        [self.dataManager.groups addObject:ciXiuGroup];
        [middleGroups addObject:ciXiuGroup];
        ciXiuGroup.canEdit = NO;
        ciXiuGroup.dataModelRoom = [self.dataManager configDefaultModel];
        
        ciXiuGroup.title = @"刺绣定制信息";
        ciXiuGroup.headerSize = HEADER_MIDDLE_SIZE;
        ciXiuGroup.headerReuseIdentifier = [TLOrderBGTitleHeader headerReuseIdentifier];
        
        [cixiuGuiGeDaLeiRoom enumerateObjectsUsingBlock:^(TLGuiGeDaLei * _Nonnull guiGeDaLei, NSUInteger idx, BOOL * _Nonnull stop) {
            
            switch (guiGeDaLei.guiGeLeiBie) {
                case GuiGeDaLeiTypeCiXiuText: {
                    
                    //内容
                    TLGroup *ciXiuTextGroup = [[TLGroup alloc] init];
//                    [self.dataManager.groups addObject:ciXiuTextGroup];
                    [middleGroups addObject:ciXiuTextGroup];
                    ciXiuTextGroup.canEdit = NO;

                    NSMutableArray *arr =  [[NSMutableArray alloc] initWithCapacity:1];
                    [arr addObject:@1];
                    self.ciXiuTextGroup = ciXiuTextGroup;
                    if (guiGeDaLei.productCraft) {
                        ciXiuTextGroup.content = guiGeDaLei.productCraft.code;
                    }
                    ciXiuTextGroup.dataModelRoom = @[[[TLInputDataModel alloc] init]].mutableCopy;
                    //单独处理，与订单的处理方式不同
                    TLInputDataModel *dataModelRoomOneModel = ciXiuTextGroup.dataModelRoom[0];
                    dataModelRoomOneModel.canEdit = NO;
                    ciXiuTextGroup.mark = CI_XIU_MARK;
                    ciXiuTextGroup.title = @"刺绣内容";
                    ciXiuTextGroup.headerSize = HEADER_SMALL_SIZE;
                    ciXiuTextGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                    ciXiuTextGroup.cellReuseIdentifier = [TLCiXiuTextInputCell cellReuseIdentifier];
                    ciXiuTextGroup.minimumLineSpacing = horizonMargin;
                    ciXiuTextGroup.minimumInteritemSpacing = middleMargin;
                    ciXiuTextGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
                    ciXiuTextGroup.editingEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
                    ciXiuTextGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 45);
                    
                }  break;
                    
                case GuiGeDaLeiTypeCiXiuColor: {
                    //颜色
                    TLGroup *ciXiuColorGroup = [[TLGroup alloc] init];
//                    [self.dataManager.groups addObject:ciXiuColorGroup];
                    ciXiuColorGroup.canEdit = NO;
                    [middleGroups addObject:ciXiuColorGroup];

                    if (guiGeDaLei.productCraft) {
                        ciXiuColorGroup.content = guiGeDaLei.productCraft.name;
                    }
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                        parameterModel.name = obj.name;
                        parameterModel.pic = obj.pic;
                        parameterModel.selectPic = obj.selectedPic;
                        parameterModel.dataModel = obj;
                        [arr addObject:parameterModel];
                        
                    }];
                    
                    ciXiuColorGroup.dataModelRoom = arr;
                    ciXiuColorGroup.title = @"刺绣颜色";
                    ciXiuColorGroup.headerSize = HEADER_SMALL_SIZE;
                    ciXiuColorGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                    ciXiuColorGroup.mark = CI_XIU_MARK;
                    ciXiuColorGroup.cellReuseIdentifier = [TLColorChooseCell cellReuseIdentifier];
                    ciXiuColorGroup.minimumLineSpacing = 11;
                    ciXiuColorGroup.minimumInteritemSpacing = 15;
                    ciXiuColorGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 35, 30, 35);
                    ciXiuColorGroup.editingEdgeInsets = UIEdgeInsetsMake(15, 35, 30, 35);
                    CGFloat colorChooseCellWidth = (SCREEN_WIDTH - ciXiuColorGroup.edgeInsets.left * 2 - 2* ciXiuColorGroup.minimumLineSpacing - 10)/3.0;
                    ciXiuColorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);
                    
                }  break;
                    
                case GuiGeDaLeiTypeCiXiuOther: {
                    
                    TLGroup *ciXiuLocationGroup = [[TLGroup alloc] init];
//                    [self.dataManager.groups addObject:ciXiuLocationGroup];
                    [middleGroups addObject:ciXiuLocationGroup];
                    ciXiuLocationGroup.canEdit = NO;
                    if (guiGeDaLei.productCraft) {
                        ciXiuLocationGroup.content = guiGeDaLei.productCraft.name;
                    }
                    
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                        parameterModel.name = obj.name;
                        parameterModel.pic = obj.pic;
                        parameterModel.selectPic = obj.selectedPic;
                        parameterModel.dataModel = obj;
                        [arr addObject:parameterModel];
                        
                    }];
                    ciXiuLocationGroup.dataModelRoom = arr;
                    ciXiuLocationGroup.title = guiGeDaLei.dvalue;
                    ciXiuLocationGroup.mark = CI_XIU_MARK;
                    //                    ciXiuLocationGroup.content = self.dataManager.ciXiuLocationValue;
                    ciXiuLocationGroup.headerSize = HEADER_SMALL_SIZE;
                    ciXiuLocationGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                    ciXiuLocationGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
                    ciXiuLocationGroup.minimumLineSpacing = horizonMargin;
                    ciXiuLocationGroup.minimumInteritemSpacing = middleMargin;
                    ciXiuLocationGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
                    ciXiuLocationGroup.editingEdgeInsets = paramterEdgeInsets;
                    ciXiuLocationGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
                    
                }  break;
                    
            }
            
        }];
        
        
        
    }

    return middleGroups;

}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = @"订单详情";
    [self setPlaceholderViewTitle:@"加载失败" operationTitle:@"重新加载"];

    
    //获取全部选择参数，除布料外
//    if (!self.productCode) {
//        NSLog(@"产品编号不能为空");
//    }
    //
    [self tl_placeholderOperation];
   
}

#pragma mark- delegate  按钮点击事件,底部按钮点击事件
- (void)didSelected:(TLButtonHeaderView *)btnHeaderView section:(NSInteger)secction {

    if ([btnHeaderView.title isEqualToString:@"提交复核"]) {
        
        [TLProgressHUD showWithStatus:nil];
        NBCDRequest *req = [[NBCDRequest alloc] init];
        req.code = @"620206";
        req.parameters[@"orderCode"] = self.order.code;
        req.parameters[@"updater"] = [TLUser user].userId;
        req.parameters[@"token"] = [TLUser user].token;
        req.parameters[@"remark"] = self.dataManager.remarkRoom[0].value;
        [req startWithSuccess:^(__kindof NBBaseRequest *request) {
            [TLProgressHUD dismiss];
            
            [TLAlert alertWithSucces:@"提交复核成功"];
            [TLRefreshEngine engine].refreshTag = 10;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(__kindof NBBaseRequest *request) {
            
            [TLProgressHUD dismiss];
            
        }];
        
    } else if ([btnHeaderView.title isEqualToString:@"提交数据"]) {
    
        @try {
            
            [self trueSubmit];
            
        } @catch (NSException *exception) {
            
            [TLAlert alertWithError:exception.name];
            //
        } @finally {
            
        }
    
    }
    
}


- (void)configModel {

    
//    CGSize headerBigSize = CGSizeMake(SCREEN_WIDTH, 75);
//    CGSize headerMiddleSize = CGSizeMake(SCREEN_WIDTH, 45);
//    CGSize headerSmallSize = CGSizeMake(SCREEN_WIDTH, 45);
    self.topGroups = [[NSMutableArray alloc] init];
    self.bottomGroups = [[NSMutableArray alloc] init];
    //
    
    //顶部用户信息
    TLGroup *topUserGroup = [[TLGroup alloc] init];
    topUserGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:topUserGroup];
    [self.topGroups addObject:topUserGroup];
    topUserGroup.title = [NSString stringWithFormat:@"%@ | %@",self.order.ltName,self.order.applyMobile];
    topUserGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    topUserGroup.headerReuseIdentifier = [TLUserHeaderView headerReuseIdentifier];
    topUserGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 40);
    topUserGroup.minimumLineSpacing = 0;
    topUserGroup.minimumInteritemSpacing = 0;
    topUserGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);
    
    //***********订单信息******************************//
    TLGroup *orderInfoGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:orderInfoGroup];
    [self.topGroups addObject:orderInfoGroup];

    orderInfoGroup.dataModelRoom = [self.dataManager configConstOrderInfoDataModel];
    orderInfoGroup.title = @"订单信息";
    orderInfoGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    orderInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    orderInfoGroup.headerSize = HEADER_MIDDLE_SIZE;
    orderInfoGroup.minimumLineSpacing = 0;
    orderInfoGroup.minimumInteritemSpacing = 0;
    orderInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    orderInfoGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    orderInfoGroup.itemSize = CGSizeZero;
    
    //伪头部
    TLGroup *falseGroup = [[TLGroup alloc] init];
    falseGroup.dataModelRoom = [self.dataManager configProductInfoDataModel];
    if (falseGroup.dataModelRoom.count > 0) {
        [self.dataManager.groups addObject:falseGroup];
        [self.topGroups addObject:falseGroup];

    }
    falseGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    falseGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    falseGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 1);
    falseGroup.minimumLineSpacing = 0;
    falseGroup.minimumInteritemSpacing = 0;
    falseGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    falseGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    falseGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);
    
    
    //***********物流信息******************************//
    TLGroup *logisticsInfoGroup = [[TLGroup alloc] init];
    logisticsInfoGroup.dataModelRoom = [self.dataManager configConstLogisticsInfoDataModel];
    if (logisticsInfoGroup.dataModelRoom.count > 0) {
        [self.dataManager.groups addObject:logisticsInfoGroup];
        [self.topGroups addObject:logisticsInfoGroup];

    }
    logisticsInfoGroup.title = @"物流信息";
    logisticsInfoGroup.headerSize = HEADER_MIDDLE_SIZE;
    logisticsInfoGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    logisticsInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    logisticsInfoGroup.minimumLineSpacing = 0;
    logisticsInfoGroup.minimumInteritemSpacing = 0;
    logisticsInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    logisticsInfoGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    logisticsInfoGroup.itemSize = CGSizeZero;

    
    //***********客户信息******************************//
    TLGroup *userInfoGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:userInfoGroup];
    userInfoGroup.dataModelRoom = [self.dataManager configConstUserInfoDataModel];
    [self.topGroups addObject:userInfoGroup];
    userInfoGroup.title = @"客户信息";
    userInfoGroup.headerSize = HEADER_MIDDLE_SIZE;
    
    userInfoGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    userInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    userInfoGroup.minimumLineSpacing = 0;
    userInfoGroup.minimumInteritemSpacing = 0;
    userInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    userInfoGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    userInfoGroup.itemSize = CGSizeZero;
    
        //*********** 量体信息 ******************************//
        TLGroup *measureGroup = [[TLGroup alloc] init];
        [self.dataManager.groups addObject:measureGroup];
    [self.topGroups addObject:measureGroup];

        measureGroup.title = @"量体信息";
        measureGroup.editting = YES;
        measureGroup.headerSize = HEADER_MIDDLE_SIZE;
        measureGroup.cellReuseIdentifier = [TLMeasureDataCell cellReuseIdentifier];
        measureGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
        measureGroup.dataModelRoom = self.dataManager.measureDataRoom;
        measureGroup.minimumLineSpacing = 0;
        measureGroup.minimumInteritemSpacing = 0;
        
        CGFloat singleW = 300;
        CGFloat measureWidth = singleW/2.0;
        CGFloat measureLeftMargin = (SCREEN_WIDTH - singleW)/2.0;
        
        //量体边距
        measureGroup.editedEdgeInsets = UIEdgeInsetsMake(0, measureLeftMargin, 0, measureLeftMargin);
        measureGroup.editingEdgeInsets =  measureGroup.editedEdgeInsets;
        measureGroup.itemSize = CGSizeMake(measureWidth, 35);
        
        //***********      形体数据          ******************************//
        TLGroup *bodyTypeGroup = [[TLGroup alloc] init];
        [self.dataManager.groups addObject:bodyTypeGroup];
    [self.topGroups addObject:bodyTypeGroup];
        bodyTypeGroup.dataModelRoom = self.dataManager.xingTiRoom;
        bodyTypeGroup.title = @"形体信息";
        bodyTypeGroup.canEdit = YES;
        bodyTypeGroup.headerSize = HEADER_MIDDLE_SIZE;
        bodyTypeGroup.cellReuseIdentifier = [TLMeasureDataCell cellReuseIdentifier];
        bodyTypeGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
        bodyTypeGroup.minimumLineSpacing = 0;
        bodyTypeGroup.minimumInteritemSpacing = 0;
        bodyTypeGroup.editedEdgeInsets = UIEdgeInsetsMake(0, measureLeftMargin, 20, measureLeftMargin);
        bodyTypeGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
        bodyTypeGroup.itemSize = CGSizeMake(measureWidth, 30);

    
    
    // *********** 多种产品的时候  需要切换 ***************//
    
    //switch
    if (self.order.product.productVarList.count > 1) {
        
        TLGroup *switchGroup = [[TLGroup alloc] init];
        [self.dataManager.groups addObject:switchGroup];
        [self.topGroups addObject:switchGroup];

        
        NSMutableArray *names = [[NSMutableArray alloc] init];
        [self.order.product.productVarList enumerateObjectsUsingBlock:^(TLUserProductXiaoJian * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [names addObject:obj.name];

            
        }];
         
        switchGroup.dataModelRoom = names;
        switchGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 35);
        switchGroup.headerReuseIdentifier = [TLSwitchHeaderView headerReuseIdentifier];
        
    }

    //***********定制信息 ******************************//
    CGFloat horizonMargin = 18;
    CGFloat middleMargin = 15;
    UIEdgeInsets paramterEdgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);
    CGFloat parameterCellWidth = (SCREEN_WIDTH - paramterEdgeInsets.left * 2 - 2*horizonMargin)/3.0;
    
    //中部可变信息
    [self.dataManager.groups addObjectsFromArray:    [self reloadDynamicGroupWhenSwitchXiaoJianWithXiaoJianIdx:0] ];
  
    //收货地址
    TLGroup *receiveGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:receiveGroup];
    [self.bottomGroups addObject:receiveGroup];
    receiveGroup.dataModelRoom = self.dataManager.shouHuoAddressRoom;
    receiveGroup.title = @"收货地址";
    receiveGroup.content = self.dataManager.shouHuoValue;
    receiveGroup.editting = YES;
    receiveGroup.headerSize = HEADER_SMALL_SIZE;
    receiveGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    receiveGroup.cellReuseIdentifier = [TLCiXiuTextInputCell cellReuseIdentifier];
    receiveGroup.minimumLineSpacing = horizonMargin;
    receiveGroup.minimumInteritemSpacing = middleMargin;
    receiveGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, 0, paramterEdgeInsets.right);
    receiveGroup.editingEdgeInsets = receiveGroup.editedEdgeInsets;
    receiveGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    //
    TLGroup *remarkGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:remarkGroup];
    [self.bottomGroups addObject:remarkGroup];
    remarkGroup.dataModelRoom = self.dataManager.remarkRoom;
    remarkGroup.title = @"备注";
    remarkGroup.content = self.dataManager.remarkValue;
    remarkGroup.editting = YES;
    remarkGroup.headerSize = HEADER_SMALL_SIZE;
    remarkGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    remarkGroup.cellReuseIdentifier = [TLCiXiuTextInputCell cellReuseIdentifier];
    remarkGroup.minimumLineSpacing = horizonMargin;
    remarkGroup.minimumInteritemSpacing = middleMargin;
    remarkGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, 20, paramterEdgeInsets.right);
    remarkGroup.editingEdgeInsets = remarkGroup.editedEdgeInsets;
    remarkGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    //*********************  提交数据 和 提交复核按钮 **************************//
    TLGroup *confirmBtnGroup = [[TLGroup alloc] init];
    confirmBtnGroup.canEdit = NO;
    confirmBtnGroup.dataModelRoom = [NSMutableArray new];
    
    if ([self.order canSubmitData]) {
    
        [self.dataManager.groups addObject:confirmBtnGroup];
        [self.bottomGroups addObject:confirmBtnGroup];

    }
    
    confirmBtnGroup.title = @"提交数据";
    confirmBtnGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 60);
    confirmBtnGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    confirmBtnGroup.headerReuseIdentifier = [TLButtonHeaderView headerReuseIdentifier];
    confirmBtnGroup.minimumLineSpacing = horizonMargin;
    confirmBtnGroup.minimumInteritemSpacing = middleMargin;
    confirmBtnGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    confirmBtnGroup.editingEdgeInsets = paramterEdgeInsets;
    confirmBtnGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //提价复合, 已支付，可提交数据
    TLGroup *submitCheckBtnGroup = [[TLGroup alloc] init];
    submitCheckBtnGroup.canEdit = NO;
    submitCheckBtnGroup.dataModelRoom = [NSMutableArray new];
    if ([self.order canSubmitCheck]) {
    
        [self.dataManager.groups addObject:submitCheckBtnGroup];
        [self.bottomGroups addObject:submitCheckBtnGroup];
        
    }
    submitCheckBtnGroup.title = @"提交复核";
    submitCheckBtnGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 60);
    submitCheckBtnGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    submitCheckBtnGroup.headerReuseIdentifier = [TLButtonHeaderView headerReuseIdentifier];
    submitCheckBtnGroup.minimumLineSpacing = horizonMargin;
    submitCheckBtnGroup.minimumInteritemSpacing = middleMargin;
    submitCheckBtnGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    submitCheckBtnGroup.editingEdgeInsets = paramterEdgeInsets;
    submitCheckBtnGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    //
    
}

- (void)viewDidLayoutSubviews {
    
    self.orderDetailCollectionView.frame = self.view.bounds;
    
}

- (void)setUpUI {

    //
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.minimumLineSpacing = 0;
    fl.minimumInteritemSpacing = 0;
    
    UICollectionView *orderDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 0) collectionViewLayout:fl];
    [self.view addSubview:orderDetailCollectionView];
    self.orderDetailCollectionView = orderDetailCollectionView;
    orderDetailCollectionView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    orderDetailCollectionView.delegate = self;
    orderDetailCollectionView.dataSource = self;

}

- (void)registerClass {

    //
    [self.orderDetailCollectionView registerClass:[TLOrderCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLOrderCollectionViewHeader headerReuseIdentifier]];
    
    [self.orderDetailCollectionView registerClass:[TLOrderBigTitleHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLOrderBigTitleHeader headerReuseIdentifier]];
    
    [self.orderDetailCollectionView registerClass:[TLOrderBGTitleHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLOrderBGTitleHeader headerReuseIdentifier]];
    
    [self.orderDetailCollectionView registerClass:[TLOrderDoubleTitleHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLOrderDoubleTitleHeader headerReuseIdentifier]];
    
    
     [self.orderDetailCollectionView registerClass:[TLButtonHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLButtonHeaderView headerReuseIdentifier]];
    
     [self.orderDetailCollectionView registerClass:[TLUserHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLUserHeaderView headerReuseIdentifier]];
    
     [self.orderDetailCollectionView registerClass:[TLSwitchHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLSwitchHeaderView headerReuseIdentifier]];
    
//    [self.orderDetailCollectionView registerClass:[TLSwitchHeaderView class] forSupplementaryViewOfKind:[TLSwitchHeaderView headerReuseIdentifier]];
    
    
    //1.定制信息
    //风格
    [self.orderDetailCollectionView registerClass:[TLOrderStyleCell class] forCellWithReuseIdentifier:[TLOrderStyleCell cellReuseIdentifier]];
    //规格
    [self.orderDetailCollectionView registerClass:[TLOrderParameterCell class] forCellWithReuseIdentifier:[TLOrderParameterCell cellReuseIdentifier]];
    
    //颜色选中
    [self.orderDetailCollectionView registerClass:[TLColorChooseCell class] forCellWithReuseIdentifier:[TLColorChooseCell cellReuseIdentifier]];
    
    //量体数据
    [self.orderDetailCollectionView registerClass:[TLMeasureDataCell class] forCellWithReuseIdentifier:[TLMeasureDataCell cellReuseIdentifier]];
    
    //
    [self.orderDetailCollectionView registerClass:[TLOrderInfoCell class] forCellWithReuseIdentifier:[TLOrderInfoCell cellReuseIdentifier]];
    
    //刺绣内容输入
    [self.orderDetailCollectionView registerClass:[TLCiXiuTextInputCell class] forCellWithReuseIdentifier:[TLCiXiuTextInputCell cellReuseIdentifier]];
    
}


#pragma mark- 以下为数据源方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[TLColorChooseCell class]] || [cell isKindOfClass:[TLOrderParameterCell class]]) {
        
        //颜色选择, 和 ,其它
        NSMutableArray <TLParameterModel *>*models = self.dataManager.groups[indexPath.section].dataModelRoom;
        [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.yuSelected = idx == indexPath.row;
            
          
        }];
        
        [UIView animateWithDuration:0 animations:^{
            [self.orderDetailCollectionView  performBatchUpdates:^{
                [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
                
            } completion:nil];
        }];

    } else if (
               [cell isKindOfClass:[TLMeasureDataCell class]] &&
               [self.dataManager.groups[indexPath.section].dataModelRoom[indexPath.row]  isKindOfClass:[TLChooseDataModel class]]
               ) {
        //用此cell you测量数据 和 形体信息，但在此的只能是形体信息
        //形体信息事件处理
        
        
        TLGroup *group = self.dataManager.groups[indexPath.section];
        TLChooseDataModel *xingTiChooseModel = group.dataModelRoom[indexPath.row];
        if (!xingTiChooseModel.canEdit) {
            //不可编辑状态，不进行事件处理
            return;
        }
        
        //进行选择
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",@"",xingTiChooseModel.typeName] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [xingTiChooseModel.parameterModelRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:obj.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                NSInteger index = [alertCtrl.actions indexOfObject:action];
                
                //为选中
                [xingTiChooseModel.parameterModelRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.yuSelected = idx == index;
                }];
                xingTiChooseModel.typeValue = xingTiChooseModel.parameterModelRoom[index].code;
                xingTiChooseModel.typeValueName = xingTiChooseModel.parameterModelRoom[index].name;
                
                [UIView animateWithDuration:0 animations:^{
                    [self.orderDetailCollectionView  performBatchUpdates:^{
                        [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
                        
                    } completion:nil];
                }];
                
            }];
            [alertCtrl addAction:action];
            
            
        }];
        
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertCtrl addAction:action];
        [self presentViewController:alertCtrl animated:YES completion:^{
            
        }];
        
    } else if ([cell isKindOfClass:[TLOrderStyleCell class]]) {
    
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

}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    BOOL isZero = CGSizeEqualToSize(self.dataManager.groups[indexPath.section].itemSize, CGSizeZero);
    if (isZero) {
        TLDataModel *dataModel = (TLDataModel *)self.dataManager.groups[indexPath.section].dataModelRoom[indexPath.row];
        
        if ([dataModel isKindOfClass:[TLDataModel class]]) {
            
            return dataModel.itemSize;
            
        }
        
        return self.dataManager.groups[indexPath.section].itemSize;
        
    }
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
            
            if ([group.dataModelRoom[0] isKindOfClass:[TLInputDataModel class]]) {
                //这里是输入选型
                TLInputDataModel *inputDataModel = (TLInputDataModel *)group.dataModelRoom[0];
                group.content = inputDataModel.value;
                
            } else {
                //以下是选择
                NSMutableArray <TLParameterModel *>*models =  group.dataModelRoom;
                [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.yuSelected) {
                        
                        obj.isSelected = YES;
                        group.content = obj.name;
                        
                    } else {
                        obj.isSelected = NO;

                    }
                    
                }];
            
            }
       
            
            [UIView animateWithDuration:0 animations:^{
                [self.orderDetailCollectionView  performBatchUpdates:^{
                    [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];
                    
                } completion:nil];
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
    
    id header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          
                                                                        withReuseIdentifier:self.dataManager.groups[indexPath.section].headerReuseIdentifier
                                                                                                                   forIndexPath:indexPath];
    
    
    if ([header isKindOfClass:[ TLOrderCollectionViewHeader class]]) {
        
        TLOrderCollectionViewHeader *trueHeader = header;
        trueHeader.delegate = self;
        trueHeader.section = indexPath.section;
        trueHeader.group = self.dataManager.groups[indexPath.section];
        
        
    } else if ([header isKindOfClass:[ TLOrderBigTitleHeader class]]) {
    
        TLOrderBigTitleHeader *trueHeader = header;
        trueHeader.titleLbl.text = self.dataManager.groups[indexPath.section].title;
    
    } else if([header isKindOfClass:[ TLOrderBGTitleHeader class]]) {
    
        TLOrderBGTitleHeader *trueHeader = header;
        trueHeader.titleLbl.text = self.dataManager.groups[indexPath.section].title;
    
    } else if([header isKindOfClass:[ TLOrderDoubleTitleHeader class]]) {
        
        TLOrderDoubleTitleHeader *trueHeader = header;
        trueHeader.title = self.dataManager.groups[indexPath.section].title;
        
    } else if ([header isKindOfClass:[TLButtonHeaderView class]]) {
        
        TLButtonHeaderView *trueHeader = header;
        trueHeader.section = indexPath.section;
        trueHeader.delegate = self;
        trueHeader.title = self.dataManager.groups[indexPath.section].title;
        
    } else if ([header isKindOfClass:[TLUserHeaderView class]]) {
    
        TLUserHeaderView *trueHeader = header;
        trueHeader.title = self.dataManager.groups[indexPath.section].title;
        
    } else if ([header isKindOfClass:[TLSwitchHeaderView class]]) {
    
        TLSwitchHeaderView *trueHeader = header;
        trueHeader.group = self.dataManager.groups[indexPath.section];
        trueHeader.delegate = self;
        
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
