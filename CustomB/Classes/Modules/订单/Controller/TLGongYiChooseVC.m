//
//  TLOrderDetailVC2.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLGongYiChooseVC.h"
#import "TLUIHeader.h"
#import "TLOrderModel.h"
#import "TLInputDataModel.h"

#import "TLOrderCollectionViewHeader.h"
#import "TLOrderBigTitleHeader.h"
#import "TLOrderBGTitleHeader.h"
#import "TLOrderDoubleTitleHeader.h"
//#import "TLSwitchHeaderView.h"

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
#import "NSNumber+TLAdd.h"
#import "NSString+Extension.h"
#import "TLGuiGeDaLei.h"
#import "TLUIHeader.h"

#define CI_XIU_MARK @"CI_XIU_MARK"
#define DA_LEI_COLOR_MARK @"DA_LEI_COLOR_MARK"


@interface TLGongYiChooseVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate,TLButtonHeaderViewDelegate>

@property (nonatomic, strong)  TLOrderDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *orderDetailCollectionView;

//@property (nonatomic, strong) TLGroup *totalPriceGroup;
//@property (nonatomic, strong) TLGroup *cixiuGroup;

@property (nonatomic, strong) TLGroup *cixiuTextGroup;


@end


@implementation TLGongYiChooseVC

- (TLOrderDataManager *)dataManager {

    if (!_dataManager) {
        
        _dataManager = [[TLOrderDataManager alloc] init];
        _dataManager.order = self.order;
    }
    
    return _dataManager;

}
#pragma mark- 提交
- (void)trueSubmit {
    
    //判断是否编辑
    [self.dataManager.groups enumerateObjectsUsingBlock:^(TLGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.shouldCheckEdit && obj.editting) {
            
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"#%@# 还处于编辑状态,请确定",obj.title] reason:nil userInfo:nil];
        }
    }];
 
    //1.检测工艺是非为空
    NSMutableArray <TLGuiGeXiaoLei *> *guiGeXiaoLeiArr = [[NSMutableArray alloc] init];
    
    //字符串 改为字典
    NSMutableDictionary *cixiuDict = [[NSMutableDictionary alloc] init];
    
    //怎样判断规格已经选择
    [self.dataManager.groups enumerateObjectsUsingBlock:^(TLGroup * _Nonnull group, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (group.mark && ([group.mark isEqualToString:CI_XIU_MARK] || [group.mark isEqualToString:DA_LEI_COLOR_MARK])) {
            //过滤掉刺绣内容
            return ;
        }
        
        //先判断普通规则
       __block TLParameterModel *currentSelectedParameterModel = nil;
        [group.dataModelRoom enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TLParameterModel *parameterModel = obj;
            if (parameterModel.isSelected) {
                
                TLParameterModel *parameterModel = obj;
                [guiGeXiaoLeiArr addObject:parameterModel.dataModel];
                currentSelectedParameterModel = parameterModel;
                *stop = YES;
                
            } else if (idx == group.dataModelRoom.count - 1) {
            
                //到这里规格肯定未选择
                @throw [NSException exceptionWithName:[NSString stringWithFormat:@"请选择%@",group.title] reason:nil userInfo:nil];
            }

        }];
        
        //判断该组是否有颜色标识
        TLGuiGeXiaoLei *currentSelectedXiaoLeiModel = currentSelectedParameterModel.dataModel;
        if (group.dateModel && [(TLGuiGeDaLei *)group.dateModel isHaveColorMark] && currentSelectedXiaoLeiModel.xiaoLeiType == GuiGeXiaoLeiTypeDefault/* 选中的产品不是无*/) {
            
            //找出颜色的组
            TLGroup *colorGroup = self.dataManager.groups[idx + 1];
            
            [colorGroup.dataModelRoom enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                TLParameterModel *parameterModel = obj;
                if (parameterModel.isSelected) {
                    
                    [guiGeXiaoLeiArr addObject:parameterModel.dataModel];
                    *stop = YES;
                    
                } else if (idx == colorGroup.dataModelRoom.count - 1) {
                    
                    //到这里规格肯定未选择
                    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"请选择%@",colorGroup.title] reason:nil userInfo:nil];
                }
                
            }];

        }
        
        
    }];
    
    //刺绣
    //判断产品是否有刺绣,
    if (self.cixiuTextGroup
        && self.cixiuTextGroup.content
        && self.cixiuTextGroup.content.length > 0) {
        
        [self.dataManager.groups enumerateObjectsUsingBlock:^(TLGroup * _Nonnull group, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (group.mark && [group.mark isEqualToString:CI_XIU_MARK] && ![group isEqual:self.cixiuTextGroup]) {
                //
                //过滤掉刺绣内容
                [group.dataModelRoom enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    TLParameterModel *parameterModel = obj;
                    if (parameterModel.isSelected) {
                        
                        TLParameterModel *parameterModel = obj;
                        [guiGeXiaoLeiArr addObject:parameterModel.dataModel];
                        *stop = YES;
                        
                    } else if (idx == group.dataModelRoom.count - 1) {
                        
                        //到这里规格肯定未选择
                        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"请选择%@",group.title] reason:nil userInfo:nil];
                    }
                    
                }];
            }
            
        }
       ];
        
        TLGuiGeDaLei *cixiuTextDaLei = self.cixiuTextGroup.dateModel;
        if (self.cixiuTextGroup.content) {
            
            cixiuDict[cixiuTextDaLei.dkey] = self.cixiuTextGroup.content;
            
        }
        
        //call delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishChooseWith:ciXiuDict:vc:)]) {
            
            [self.delegate didFinishChooseWith:guiGeXiaoLeiArr ciXiuDict:cixiuDict ? : nil vc:self];
            
        }
        
    } else {
    
        if (self.cixiuTextGroup) {
            
            //未选择刺绣
            [TLAlert alertWithTitle:@"刺绣内容未填写" Message:@"您确定不需要刺绣吗" confirmMsg:@"确定" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
                
            } confirm:^(UIAlertAction *action) {
                
                ///call delegate
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishChooseWith:ciXiuDict:vc:)]) {
                    
                    [self.delegate didFinishChooseWith:guiGeXiaoLeiArr ciXiuDict:cixiuDict ? : nil vc:self];
                    
                }
                
            }];
            
        } else {
        
            ///call delegate
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishChooseWith:ciXiuDict:vc:)]) {
                
                [self.delegate didFinishChooseWith:guiGeXiaoLeiArr ciXiuDict:cixiuDict ? : nil vc:self];
                
            }
        
        }
     
    
    }
    

    
}




