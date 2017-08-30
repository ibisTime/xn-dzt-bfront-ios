//
//  TLOrderDetailVC2.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLCustomerDetailVC.h"
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
#import "TLProductChooseVC.h"
#import "TLProgressHUD.h"
#import "AppConfig.h"

#import "TLChooseDataModel.h"
#import "TLUser.h"
#import "TLAlert.h"
#import "TLCustomerStatisticsInfo.h"
#import "TLUserDataManager.h"
#import "TLButtonHeaderView.h"
#import "TLUserHeaderView.h"

@interface TLCustomerDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate,TLButtonHeaderViewDelegate>

@property (nonatomic, strong)  TLUserDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *orderDetailCollectionView;
@property (nonatomic, strong) TLCustomerStatisticsInfo *customerStatisticsInfo;

@end

@implementation TLCustomerDetailVC
- (void)submit {
    
    @try {
        
        [self trueSubmit];
        
    } @catch (NSException *exception) {
        
        [TLAlert alertWithError:exception.name];
        NSLog(@"%@",exception);
        
    } @finally {
        
    }
}

#pragma mark- TLButtonHeaderViewDelegate, 按钮事件
- (void)didSelected:(TLButtonHeaderView *)btnHeaderView section:(NSInteger)secction {

    @try {
        
        [self trueSubmit];

    } @catch (NSException *exception) {
        
        [TLAlert alertWithInfo:exception.name];
        
    } @finally {
        
        
    }
}

#pragma mark- 提交
- (void)trueSubmit {
    
    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *req = [[NBCDRequest alloc] init];
    
    NSMutableDictionary *measureDict = [[NSMutableDictionary alloc] init];
    req.parameters[@"map"] = measureDict;

    req.code = @"620220";
    req.parameters[@"remark"] = @"ios 端量体师修改";
    req.parameters[@"userId"] = self.customer.userId;
        
        [self.dataManager.measureDataRoom enumerateObjectsUsingBlock:^(TLInputDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
//            if (!obj.value || [obj.value isEqualToString:@"-"] || obj.value.length <=0) {
//                
//                @throw [NSException
//                        exceptionWithName:[NSString  stringWithFormat:@"请填写%@",obj.keyName] reason:nil userInfo:nil];
//                
//            }
            //数据正常
            measureDict[obj.keyCode] = @"1111";
            measureDict[obj.keyCode] = obj.value;
            
        }];
        
        //2.形体信息（可选）
        [self.dataManager.xingTiRoom enumerateObjectsUsingBlock:^(TLChooseDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.typeValue) {
                
                measureDict[obj.type] = obj.typeValue;

            }
            
        }];
    
    [req startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        [TLAlert alertWithSucces:@"修改成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(__kindof NBBaseRequest *request) {
        
    }];


    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"客户详情";
    
    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *userInfo = [[NBCDRequest alloc] init];
    userInfo.code = @"620221";
    userInfo.parameters[@"userId"] = self.customer.userId;
    
    //量体参数
    NBCDRequest *parameterReq = [[NBCDRequest alloc] init];
    parameterReq.code = @"620908";
//    parameterReq.parameters[@"parentKey"] = @"measure";
//    parameterReq.parameters[@"systemCode"] = [AppConfig config].systemCode;
//    parameterReq.parameters[@"companyCode"] = [AppConfig config].systemCode;
    
    
    NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[parameterReq,userInfo]];
    [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
        
        [TLProgressHUD dismiss];
        NBCDRequest *infoReq = (NBCDRequest *)batchReq.reqArray[1];
        NBCDRequest *xingTiReq = (NBCDRequest *)batchReq.reqArray[0];
        
        //
        self.customerStatisticsInfo = [TLCustomerStatisticsInfo tl_objectWithDictionary:infoReq.responseObject[@"data"]];
        self.dataManager = [[TLUserDataManager alloc] init];
        self.dataManager.customerStatisticsInfo = self.customerStatisticsInfo;
        
        //
        [self.dataManager handleUserInfo:nil];
        [self.dataManager handMeasureDataWithResp:nil];
        [self.dataManager configXingTiDataModelWithResp:xingTiReq.responseObject];

        //
        [self setUpUI];
        [self registerClass];
        [self configModel];
        
    } failure:^(NBBatchReqest *batchRequest) {
        
        [TLProgressHUD dismiss];

    }];
    
    //
