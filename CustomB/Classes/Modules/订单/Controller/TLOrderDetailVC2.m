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
#import "TLProductChooseVC.h"
#import "TLProgressHUD.h"
#import "AppConfig.h"

#import "TLChooseDataModel.h"
#import "TLUser.h"
#import "TLAlert.h"
#import "TLButtonHeaderView.h"
#import "TLUserHeaderView.h"


@interface TLOrderDetailVC2 ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate,TLButtonHeaderViewDelegate>

@property (nonatomic, strong)  TLOrderDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *orderDetailCollectionView;
@property (nonatomic, strong) TLOrderModel *order;

@end


@implementation TLOrderDetailVC2
- (void)submit {


}
#pragma mark- 提交
- (void)trueSubmit {

//  [TLProgressHUD showWithStatus:nil];
    NBCDRequest *req = [[NBCDRequest alloc] init];
    NSMutableArray *otherArr = [[NSMutableArray alloc] init];

    NSMutableDictionary *measureDict = [[NSMutableDictionary alloc] init];
    req.parameters[@"map"] = measureDict;

        req.code = @"620207";
        req.parameters[@"orderCode"] = self.order.code;
        req.parameters[@"remark"] = self.dataManager.remarkValue;
        req.parameters[@"updater"] = [TLUser user].userId;

        [self.dataManager.measureDataRoom enumerateObjectsUsingBlock:^(TLInputDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (!obj.value || [obj.value isEqualToString:@"-"] || obj.value.length <=0) {
                
            @throw [NSException
                       exceptionWithName:[NSString  stringWithFormat:@"请填写%@",obj.keyName] reason:nil userInfo:nil];
                
            }
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
    

//    }
    
    //刺绣内容, 如果刺绣内容不为空
    NSString *cixiuType = @"5-01";
    NSString *cixiuValue = self.dataManager.ciXiuTextRoom[0].value;
    measureDict[cixiuType] = cixiuValue;
    
    //收货地址
    NSString *addressType = @"6-04";
    NSString *addressValue = self.dataManager.shouHuoAddressRoom[0].value;
    measureDict[addressType] = addressValue;
    
    
    //3.风格
    [self.dataManager.zhuoZhuangFengGeRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        

        if (!obj.isSelected) {
            
            if (idx == self.dataManager.zhuoZhuangFengGeRoom.count - 1) {
                @throw [NSException
                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"风格"] reason:nil userInfo:nil];
            }
            
        } else {
            
            [otherArr addObject:obj.code];
            *stop = YES;
        }
        
    }];
    
    //面料
    [self.dataManager.mianLiaoRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.isSelected) {
            
            if (idx == self.dataManager.mianLiaoRoom.count - 1) {
                @throw [NSException
                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"面料"] reason:nil userInfo:nil];
            }
            
        } else {
            
            [otherArr addObject:obj.code];
            *stop = YES;
        }
        
    }];

    //4.规格
    [self.dataManager.guiGeRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.isSelected) {
            
            if (idx == self.dataManager.guiGeRoom.count - 1) {
                @throw [NSException
                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"规格"] reason:nil userInfo:nil];
            }
            
        } else {
            
            [otherArr addObject:obj.code];
            *stop = YES;
        }
        
    }];
    
    //5.门禁
    [self.dataManager.menJinRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.isSelected) {
            
            if (idx == self.dataManager.menJinRoom.count - 1) {
                @throw [NSException
                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"门禁"] reason:nil userInfo:nil];
            }
            
        } else {
            
            [otherArr addObject:obj.code];
            *stop = YES;
        }
    }];
    
    //6.领型
    [self.dataManager.lingXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if (!obj.isSelected) {
            
            if (idx == self.dataManager.lingXingRoom.count - 1) {
                @throw [NSException
                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"领型"] reason:nil userInfo:nil];
            }
            
        } else {
            
            [otherArr addObject:obj.code];
            *stop = YES;
        }
    }];
    
    //7.袖子
    [self.dataManager.xiuXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.isSelected) {
            
            if (idx == self.dataManager.xiuXingRoom.count - 1) {
                
                @throw [NSException exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"袖型" ] reason:nil userInfo:nil];
            }
            
        } else {
            
            [otherArr addObject:obj.code];
            *stop = YES;
        }
        
    }];
    
    //8.口袋
    [self.dataManager.kouDaiRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.isSelected) {
            
            if (idx == self.dataManager.kouDaiRoom.count - 1) {
                @throw [NSException
                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"口袋"] reason:nil userInfo:nil];
            }
            
        } else {
            
            [otherArr addObject:obj.code];
            *stop = YES;
            
        }
    }];
    
    //9.收省
    [self.dataManager.shouXingRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if (!obj.isSelected) {
            
            if (idx == self.dataManager.shouXingRoom.count - 1) {
                @throw [NSException
                        exceptionWithName:[NSString  stringWithFormat:@"请选择%@",@"收省"] reason:nil userInfo:nil];
            }
            
        } else {
            
            [otherArr addObject:obj.code];
            *stop = YES;
        }
    }];
    
    //10.刺绣内容
 
    
    //11.刺绣字体
    [self.dataManager.fontRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (cixiuValue) {
            
            if (!obj.isSelected) {
                
                if ( idx == self.dataManager.fontRoom.count - 1) {
                    
                    @throw [NSException
                            exceptionWithName:@"请选择刺字体" reason:nil userInfo:nil];
                }
                
            } else {
                
                [otherArr addObject:obj.code];
                *stop = YES;
            }
            
        }
   
    }];
    
    //12.位置
    [self.dataManager.ciXiuLocationRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (cixiuValue) {
            
            if (!obj.isSelected) {
                
                if (cixiuValue &&  idx == self.dataManager.ciXiuLocationRoom.count - 1) {
                    @throw [NSException
                            exceptionWithName:@"请选择刺绣位置" reason:nil userInfo:nil];
                }
                
            } else {
                
                [otherArr addObject:obj.code];
                *stop = YES;
                
            }
        }
    
        
    }];
    
    //13.颜色
    [self.dataManager.ciXiuColorRoom enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (cixiuValue) {
            
            if (!obj.isSelected) {
                
                if ( idx == self.dataManager.ciXiuColorRoom.count - 1) {
                    @throw [NSException
                            exceptionWithName:@"请选择刺绣颜色" reason:nil userInfo:nil];
                }
                
            } else {
                
                [otherArr addObject:obj.code];
                *stop = YES;
            }
            
        }
     
    }];
    
    req.parameters[@"codeList"] = otherArr;

    [req startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        [TLProgressHUD dismiss];
        [TLAlert alertWithSucces:@"录入成功"];
        //
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        //
    } failure:^(__kindof NBBaseRequest *request) {
        [TLProgressHUD dismiss];
        
    }];

    
}