#pragma mark- TLButtonHeaderViewDelegate
- (void)didSelected:(TLButtonHeaderView *)btnHeaderView section:(NSInteger)secction {

    @try {
        
        [self trueSubmit];
        
    } @catch (NSException *exception) {
        
        if (exception.name && exception.name.length > 0) {
            
            [TLAlert alertWithError:exception.name];

        }
        
    } @finally {
        
    }
    
}

//--//
- (void)tl_placeholderOperation {

    //获取刺绣和 定制信息的选项, 根据不通的产品获得
    [TLProgressHUD showWithStatus:nil];
    NBCDRequest *req = [[NBCDRequest alloc] init];
    req.code = @"620054";
    req.parameters[@"modelCode"] =  self.innerProduct.code;
    req.parameters[@"status"] = @"1";
    
    //
    NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[req]];
    [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
        
        [self removePlaceholderView];
        [TLProgressHUD dismiss];

        NBCDRequest *chooseReq = (NBCDRequest *)batchRequest.reqArray[0];
        
        //定制信息
//        [self.dataManager handleParameterData:chooseReq.responseObject];
        
        //面料选择
        [self setUpUI];
        [self registerClass];
        
        //配置Model
        [self configModel];
        
    } failure:^(NBBatchReqest *batchRequest) {
        
        [TLProgressHUD dismiss];
        [self addPlaceholderView];

    }];


}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"工艺选择";
    
    //获取全部选择参数，除布料外
    if (!self.innerProduct) {
        NSLog(@"产品不能为空");
    }

    //面料选择
    [self setUpUI];
    [self registerClass];
    
    //配置Model
    [self configModel];
    
}