//    [userInfo startWithSuccess:^(__kindof NBBaseRequest *request) {
//        [TLProgressHUD dismiss];
//        
//        self.customerStatisticsInfo = [TLCustomerStatisticsInfo tl_objectWithDictionary:request.responseObject[@"data"]];
//        self.dataManager = [[TLUserDataManager alloc] init];
//        self.dataManager.customerStatisticsInfo = self.customerStatisticsInfo;
//        
//        [self.dataManager handleUserInfo:nil];
//        [self.dataManager handMeasureDataWithResp:nil];
//        [self.dataManager configXingTiDataModelWithResp:nil];
//        
//        [self setUpUI];
//        [self registerClass];
//        //            //配置Model
//        [self configModel];
//        
//    } failure:^(__kindof NBBaseRequest *request) {
//        [TLProgressHUD dismiss];
//        
//        
//    }];
    
//    return;
//        
//        //
////        NBCDRequest *req = [[NBCDRequest alloc] init];
////        req.code = @"620054";
////        req.parameters[@"modelCode"] =  self.productCode;
////        req.parameters[@"status"] = @"1";
//    
//        NBCDRequest *parameterReq = [[NBCDRequest alloc] init];
//        parameterReq.code = @"620906";
//        parameterReq.parameters[@"parentKey"] = @"measure";
//        parameterReq.parameters[@"systemCode"] = [AppConfig config].systemCode;
//        parameterReq.parameters[@"companyCode"] = [AppConfig config].systemCode;
//
//    
//        NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[parameterReq,userInfo]];
//        [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
//            
//           NBCDRequest *userReq = (NBCDRequest *)batchRequest.reqArray[1];
//            
//            
//            self.dataManager = [[TLUserDataManager alloc] init];
//            self.customerStatisticsInfo = [TLCustomerStatisticsInfo tl_objectWithDictionary:userReq.responseObject[@"data"]];
//            self.dataManager.customerStatisticsInfo = self.customerStatisticsInfo;
//            
//            [self.dataManager handleUserInfo:nil];
//            [self.dataManager handMeasureDataWithResp:nil];
//            
////            NBCDRequest *chooseReq = (NBCDRequest *)batchRequest.reqArray[0];
////            NBCDRequest *measureDict = (NBCDRequest *)batchRequest.reqArray[1];
////            //形体所有选项
////            NBCDRequest *xingTiReq = (NBCDRequest *)batchRequest.reqArray[2];
////            NBCDRequest *mianLiaoReq = (NBCDRequest *)batchRequest.reqArray[3];
////            
////            //初始化
////            self.dataManager = [[TLOrderDataManager alloc] init];
////            
////            //
////            [self.dataManager handleParameterData:chooseReq.responseObject];
////            [self.dataManager handMeasureDataWithResp:nil];
////            [self.dataManager configXingTiDataModelWithResp:xingTiReq.responseObject];
////            
////            [self.dataManager handleMianLiaoData:mianLiaoReq.responseObject];
////            
////            //
////            [self setUpUI];
////            [self registerClass];
////            //配置Model
//            [self configModel];
//            //
//            
//        } failure:^(NBBatchReqest *batchRequest) {
//            
//        }];
    
    
}



