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


@interface TLCustomerDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate>

@property (nonatomic, strong)  TLOrderDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *orderDetailCollectionView;

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
#pragma mark- 提交
- (void)trueSubmit {
    
//    //  [TLProgressHUD showWithStatus:nil];
//    NBCDRequest *req = [[NBCDRequest alloc] init];
//    NSMutableArray *otherArr = [[NSMutableArray alloc] init];
//    
//    NSMutableDictionary *measureDict = [[NSMutableDictionary alloc] init];
//    req.parameters[@"map"] = measureDict;
//    
//    if (self.operationType == OrderOperationTypeHAddDingJia) {
//        
//        req.code = @"620205";
//        req.parameters[@"orderCode"] = self.order.code;
//        req.parameters[@"quantity"] = @"1";
//        req.parameters[@"updater"] = [TLUser user].userId;
//        req.parameters[@"remark"] = @"iOS 量体师 H+ 定价";
//        [otherArr addObject:self.productCode];
//        
//        
//    } else {
//        //数据录入
//        
//        req.code = @"620207";
//        req.parameters[@"orderCode"] = self.order.code;
//        req.parameters[@"remark"] = @"ios 提交";
//        req.parameters[@"updater"] = [TLUser user].userId;
//        
//        [self.dataManager.measureDataRoom enumerateObjectsUsingBlock:^(TLInputDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            if (!obj.value || [obj.value isEqualToString:@"-"] || obj.value.length <=0) {
//                
//                @throw [NSException
//                        exceptionWithName:[NSString  stringWithFormat:@"请填写%@",obj.keyName] reason:nil userInfo:nil];
//                
//            }
//            //数据正常
//            measureDict[obj.keyCode] = @"1111";
//            measureDict[obj.keyCode] = obj.value;
//            
//        }];
//        
//        //2.形体信息（可选）
//        [self.dataManager.xingTiRoom enumerateObjectsUsingBlock:^(TLChooseDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            [obj.parameterModelRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull parameterModel, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                measureDict[parameterModel.type] = parameterModel.code;
//                *stop = YES;
//                
//            }];
//            
//        }];
//        
//        
//    }
//    
//    //刺绣内容, 如果刺绣内容不为空， 那么刺绣
//    NSString *cixiuType = @"5-01";
//    NSString *cixiuValue = self.dataManager.ciXiuTextRoom[0].value;
//    measureDict[cixiuType] = cixiuValue;
//    
//    //收货地址
//    NSString *addressType = @"6-04";
//    NSString *addressValue = self.dataManager.shouHuoAddressRoom[0].value;
//    measureDict[addressType] = addressValue;
//    
//    
//    //3.风格
//    [self.dataManager.zhuoZhuangFengGeRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        
//        if (!obj.isSelected) {
//            
//            if (idx == self.dataManager.zhuoZhuangFengGeRoom.count - 1) {
//                @throw [NSException
//                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"风格"] reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//        }
//        
//    }];
//    
//    //面料
//    [self.dataManager.mianLiaoRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (!obj.isSelected) {
//            
//            if (idx == self.dataManager.mianLiaoRoom.count - 1) {
//                @throw [NSException
//                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"面料"] reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//        }
//        
//    }];
//    
//    //4.规格
//    [self.dataManager.guiGeRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (!obj.isSelected) {
//            
//            if (idx == self.dataManager.guiGeRoom.count - 1) {
//                @throw [NSException
//                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"规格"] reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//        }
//        
//    }];
//    
//    //5.门禁
//    [self.dataManager.menJinRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (!obj.isSelected) {
//            
//            if (idx == self.dataManager.menJinRoom.count - 1) {
//                @throw [NSException
//                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"门禁"] reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//        }
//    }];
//    
//    //6.领型
//    [self.dataManager.lingXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        
//        if (!obj.isSelected) {
//            
//            if (idx == self.dataManager.lingXingRoom.count - 1) {
//                @throw [NSException
//                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"领型"] reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//        }
//    }];
//    
//    //7.袖子
//    [self.dataManager.xiuXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (!obj.isSelected) {
//            
//            if (idx == self.dataManager.xiuXingRoom.count - 1) {
//                
//                @throw [NSException exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"袖型" ] reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//        }
//        
//    }];
//    
//    //8.口袋
//    [self.dataManager.kouDaiRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (!obj.isSelected) {
//            
//            if (idx == self.dataManager.kouDaiRoom.count - 1) {
//                @throw [NSException
//                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"口袋"] reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//            
//        }
//    }];
//    
//    //9.收省
//    [self.dataManager.shouXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        
//        if (!obj.isSelected) {
//            
//            if (idx == self.dataManager.shouXingRoom.count - 1) {
//                @throw [NSException
//                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"收省"] reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//        }
//    }];
//    
//    //10.刺绣内容
//    
//    
//    //11.刺绣字体
//    [self.dataManager.fontRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (!obj.isSelected) {
//            
//            if (cixiuValue && idx == self.dataManager.fontRoom.count - 1) {
//                
//                @throw [NSException
//                        exceptionWithName:@"请选择刺字体" reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//        }
//        
//    }];
//    
//    //12.位置
//    [self.dataManager.ciXiuLocationRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (!obj.isSelected) {
//            
//            if (cixiuValue &&  idx == self.dataManager.ciXiuLocationRoom.count - 1) {
//                @throw [NSException
//                        exceptionWithName:@"请选择刺绣位置" reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//            
//        }
//        
//    }];
//    
//    //13.颜色
//    [self.dataManager.ciXiuColorRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        if (!obj.isSelected) {
//            
//            if ( cixiuValue &&  idx == self.dataManager.ciXiuColorRoom.count - 1) {
//                @throw [NSException
//                        exceptionWithName:@"请选择刺绣颜色" reason:nil userInfo:nil];
//            }
//            
//        } else {
//            
//            [otherArr addObject:obj.code];
//            *stop = YES;
//        }
//    }];
//    
//    //14.备注
//    req.parameters[@"codeList"] = otherArr;
//    
//    
//    [req startWithSuccess:^(__kindof NBBaseRequest *request) {
//        
//        [TLProgressHUD dismiss];
//        
//        if (self.operationType == OrderOperationTypeHAddDingJia) {
//            
//            [TLAlert alertWithSucces:@"H+定价成功"];
//            
//        } else {
//            
//            [TLAlert alertWithSucces:@"录入成功"];
//            
//        }
//        //
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        
//        //
//    } failure:^(__kindof NBBaseRequest *request) {
//        [TLProgressHUD dismiss];
//        
//    }];
//    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
        
        //
//        NBCDRequest *req = [[NBCDRequest alloc] init];
//        req.code = @"620054";
//        req.parameters[@"modelCode"] =  self.productCode;
//        req.parameters[@"status"] = @"1";
    
        NBCDRequest *parameterReq = [[NBCDRequest alloc] init];
        parameterReq.code = @"620906";
        parameterReq.parameters[@"parentKey"] = @"measure";
        parameterReq.parameters[@"systemCode"] = [AppConfig config].systemCode;
        parameterReq.parameters[@"companyCode"] = [AppConfig config].systemCode;

    
        NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[parameterReq]];
        [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
            
            NBCDRequest *chooseReq = (NBCDRequest *)batchRequest.reqArray[0];
            NBCDRequest *measureDict = (NBCDRequest *)batchRequest.reqArray[1];
            //形体所有选项
            NBCDRequest *xingTiReq = (NBCDRequest *)batchRequest.reqArray[2];
            NBCDRequest *mianLiaoReq = (NBCDRequest *)batchRequest.reqArray[3];
            
            //初始化
            self.dataManager = [[TLOrderDataManager alloc] init];
            
            //
            [self.dataManager handleParameterData:chooseReq.responseObject];
            [self.dataManager handMeasureDataWithResp:nil];
            [self.dataManager configXingTiDataModelWithResp:xingTiReq.responseObject];
            
            [self.dataManager handleMianLiaoData:mianLiaoReq.responseObject];
            
            //
            [self setUpUI];
            [self registerClass];
            //配置Model
            [self configModel];
            //
            
        } failure:^(NBBatchReqest *batchRequest) {
            
        }];
    
    
}