- (void)viewDidLoad {

    [super viewDidLoad];

   self.title = @"订单详情";

    
    //获取全部选择参数，除布料外
    if (!self.productCode) {
        NSLog(@"产品编号不能为空");
    }
    
    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *orderReq = [[NBCDRequest alloc] init];
    orderReq.code = @"620234";
    orderReq.parameters[@"code"] = self.orderCode;
    [orderReq startWithSuccess:^(__kindof NBBaseRequest *request) {
        
        [TLProgressHUD dismiss];
        //先获取订单信息，在获取其它信息
        self.order = [TLOrderModel tl_objectWithDictionary:request.responseObject[@"data"]];
        
        //根据产品获取产品code
        self.productCode = self.order.productList[0].modelCode;

        //
        NBCDRequest *req = [[NBCDRequest alloc] init];
        req.code = @"620054";
        req.parameters[@"modelCode"] = self.order.productList.count ? self.order.productList[0].modelCode : self.productCode;
        req.parameters[@"status"] = @"1";
        
        //获取形体数据
        NBCDRequest *xingTiReq = [[NBCDRequest alloc] init];
        xingTiReq.code = @"620908";
        
        //面料
        NBCDRequest *mianLiaoReq = [[NBCDRequest alloc] init];
        mianLiaoReq.code = @"620032";
        mianLiaoReq.parameters[@"modelCode"] = self.productCode;
        mianLiaoReq.parameters[@"status"] = @"1";
        
        
        NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[req,xingTiReq,mianLiaoReq]];
        [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
            
            NBCDRequest *chooseReq = (NBCDRequest *)batchRequest.reqArray[0];
            //形体所有选项
            NBCDRequest *xingTiReq = (NBCDRequest *)batchRequest.reqArray[1];
            NBCDRequest *mianLiaoReq = (NBCDRequest *)batchRequest.reqArray[2];
    
            //初始化
            self.dataManager = [[TLOrderDataManager alloc] initWithOrder:self.order];
            
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
        
    } failure:^(__kindof NBBaseRequest *request) {
        
        [TLProgressHUD dismiss];

    }];

}