- (NSString *)getContentStrWith:(TLGuiGeXiaoLei *)guiGeXiaoLei {

    return  [NSString stringWithFormat:@"%@（￥%@）",guiGeXiaoLei.name,[guiGeXiaoLei.price convertToRealMoney]];
    
}

- (void)configModel {
    
    CGSize headerBigSize = CGSizeMake(SCREEN_WIDTH, 75);
    CGSize headerMiddleSize = CGSizeMake(SCREEN_WIDTH, 45);
    CGSize headerSmallSize = CGSizeMake(SCREEN_WIDTH, 45);
    
    //***********定制信息 ******************************//
    CGFloat horizonMargin = 18;
    CGFloat middleMargin = 15;
    UIEdgeInsets paramterEdgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);
    CGFloat parameterCellWidth = (SCREEN_WIDTH - paramterEdgeInsets.left * 2 - 2*horizonMargin)/3.0;
    
    //switch
//    TLGroup *switchGroup = [[TLGroup alloc] init];
//    [self.dataManager.groups addObject:switchGroup];
//    switchGroup.dataModelRoom = [[NSMutableArray alloc] init];
//    switchGroup.headerSize = headerSmallSize;
//    switchGroup.headerReuseIdentifier = [TLSwitchHeaderView headerReuseIdentifier];
    
    //
    TLGroup *dingZhiGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:dingZhiGroup];
    dingZhiGroup.shouldCheckEdit = NO;
    dingZhiGroup.dataModelRoom = [self.dataManager configDefaultModel];
    dingZhiGroup.title = @"定制信息";
    dingZhiGroup.headerSize = headerBigSize;
    dingZhiGroup.headerReuseIdentifier = [TLOrderDoubleTitleHeader headerReuseIdentifier];
    
    //装载规格的大类
    NSMutableArray <TLGuiGeDaLei *> *cixiuGuiGeDaLeiRoom = [[NSMutableArray alloc] init];
    
    //遍历所有大类
    [self.innerProduct.res.productCategoryList enumerateObjectsUsingBlock:^(TLGuiGeDaLei * _Nonnull guiGeDaLei, NSUInteger idx, BOOL * _Nonnull stop) {
        
        switch (guiGeDaLei.guiGeLeiBie) {
            case GuiGeDaLeiTypeDefaultGongYi: {
            
                TLGroup *parameterGroup = [[TLGroup alloc] init];
                [self.dataManager.groups addObject:parameterGroup];
                parameterGroup.dateModel = guiGeDaLei;
                NSMutableArray *xiaoLeiRoom = [[NSMutableArray alloc] init];
                [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull guiGeXiaoLei, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                    parameterModel.pic = guiGeXiaoLei.pic;
                    parameterModel.selectPic = guiGeXiaoLei.selectedPic;
                    parameterModel.name = guiGeXiaoLei.name;
                    parameterModel.dataModel = guiGeXiaoLei;
                    //
                    
                    if (guiGeXiaoLei.isSelected) {
                        //
                        parameterGroup.content = [self getContentStrWith:guiGeXiaoLei];
                        //
                    }
                    parameterModel.yuSelected = guiGeXiaoLei.isSelected;
                    parameterModel.isSelected = guiGeXiaoLei.isSelected;
                    //
                    [xiaoLeiRoom addObject:parameterModel];
                    
                }];
                //
                parameterGroup.dataModelRoom = xiaoLeiRoom;
                parameterGroup.title = guiGeDaLei.dvalue;
                parameterGroup.canEdit = YES;
                parameterGroup.headerSize = headerSmallSize;
                parameterGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
                parameterGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                parameterGroup.minimumLineSpacing = horizonMargin;
                parameterGroup.minimumInteritemSpacing = middleMargin;
                parameterGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
                parameterGroup.editingEdgeInsets = paramterEdgeInsets;
                parameterGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
                
                //判断是否有颜色标识
                if ([guiGeDaLei isHaveColorMark]) {
                    
                    
                    TLGroup *colorGroup = [[TLGroup alloc] init];
                    colorGroup.mark = DA_LEI_COLOR_MARK;
                    [self.dataManager.groups addObject:colorGroup];
                    NSMutableArray *colorRoom = [[NSMutableArray alloc] init];
                    [guiGeDaLei.colorPcList[0].colorCraftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull guiGeXiaoLei, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                        parameterModel.pic = guiGeXiaoLei.pic;
                        parameterModel.selectPic = guiGeXiaoLei.selectedPic;
                        parameterModel.dataModel = guiGeXiaoLei;
                        parameterModel.name = guiGeXiaoLei.name;
                        //
                        if (guiGeXiaoLei.isSelected) {
                            colorGroup.content = [self getContentStrWith:guiGeXiaoLei];
                        }
                        parameterModel.yuSelected = guiGeXiaoLei.isSelected;
                        parameterModel.isSelected = guiGeXiaoLei.isSelected;
                        //
                        [colorRoom addObject:parameterModel];
                        
                    }];
                    colorGroup.dataModelRoom = colorRoom;
                    colorGroup.title = guiGeDaLei.colorPcList[0].name;
                    colorGroup.headerSize = headerSmallSize;
                    colorGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                    colorGroup.canEdit = YES;
                    colorGroup.cellReuseIdentifier = [TLColorChooseCell cellReuseIdentifier];
                    colorGroup.minimumLineSpacing = 11;
                    colorGroup.minimumInteritemSpacing = 15;
                    colorGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 35);
                    colorGroup.editingEdgeInsets = UIEdgeInsetsMake(15, 35, 10, 35);
                    CGFloat colorChooseCellWidth = (SCREEN_WIDTH - colorGroup.edgeInsets.left * 2 - 2* colorGroup.minimumLineSpacing - 10)/3.0;
                    colorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);
                    colorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);
                    
                }
                
            }  break;
                
            // 着装风格
            case GuiGeDaLeiTypeZhuoZhuangFengGe: {
                
                
                TLGroup *styleGroup = [[TLGroup alloc] init];
                [self.dataManager.groups addObject:styleGroup];
                NSMutableArray *styleRoom = [[NSMutableArray alloc] init];
                
                [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull guiGeXiaoLei, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                    parameterModel.name = guiGeXiaoLei.name;
                    parameterModel.dataModel = guiGeXiaoLei;
                    if (guiGeXiaoLei.isSelected) {
                        styleGroup.content = [self getContentStrWith:guiGeXiaoLei]
                        ;
                    }
                    parameterModel.yuSelected = guiGeXiaoLei.isSelected;
                    parameterModel.isSelected = guiGeXiaoLei.isSelected;
                    [styleRoom addObject:parameterModel];
                    
                }];
                
                styleGroup.dataModelRoom = styleRoom;
                styleGroup.title = @"着装风格";
                styleGroup.canEdit = YES;
                styleGroup.headerSize = headerSmallSize;
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
    
    if (cixiuGuiGeDaLeiRoom.count > 0) {
        
//        [self.dataManager handleCiXiu:cixiuGuiGeDaLeiRoom];
        //***********************刺绣内容**************************//
        TLGroup *ciXiuGroup = [[TLGroup alloc] init];
        [self.dataManager.groups addObject:ciXiuGroup];
        ciXiuGroup.dataModelRoom = [self.dataManager configDefaultModel];
        
        ciXiuGroup.title = @"刺绣定制信息";
        ciXiuGroup.shouldCheckEdit = NO;
        ciXiuGroup.headerSize = headerMiddleSize;
        ciXiuGroup.headerReuseIdentifier = [TLOrderBGTitleHeader headerReuseIdentifier];
        
        [cixiuGuiGeDaLeiRoom enumerateObjectsUsingBlock:^(TLGuiGeDaLei * _Nonnull guiGeDaLei, NSUInteger idx, BOOL * _Nonnull stop) {
            
            switch (guiGeDaLei.guiGeLeiBie) {
                case GuiGeDaLeiTypeCiXiuText: {
                
                    //内容
                    TLGroup *ciXiuTextGroup = [[TLGroup alloc] init];
                    [self.dataManager.groups addObject:ciXiuTextGroup];
                    NSMutableArray *arr =  [[NSMutableArray alloc] initWithCapacity:1];
                    [arr addObject:@1];
                    self.cixiuTextGroup = ciXiuTextGroup;
                    ciXiuTextGroup.dateModel = guiGeDaLei;
                    
                    TLInputDataModel *inputDataModel =  [[TLInputDataModel alloc] init];
                    if (self.innerProduct.ciXiuDict) {
                        NSDictionary *ciXiuDict = self.innerProduct.ciXiuDict;
                        if (ciXiuDict.allKeys && ciXiuDict.allKeys.count > 0) {
                            
                            inputDataModel.value = ciXiuDict[ciXiuDict.allKeys[0]];
                            ciXiuTextGroup.content = inputDataModel.value;
                        }
                    }
                    ciXiuTextGroup.dataModelRoom = @[inputDataModel].mutableCopy;
                    //单独处理，与订单的处理方式不同
                    TLInputDataModel *dataModelRoomOneModel = ciXiuTextGroup.dataModelRoom[0];
                    dataModelRoomOneModel.canEdit = YES;
                    ciXiuTextGroup.mark = CI_XIU_MARK;
                    ciXiuTextGroup.title = @"刺绣内容";
                    ciXiuTextGroup.canEdit = YES;
                    ciXiuTextGroup.headerSize = headerSmallSize;
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
                    [self.dataManager.groups addObject:ciXiuColorGroup];
                    
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull guiGeXiaoLei, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                        parameterModel.name = guiGeXiaoLei.name;
                        parameterModel.pic = guiGeXiaoLei.pic;
                        parameterModel.selectPic = guiGeXiaoLei.selectedPic;
                        parameterModel.dataModel = guiGeXiaoLei;
                        
                        if (guiGeXiaoLei.isSelected) {
                            ciXiuColorGroup.content = [self getContentStrWith:guiGeXiaoLei];
                            parameterModel.yuSelected = guiGeXiaoLei.isSelected;
                            parameterModel.isSelected = guiGeXiaoLei.isSelected;
                        }
                 
                        [arr addObject:parameterModel];
                        
                    }];
                    
                    ciXiuColorGroup.dataModelRoom = arr;
                    ciXiuColorGroup.title = @"刺绣颜色";
                    ciXiuColorGroup.headerSize = headerSmallSize;
                    ciXiuColorGroup.headerReuseIdentifier = [TLOrderCollectionViewHeader headerReuseIdentifier];
                    ciXiuColorGroup.mark = CI_XIU_MARK;
                    ciXiuColorGroup.canEdit = YES;
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
                    [self.dataManager.groups addObject:ciXiuLocationGroup];
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [guiGeDaLei.craftList enumerateObjectsUsingBlock:^(TLGuiGeXiaoLei * _Nonnull guiGeXiaoLei, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        TLParameterModel *parameterModel = [[TLParameterModel alloc] init];
                        parameterModel.name = guiGeXiaoLei.name;
                        parameterModel.pic = guiGeXiaoLei.pic;
                        parameterModel.selectPic = guiGeXiaoLei.selectedPic;
                        parameterModel.dataModel = guiGeXiaoLei;
                        //
                        if (guiGeXiaoLei.isSelected) {

                            ciXiuLocationGroup.content = [self getContentStrWith:guiGeXiaoLei];
                            parameterModel.yuSelected = guiGeXiaoLei.isSelected;
                            parameterModel.isSelected = guiGeXiaoLei.isSelected;
                        }
                        //
                        [arr addObject:parameterModel];
                        
                    }];
                    ciXiuLocationGroup.dataModelRoom = arr;
                    ciXiuLocationGroup.title = guiGeDaLei.dvalue;
                    ciXiuLocationGroup.mark = CI_XIU_MARK;
                    ciXiuLocationGroup.canEdit = YES;
                    ciXiuLocationGroup.headerSize = headerSmallSize;
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
    
    
    //刺绣应该单独拿出
    
    

    
    //按钮
   //确定按钮
        TLGroup *confirmBtnGroup = [[TLGroup alloc] init];
        confirmBtnGroup.canEdit = NO;
        confirmBtnGroup.dataModelRoom = [NSMutableArray new];
        [self.dataManager.groups addObject:confirmBtnGroup];
        confirmBtnGroup.title = @"确定";
    confirmBtnGroup.shouldCheckEdit = NO;
        confirmBtnGroup.headerSize = CGSizeMake(SCREEN_WIDTH, 80);
        confirmBtnGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
        confirmBtnGroup.headerReuseIdentifier = [TLButtonHeaderView headerReuseIdentifier];
        confirmBtnGroup.minimumLineSpacing = horizonMargin;
        confirmBtnGroup.minimumInteritemSpacing = middleMargin;
        confirmBtnGroup.editedEdgeInsets = UIEdgeInsetsMake(0, paramterEdgeInsets.left, paramterEdgeInsets.bottom, paramterEdgeInsets.right);
        confirmBtnGroup.editingEdgeInsets = paramterEdgeInsets;
        confirmBtnGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
//    [self.dataManager.groups enumerateObjectsUsingBlock:^(TLGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.editting = YES;
//    }];
    
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
    [orderDetailCollectionView adjustsContentInsets];
}


- (void)registerClass {
    
//      [self.orderDetailCollectionView registerClass:[TLSwitchHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLSwitchHeaderView headerReuseIdentifier]];
    //
    [self.orderDetailCollectionView registerClass:[TLOrderCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLOrderCollectionViewHeader headerReuseIdentifier]];
    
      [self.orderDetailCollectionView registerClass:[TLButtonHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLButtonHeaderView headerReuseIdentifier]];
    
    
    
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
                TLGuiGeDaLei *guiGeDaLei = group.dateModel;
                
                [models enumerateObjectsUsingBlock:^(TLParameterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TLGuiGeXiaoLei *guiGeXiaoLei = obj.dataModel;
                    //
                    if (obj.yuSelected) {
                        
                        //__________//
                        //专一找出颜色
                        TLGuiGeXiaoLei *guiGeXiaoLei = obj.dataModel;
                        if (guiGeDaLei.guiGeLeiBie == GuiGeDaLeiTypeDefaultGongYi
                            && guiGeDaLei.colorPcList && guiGeDaLei.colorPcList.count > 0) {
                            
                            //这个规格小类不需要提醒
                            TLGroup *nextGrop = self.dataManager.groups[reusableView.section + 1];
                            if ([guiGeXiaoLei.isHit isEqualToString:@"0"]) {
                                
                                [nextGrop groupSetHidden];

                            } else {
                            
                                [nextGrop groupSetShow];

                            }
                          
                            
                        }//_______//
                        
                        obj.isSelected = YES;
                        guiGeXiaoLei.isSelected = obj.isSelected;
                        group.content = [self getContentStrWith:guiGeXiaoLei];
                        
                    } else {
                        
                        obj.isSelected = NO;
                        guiGeXiaoLei.isSelected = obj.isSelected;
                        
                    }
                    
                }];
                
            }
            
            
            [self.orderDetailCollectionView reloadData];

            
            [UIView animateWithDuration:0 animations:^{
                [self.orderDetailCollectionView  performBatchUpdates:^{
//
//                    [self.orderDetailCollectionView reloadData];
////                    [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];
//                    
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