- (void)configModel {
    
    
    CGSize headerBigSize = CGSizeMake(SCREEN_WIDTH, 75);
    CGSize headerMiddleSize = CGSizeMake(SCREEN_WIDTH, 45);
    CGSize headerSmallSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    //***********客户信息******************************//
    TLGroup *orderInfoGroup = [[TLGroup alloc] init];
    orderInfoGroup.dataModelRoom = [self.dataManager configConstOrderInfoDataModel];
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
    userInfoGroup.dataModelRoom = [self.dataManager configConstUserInfoDataModel];
    userInfoGroup.title = @"客户信息";
    userInfoGroup.headerSize = headerMiddleSize;
    userInfoGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    userInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    userInfoGroup.minimumLineSpacing = 0;
    userInfoGroup.minimumInteritemSpacing = 0;
    userInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    userInfoGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    userInfoGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);
    
    //***********会员信息******************************//
    TLGroup *vipInfoGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:vipInfoGroup];
    vipInfoGroup.dataModelRoom = [self.dataManager configConstUserInfoDataModel];
    vipInfoGroup.title = @"会员信息";
    vipInfoGroup.headerSize = headerMiddleSize;
    vipInfoGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    vipInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    vipInfoGroup.minimumLineSpacing = 0;
    vipInfoGroup.minimumInteritemSpacing = 0;
    vipInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    vipInfoGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    vipInfoGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);

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
        
        CGFloat singleW = 300;
        CGFloat measureWidth = singleW/2.0;
        CGFloat measureLeftMargin = (SCREEN_WIDTH - singleW)/2.0;
        
        //量体边距
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
                xingTiChooseModel.typeValue = xingTiChooseModel.parameterModelRoom[index].name;
                
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