#pragma mark- delegate  按钮点击事件,底部按钮点击事件
- (void)didSelected:(TLButtonHeaderView *)btnHeaderView section:(NSInteger)secction {

    if ([btnHeaderView.title isEqualToString:@"提交复核"]) {
        
        [TLProgressHUD showWithStatus:nil];
        NBCDRequest *req = [[NBCDRequest alloc] init];
        req.code = @"620209";
        req.parameters[@"orderCode"] = self.order.code;
        req.parameters[@"updater"] = [TLUser user].userId;
        [req startWithSuccess:^(__kindof NBBaseRequest *request) {
            [TLProgressHUD dismiss];
            
            [TLAlert alertWithSucces:@"提交复核成功"];
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

    
    CGSize headerBigSize = CGSizeMake(SCREEN_WIDTH, 75);
    CGSize headerMiddleSize = CGSizeMake(SCREEN_WIDTH, 45);
    CGSize headerSmallSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    
    //顶部用户信息
    TLGroup *topUserGroup = [[TLGroup alloc] init];
    topUserGroup.dataModelRoom = [NSMutableArray new];
    [self.dataManager.groups addObject:topUserGroup];
    topUserGroup.title = [NSString stringWithFormat:@"%@|%@",self.order.ltName,self.order.applyMobile];
    topUserGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    topUserGroup.headerReuseIdentifier = [TLUserHeaderView headerReuseIdentifier];
    topUserGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 40);
    topUserGroup.minimumLineSpacing = 0;
    topUserGroup.minimumInteritemSpacing = 0;
    topUserGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);
    
    //***********订单信息******************************//
    TLGroup *orderInfoGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:orderInfoGroup];
    orderInfoGroup.dataModelRoom = [self.dataManager configConstOrderInfoDataModel];
    orderInfoGroup.title = @"订单信息";
    orderInfoGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    orderInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    orderInfoGroup.headerSize = headerMiddleSize;
    orderInfoGroup.minimumLineSpacing = 0;
    orderInfoGroup.minimumInteritemSpacing = 0;
    orderInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    orderInfoGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    orderInfoGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);
    
    //伪头部
    TLGroup *falseGroup = [[TLGroup alloc] init];
    falseGroup.dataModelRoom = [self.dataManager configProductInfoDataModel];
    if (falseGroup.dataModelRoom.count > 0) {
        [self.dataManager.groups addObject:falseGroup];
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

    }
    logisticsInfoGroup.title = @"物流信息";
    logisticsInfoGroup.headerSize = headerMiddleSize;
    logisticsInfoGroup.cellReuseIdentifier = [TLOrderInfoCell cellReuseIdentifier];
    logisticsInfoGroup.headerReuseIdentifier = [TLOrderBigTitleHeader headerReuseIdentifier];
    logisticsInfoGroup.minimumLineSpacing = 0;
    logisticsInfoGroup.minimumInteritemSpacing = 0;
    logisticsInfoGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    logisticsInfoGroup.editingEdgeInsets =  orderInfoGroup.editedEdgeInsets;
    logisticsInfoGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 30);

    
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

    
    
    //***********定制信息 ******************************//
    CGFloat horizonMargin = 18;
    CGFloat middleMargin = 15;
    UIEdgeInsets paramterEdgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);
    CGFloat parameterCellWidth = (SCREEN_WIDTH - paramterEdgeInsets.left * 2 - 2*horizonMargin)/3.0;

    
    TLGroup *dingZhiGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:dingZhiGroup];
    dingZhiGroup.dataModelRoom = [self.dataManager configDefaultModel];
    dingZhiGroup.title = @"定制信息";
    dingZhiGroup.headerSize = headerBigSize;
    dingZhiGroup.headerReuseIdentifier = [TLOrderDoubleTitleHeader headerReuseIdentifier];
    
    //自己一种计算方式
    TLGroup *styleGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:styleGroup];
    styleGroup.dataModelRoom = self.dataManager.zhuoZhuangFengGeRoom;
    styleGroup.title = @"风格";
    styleGroup.canEdit = [self.order canEditDingZhi];
    styleGroup.content = self.dataManager.zhuoZhuangFengGeValue;
    styleGroup.headerSize = headerSmallSize;
    styleGroup.cellReuseIdentifier = [TLOrderStyleCell cellReuseIdentifier];
    styleGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    styleGroup.minimumLineSpacing = horizonMargin;
    styleGroup.minimumInteritemSpacing = middleMargin;
    styleGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    styleGroup.editingEdgeInsets = paramterEdgeInsets;
