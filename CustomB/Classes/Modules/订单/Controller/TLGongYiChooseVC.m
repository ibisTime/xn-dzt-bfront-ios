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


@interface TLGongYiChooseVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate>

@property (nonatomic, strong)  TLOrderDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *orderDetailCollectionView;
@property (nonatomic, strong) TLOrderModel *order;

@end


@implementation TLGongYiChooseVC
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
 
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //获取全部选择参数，除布料外
    if (!self.productCode) {
        NSLog(@"产品编号不能为空");
    }
    
    
    //获取刺绣和 定制信息的选项
    NBCDRequest *req = [[NBCDRequest alloc] init];
    req.code = @"620054";
    req.parameters[@"modelCode"] =  self.productCode;
    req.parameters[@"status"] = @"1";
    //面料
    NBCDRequest *mianLiaoReq = [[NBCDRequest alloc] init];
    mianLiaoReq.code = @"620032";
    mianLiaoReq.parameters[@"modelCode"] = self.productCode;
    mianLiaoReq.parameters[@"status"] = @"1";
    
    //
    NBBatchReqest *batchReq = [[NBBatchReqest alloc] initWithReqArray:@[req,mianLiaoReq]];
    [batchReq startWithSuccess:^(NBBatchReqest *batchRequest) {
        
        NBCDRequest *chooseReq = (NBCDRequest *)batchRequest.reqArray[0];
        NBCDRequest *mianLiaoReq = (NBCDRequest *)batchRequest.reqArray[1];
        
        //初始化
        self.dataManager = [[TLOrderDataManager alloc] init];
        //
        [self.dataManager handleParameterData:chooseReq.responseObject];
        [self.dataManager handleMianLiaoData:mianLiaoReq.responseObject];
        //
        [self setUpUI];
        [self registerClass];
        //配置Model
        [self configModel];
        
    } failure:^(NBBatchReqest *batchRequest) {
        
    }];
    
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
    styleGroup.canEdit = [self.order canEdit];
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
    mianLiaoRoom.canEdit = [self.order canEdit];
    [self.dataManager.groups addObject:mianLiaoRoom];
    mianLiaoRoom.dataModelRoom = self.dataManager.mianLiaoRoom;
    mianLiaoRoom.title = @"面料";
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
    parameterGroup.canEdit = [self.order canEdit];
    
    
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
    doorGroup.canEdit = [self.order canEdit];
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
    lingXingGroup.canEdit = [self.order canEdit];
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
    xiuXingGroup.canEdit = [self.order canEdit];
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
    koudaiGroup.canEdit = [self.order canEdit];
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
    shouXingGroup.canEdit = [self.order canEdit];
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
    ciXiuTextGroup.canEdit = [self.order canEdit];
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
    ciXiuFontGroup.canEdit = [self.order canEdit];
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
    ciXiuLocationGroup.canEdit = [self.order canEdit];
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
    ciXiuColorGroup.canEdit = [self.order canEdit];
    ciXiuColorGroup.cellReuseIdentifier = [TLColorChooseCell cellReuseIdentifier];
    ciXiuColorGroup.minimumLineSpacing = 11;
    ciXiuColorGroup.minimumInteritemSpacing = 15;
    ciXiuColorGroup.editedEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 35);
    ciXiuColorGroup.editingEdgeInsets = UIEdgeInsetsMake(15, 35, 0, 35);
    CGFloat colorChooseCellWidth = (SCREEN_WIDTH - ciXiuColorGroup.edgeInsets.left * 2 - 2* ciXiuColorGroup.minimumLineSpacing - 10)/3.0;
    ciXiuColorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);
    

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