- (void)configModel {
    
    if (!self.customerStatisticsInfo) {
        NSLog(@"必须先获取用户信息");
        return ;
    }
    
    //
    TLGroup *topUserGroup = [[TLGroup alloc] init];
    topUserGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:topUserGroup];
    topUserGroup.title = [NSString stringWithFormat:@"%@|%@",self.customerStatisticsInfo.realName,self.customerStatisticsInfo.mobile];
    topUserGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    topUserGroup.headerReuseIdentifier = [TLUserHeaderView headerReuseIdentifier];
    topUserGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 40);
    topUserGroup.minimumLineSpacing = 0;
    topUserGroup.minimumInteritemSpacing = 0;
    topUserGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);
    
    //
    
    CGSize headerBigSize = CGSizeMake(SCREEN_WIDTH, 75);
    CGSize headerMiddleSize = CGSizeMake(SCREEN_WIDTH, 45);
    CGSize headerSmallSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    //***********客户信息******************************//
    TLGroup *orderInfoGroup = [[TLGroup alloc] init];
    orderInfoGroup.dataModelRoom = self.dataManager.userInfoRoom;
    orderInfoGroup.title = @"客户信息";
    orderInfoGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    orderInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    orderInfoGroup.headerSize = headerMiddleSize;
    orderInfoGroup.minimumLineSpacing = 0;
    orderInfoGroup.minimumInteritemSpacing = 0;
    orderInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    orderInfoGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    orderInfoGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);

    //***********客户信息******************************//
    TLGroup *userInfoGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:userInfoGroup];
    userInfoGroup.dataModelRoom = self.dataManager.userInfoRoom;
    userInfoGroup.title = @"客户信息";
    userInfoGroup.headerSize = headerMiddleSize;
    userInfoGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    userInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    userInfoGroup.minimumLineSpacing = 0;
    userInfoGroup.minimumInteritemSpacing = 0;
    userInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    userInfoGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    userInfoGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);
    
    
    
    CGFloat singleW = 340;
    CGFloat measureWidth = singleW/2.0;
    CGFloat measureLeftMargin = (SCREEN_WIDTH - singleW)/2.0;
    //***********会员信息******************************//
    TLGroup *vipInfoGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:vipInfoGroup];
    vipInfoGroup.dataModelRoom = self.dataManager.vipInfoRoom;
    
    vipInfoGroup.title = @"会员信息";
    vipInfoGroup.editting = YES;
    vipInfoGroup.headerSize = headerMiddleSize;
    vipInfoGroup.cellReuseIdentifier = [TLMeasureDataCell cellReuseIdentifier];
    vipInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    vipInfoGroup.minimumLineSpacing = 0;
    vipInfoGroup.minimumInteritemSpacing = 0;
    vipInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, measureLeftMargin, 0, measureLeftMargin);
    vipInfoGroup.editingEdgeInsets =  vipInfoGroup.editedEdgeInsets;
    vipInfoGroup.itemSize = CGSizeMake(measureWidth, 35);

  
    //*********** 量体信息 ******************************//
        TLGroup *measureGroup = [[TLGroup alloc] init];
        [self.dataManager.groups addObject:measureGroup];
        measureGroup.title = @"量体信息";
        measureGroup.editting = YES;
        measureGroup.headerSize = headerMiddleSize;
        measureGroup.cellReuseIdentifier = [TLMeasureDataCell cellReuseIdentifier];
        measureGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
        measureGroup.dataModelRoom = self.dataManager.measureDataRoom;
        measureGroup.minimumLineSpacing = 0;
        measureGroup.minimumInteritemSpacing = 0;
        measureGroup.editedEdgeInsets = UIEdgeInsetsMake(0, measureLeftMargin, 0, measureLeftMargin);
        measureGroup.editingEdgeInsets =  measureGroup.editedEdgeInsets;
        measureGroup.itemSize = CGSizeMake(measureWidth, 35);
        
     //***********形体数据******************************//
        TLGroup *bodyTypeGroup = [[TLGroup alloc] init];
        [self.dataManager.groups addObject:bodyTypeGroup];
        bodyTypeGroup.dataModelRoom = self.dataManager.xingTiRoom;
        bodyTypeGroup.title = @"形体信息";
        bodyTypeGroup.headerSize = headerMiddleSize;
        bodyTypeGroup.cellReuseIdentifier = [TLMeasureDataCell cellReuseIdentifier];
        bodyTypeGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
        bodyTypeGroup.minimumLineSpacing = 0;
        bodyTypeGroup.minimumInteritemSpacing = 0;
        bodyTypeGroup.editedEdgeInsets = UIEdgeInsetsMake(0, measureLeftMargin, 20, measureLeftMargin);
        bodyTypeGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    bodyTypeGroup.itemSize = CGSizeMake(measureWidth, 30);
    
    //
    //提交复合, 已支付，可提交数据
    TLGroup *submitDataBtnGroup = [[TLGroup alloc] init];
    submitDataBtnGroup.canEdit = NO;
    submitDataBtnGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:submitDataBtnGroup];
    submitDataBtnGroup.title = @"提交数据";
    submitDataBtnGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 60);
    submitDataBtnGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    submitDataBtnGroup.headerReuseIdentifier = [TLButtonHeaderView headerReuseIdentifier];
    submitDataBtnGroup.minimumLineSpacing = 0;
    submitDataBtnGroup.minimumInteritemSpacing = 0;
    submitDataBtnGroup.itemSize = CGSizeMake(0, 0);
}


- (void)setUpUI {
    
    //
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.minimumLineSpacing = 0;
    fl.minimumInteritemSpacing = 0;
    
    UICollectionView *orderDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:fl];
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
    
    //
    [self.orderDetailCollectionView registerClass:[TLButtonHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLButtonHeaderView headerReuseIdentifier]];
    
    //
    [self.orderDetailCollectionView registerClass:[TLUserHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLUserHeaderView headerReuseIdentifier]];

    
    
    
    
    
    
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
        
        //颜色选择
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