//    styleGroup.itemSize = CGSizeMake(styleW, 30);
    styleGroup.itemSize = CGSizeMake(parameterCellWidth, 30);
    //
    

    
    TLGroup *mianLiaoRoom = [[TLGroup alloc] init];
    mianLiaoRoom.canEdit = [self.order canEditDingZhi];
    if (mianLiaoRoom.canEdit) {
        [self.dataManager.groups addObject:mianLiaoRoom];

    }
    mianLiaoRoom.dataModelRoom = self.dataManager.mianLiaoRoom;
    mianLiaoRoom.title = @"面料";
    mianLiaoRoom.content = self.dataManager.mianLiaoValue;
    mianLiaoRoom.headerSize = headerSmallSize;
    mianLiaoRoom.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    mianLiaoRoom.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    mianLiaoRoom.minimumLineSpacing = horizonMargin;
    mianLiaoRoom.minimumInteritemSpacing = middleMargin;
    mianLiaoRoom.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    mianLiaoRoom.editingEdgeInsets = paramterEdgeInsets;
    mianLiaoRoom.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //
    TLGroup *parameterGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:parameterGroup];
    parameterGroup.dataModelRoom = self.dataManager.guiGeRoom;
    parameterGroup.title = @"规格";
    parameterGroup.content = self.dataManager.guiGeValue;
    parameterGroup.canEdit = [self.order canEditDingZhi];


    parameterGroup.headerSize = headerSmallSize;
    parameterGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    parameterGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    parameterGroup.minimumLineSpacing = horizonMargin;
    parameterGroup.minimumInteritemSpacing = middleMargin;
    parameterGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    parameterGroup.editingEdgeInsets = paramterEdgeInsets;
    parameterGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //门禁
    TLGroup *doorGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:doorGroup];
    doorGroup.dataModelRoom = self.dataManager.menJinRoom;
    doorGroup.title = @"门禁";
    doorGroup.canEdit = [self.order canEditDingZhi];
    doorGroup.content = self.dataManager.menJinValue;
    doorGroup.headerSize = headerSmallSize;
    doorGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    doorGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    
    doorGroup.minimumLineSpacing = horizonMargin;
    doorGroup.minimumInteritemSpacing = middleMargin;
    doorGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    doorGroup.editingEdgeInsets = paramterEdgeInsets;
    doorGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //领型
    TLGroup *lingXingGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:lingXingGroup];
    lingXingGroup.dataModelRoom = self.dataManager.lingXingRoom;
    lingXingGroup.title = @"领型";
    lingXingGroup.canEdit = [self.order canEditDingZhi];
    lingXingGroup.content = self.dataManager.lingXingValue;
    lingXingGroup.headerSize = headerSmallSize;
    lingXingGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    lingXingGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    
    lingXingGroup.minimumLineSpacing = horizonMargin;
    lingXingGroup.minimumInteritemSpacing = middleMargin;
    lingXingGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    lingXingGroup.editingEdgeInsets = paramterEdgeInsets;
    lingXingGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //袖型
    TLGroup *xiuXingGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:xiuXingGroup];
    xiuXingGroup.dataModelRoom = self.dataManager.xiuXingRoom;
    xiuXingGroup.title = @"袖型";
    xiuXingGroup.canEdit = [self.order canEditDingZhi];
    xiuXingGroup.content = self.dataManager.xiuXingValue;

    xiuXingGroup.headerSize = headerSmallSize;
    xiuXingGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    xiuXingGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    
    xiuXingGroup.minimumLineSpacing = horizonMargin;
    xiuXingGroup.minimumInteritemSpacing = middleMargin;
    xiuXingGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    xiuXingGroup.editingEdgeInsets = paramterEdgeInsets;
    xiuXingGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //口袋
    TLGroup *koudaiGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:koudaiGroup];
    koudaiGroup.dataModelRoom = self.dataManager.kouDaiRoom;
    koudaiGroup.title = @"口袋";
    koudaiGroup.canEdit = [self.order canEditDingZhi];
    koudaiGroup.content = self.dataManager.kouDaiValue;
    koudaiGroup.headerSize = headerSmallSize;
    koudaiGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    koudaiGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    
    koudaiGroup.minimumLineSpacing = horizonMargin;
    koudaiGroup.minimumInteritemSpacing = middleMargin;
    koudaiGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    koudaiGroup.editingEdgeInsets = paramterEdgeInsets;
    koudaiGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //
    TLGroup *shouXingGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:shouXingGroup];
    shouXingGroup.dataModelRoom = self.dataManager.shouXingRoom;
    shouXingGroup.title = @"收省";
    shouXingGroup.canEdit = [self.order canEditDingZhi];
    shouXingGroup.content = self.dataManager.shouXingValue;
    shouXingGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    shouXingGroup.headerSize = headerSmallSize;
    shouXingGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    shouXingGroup.minimumLineSpacing = horizonMargin;
    shouXingGroup.minimumInteritemSpacing = middleMargin;
    shouXingGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    shouXingGroup.editingEdgeInsets = paramterEdgeInsets;
    shouXingGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    
    //***********************刺绣内容**************************//
    TLGroup *ciXiuGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:ciXiuGroup];
    ciXiuGroup.dataModelRoom = [self.dataManager configDefaultModel];
    ciXiuGroup.title = @"刺绣定制信息";
    ciXiuGroup.headerSize = headerMiddleSize;
    ciXiuGroup.headerReuseIdentifier = [TLOrderBGTitleHeader headerReuseIdentifier];
    
    //内容
    TLGroup *ciXiuTextGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:ciXiuTextGroup];
    NSMutableArray *arr =  [[NSMutableArray alloc] initWithCapacity:1];
    [arr addObject:@1];
    ciXiuTextGroup.dataModelRoom = self.dataManager.ciXiuTextRoom;
    ciXiuTextGroup.title = @"刺绣内容";
    ciXiuTextGroup.canEdit = [self.order canEditDingZhi];
    ciXiuTextGroup.content = self.dataManager.ciXiuTextValue;
    ciXiuTextGroup.headerSize = headerSmallSize;
    ciXiuTextGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    ciXiuTextGroup.cellReuseIdentifier = [TLCiXiuTextInputCell cellReuseIdentifier];
    ciXiuTextGroup.minimumLineSpacing = horizonMargin;
    ciXiuTextGroup.minimumInteritemSpacing = middleMargin;
    ciXiuTextGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    ciXiuTextGroup.editingEdgeInsets = shouXingGroup.editedEdgeInsets;
    
    ciXiuTextGroup.itemSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    
    //字体
    TLGroup *ciXiuFontGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:ciXiuFontGroup];
    ciXiuFontGroup.dataModelRoom = self.dataManager.fontRoom;
    ciXiuFontGroup.title = @"刺绣字体";
    ciXiuFontGroup.canEdit = [self.order canEditDingZhi];
    ciXiuFontGroup.content = self.dataManager.fontValue;
    ciXiuFontGroup.headerSize = headerSmallSize;
    ciXiuFontGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    ciXiuFontGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    ciXiuFontGroup.minimumLineSpacing = horizonMargin;
    ciXiuFontGroup.minimumInteritemSpacing = middleMargin;
    ciXiuFontGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    ciXiuFontGroup.editingEdgeInsets = paramterEdgeInsets;
    ciXiuFontGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //位置
    TLGroup *ciXiuLocationGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:ciXiuLocationGroup];
    ciXiuLocationGroup.dataModelRoom = self.dataManager.ciXiuLocationRoom;
    ciXiuLocationGroup.title = @"刺绣位置";
    ciXiuLocationGroup.canEdit = [self.order canEditDingZhi];
    ciXiuLocationGroup.content = self.dataManager.ciXiuLocationValue;
    ciXiuLocationGroup.headerSize = headerSmallSize;
    ciXiuLocationGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    ciXiuLocationGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    ciXiuLocationGroup.minimumLineSpacing = horizonMargin;
    ciXiuLocationGroup.minimumInteritemSpacing = middleMargin;
    ciXiuLocationGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
    ciXiuLocationGroup.editingEdgeInsets = paramterEdgeInsets;
    ciXiuLocationGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //颜色
    TLGroup *ciXiuColorGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:ciXiuColorGroup];
    ciXiuColorGroup.dataModelRoom = self.dataManager.ciXiuColorRoom;
    ciXiuColorGroup.title = @"刺绣颜色";
    ciXiuColorGroup.content = self.dataManager.ciXiuColorValue;
    ciXiuColorGroup.headerSize = headerSmallSize;
    ciXiuColorGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
    ciXiuColorGroup.canEdit = [self.order canEditDingZhi];
    ciXiuColorGroup.cellReuseIdentifier = [TLColorChooseCell cellReuseIdentifier];
    ciXiuColorGroup.minimumLineSpacing = 11;
    ciXiuColorGroup.minimumInteritemSpacing = 15;
    ciXiuColorGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 35);
    ciXiuColorGroup.editingEdgeInsets = UIEdgeInsetsMake(15, 35, 0, 35);
    CGFloat colorChooseCellWidth = (SCREEN_WIDTH - ciXiuColorGroup.edgeInsets.left * 2 - 2* ciXiuColorGroup.minimumLineSpacing - 10)/3.0;
    ciXiuColorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);

    
    //收货地址
    TLGroup *receiveGroup = [[TLGroup alloc] init];
    if (self.order.canEditDingZhi) {
        [self.dataManager.groups addObject:receiveGroup];
    }
    receiveGroup.dataModelRoom = self.dataManager.shouHuoAddressRoom;
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
    
    //
    TLGroup *remarkGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:remarkGroup];
    remarkGroup.dataModelRoom = self.dataManager.remarkRoom;
    remarkGroup.title = @"备注";
    remarkGroup.content = self.dataManager.remarkValue;
    remarkGroup.editting = YES;
    remarkGroup.headerSize = headerSmallSize;
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
    
    
     [self.orderDetailCollectionView registerClass:[TLButtonHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLButtonHeaderView headerReuseIdentifier]];
    
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
