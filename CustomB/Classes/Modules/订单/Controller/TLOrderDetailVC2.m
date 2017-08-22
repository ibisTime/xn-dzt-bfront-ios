//
//  TLOrderDetailVC2.m
//  CustomB
//
//  Created by  tianlei on 2017/8/22.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLOrderDetailVC2.h"
#import "TLUIHeader.h"
#import "TLOrderCollectionViewHeader.h"
#import "TLOrderCustom1Cell.h"
#import "TLOrderDataManager.h"
#import "TLOrderDetailCell.h"
#import "TLOrderStyleCell.h"

#import "TLOrderParameterCell.h"
#import "TLColorChooseCell.h"


@interface TLOrderDetailVC2 ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TLOrderEditHeaderDelegate>

@property (nonatomic, strong)  TLOrderDataManager *dataManager;
@property (nonatomic, strong) UICollectionView *orderDetailCollectionView;

@end

@implementation TLOrderDetailVC2


- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"订单详情";
    
    [self setUpUI];
    
    self.dataManager = [[TLOrderDataManager alloc] init];
    self.dataManager.groups = [[NSMutableArray alloc] init];
    
    CGFloat horizonMargin = 18;
    CGFloat middleMargin = 15;
//    UIEdgeInsets paramterEdgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);
    UIEdgeInsets paramterEdgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);


    NSInteger testItemCount = 0;
    //
    TLGroup *styleGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:styleGroup];
    styleGroup.title = @"风格";
    styleGroup.itemCount = testItemCount;
    styleGroup.cellReuseIdentifier = [TLOrderStyleCell cellReuseIdentifier];
    styleGroup.minimumLineSpacing = 18;
    styleGroup.minimumInteritemSpacing = 15;
    styleGroup.edgeInsets = UIEdgeInsetsMake(15, 32, 0, 32);
    CGFloat w = (SCREEN_WIDTH - styleGroup.edgeInsets.left * 2 - 2* styleGroup.minimumLineSpacing)/3.0;
    styleGroup.itemSize = CGSizeMake(w, 30);

    
    //
    CGFloat parameterCellWidth = (SCREEN_WIDTH - styleGroup.edgeInsets.left * 2 - 2* styleGroup.minimumLineSpacing)/3.0;

    TLGroup *parameterGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:parameterGroup];
    parameterGroup.title = @"规格";
    parameterGroup.itemCount = testItemCount;
    parameterGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    parameterGroup.minimumLineSpacing = horizonMargin;
    parameterGroup.minimumInteritemSpacing = middleMargin;
    parameterGroup.edgeInsets = paramterEdgeInsets;
    parameterGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //门禁
    TLGroup *doorGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:doorGroup];
    doorGroup.title = @"门禁";
    doorGroup.itemCount = testItemCount;
    doorGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    doorGroup.minimumLineSpacing = horizonMargin;
    doorGroup.minimumInteritemSpacing = middleMargin;
    doorGroup.edgeInsets = paramterEdgeInsets;
    doorGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //领型
    TLGroup *lingXingGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:lingXingGroup];
    lingXingGroup.title = @"领型";
    lingXingGroup.itemCount = testItemCount;
    lingXingGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    lingXingGroup.minimumLineSpacing = horizonMargin;
    lingXingGroup.minimumInteritemSpacing = middleMargin;
    lingXingGroup.edgeInsets = paramterEdgeInsets;
    lingXingGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
     //袖型
    TLGroup *xiuXingGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:xiuXingGroup];
    xiuXingGroup.title = @"袖型";
    xiuXingGroup.itemCount = testItemCount;
    xiuXingGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    xiuXingGroup.minimumLineSpacing = horizonMargin;
    xiuXingGroup.minimumInteritemSpacing = middleMargin;
    xiuXingGroup.edgeInsets = paramterEdgeInsets;
    xiuXingGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);

   //口袋
    TLGroup *koudaiGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:koudaiGroup];
    koudaiGroup.title = @"口袋";
    koudaiGroup.itemCount = testItemCount;
    koudaiGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    koudaiGroup.minimumLineSpacing = horizonMargin;
    koudaiGroup.minimumInteritemSpacing = middleMargin;
    koudaiGroup.edgeInsets = paramterEdgeInsets;
    koudaiGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //
    TLGroup *shouXingGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:shouXingGroup];
    shouXingGroup.title = @"收省";
    shouXingGroup.itemCount = testItemCount;
    shouXingGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    shouXingGroup.minimumLineSpacing = horizonMargin;
    shouXingGroup.minimumInteritemSpacing = middleMargin;
    shouXingGroup.edgeInsets = paramterEdgeInsets;
    shouXingGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);

    
    //刺绣内容
    
    //字体
    TLGroup *ciXiuFontGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:ciXiuFontGroup];
    ciXiuFontGroup.title = @"刺绣字体";
    ciXiuFontGroup.itemCount = testItemCount;
    ciXiuFontGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    ciXiuFontGroup.minimumLineSpacing = horizonMargin;
    ciXiuFontGroup.minimumInteritemSpacing = middleMargin;
    ciXiuFontGroup.edgeInsets = paramterEdgeInsets;
    ciXiuFontGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //位置
    TLGroup *ciXiuLocationGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:ciXiuLocationGroup];
    ciXiuLocationGroup.title = @"刺绣位置";
    ciXiuLocationGroup.itemCount = testItemCount;
    ciXiuLocationGroup.cellReuseIdentifier = [TLOrderParameterCell cellReuseIdentifier];
    ciXiuLocationGroup.minimumLineSpacing = horizonMargin;
    ciXiuLocationGroup.minimumInteritemSpacing = middleMargin;
    ciXiuLocationGroup.edgeInsets = paramterEdgeInsets;
    ciXiuLocationGroup.itemSize = CGSizeMake(parameterCellWidth, parameterCellWidth);
    
    //颜色
    TLGroup *ciXiuColorGroup = [[TLGroup alloc] init];
    [self.dataManager.groups addObject:ciXiuColorGroup];
    ciXiuColorGroup.title = @"刺绣颜色";
    ciXiuColorGroup.itemCount = testItemCount;
    ciXiuColorGroup.cellReuseIdentifier = [TLColorChooseCell cellReuseIdentifier];
    ciXiuColorGroup.minimumLineSpacing = 11;
    ciXiuColorGroup.minimumInteritemSpacing = 15;
    ciXiuColorGroup.edgeInsets = UIEdgeInsetsMake(15, 35, 0, 35);
    
    CGFloat colorChooseCellWidth = (SCREEN_WIDTH - ciXiuColorGroup.edgeInsets.left * 2 - 2* ciXiuColorGroup.minimumLineSpacing - 10)/3.0;
    
    ciXiuColorGroup.itemSize = CGSizeMake(colorChooseCellWidth, 30);
    

   

    //订单信息
    //物流信息
    //客户
    //量体
    //形体


    //门禁
    //领型
    //袖型
    //口袋
    //收省
    
    //2.刺绣定制信息
     //刺绣内容
     //字体
     //位置
     //颜色
    
    //3.备注
    
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
    //
    [orderDetailCollectionView registerClass:[TLOrderCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TLOrderCollectionViewHeader headerReuseIdentifier]];
    
    //1.定制信息
    //风格
    [orderDetailCollectionView registerClass:[TLOrderStyleCell class] forCellWithReuseIdentifier:[TLOrderStyleCell cellReuseIdentifier]];
    //规格
    [orderDetailCollectionView registerClass:[TLOrderParameterCell class] forCellWithReuseIdentifier:[TLOrderParameterCell cellReuseIdentifier]];
    
    //颜色选中
      [orderDetailCollectionView registerClass:[TLColorChooseCell class] forCellWithReuseIdentifier:[TLColorChooseCell cellReuseIdentifier]];
    

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
    
    return CGSizeMake(SCREEN_WIDTH, 45);
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    
//    return CGSizeMake(SCREEN_WIDTH, 0.01);
//    
//}




#pragma mark-  TLOrderEditHeaderDelegate
- (void)actionWithView:(TLOrderCollectionViewHeader *)reusableView type:(EditType)type {

    switch (type) {
        case EditTypeGoEdit: {
            [reusableView editing];
            
            self.dataManager.groups[reusableView.section].itemCount = 3;
            self.dataManager.groups[reusableView.section].editting = YES;
            [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];
            
        } break;
        case EditTypeConfirm: {
            [reusableView edited];
            
            self.dataManager.groups[reusableView.section].itemCount = 0;
            self.dataManager.groups[reusableView.section].editting = NO;

            [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];
            
        } break;
        case EditTypeCancle: {
            [reusableView edited];

            self.dataManager.groups[reusableView.section].itemCount = 0;
            self.dataManager.groups[reusableView.section].editting = NO;
            [self.orderDetailCollectionView reloadSections:[NSIndexSet indexSetWithIndex:reusableView.section]];

        } break;
    }

}






#pragma mark- UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    TLOrderCollectionViewHeader *header = (TLOrderCollectionViewHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          
                                                                        withReuseIdentifier:[TLOrderCollectionViewHeader headerReuseIdentifier]
                                                                                                                   forIndexPath:indexPath];
    header.delegate = self;
    header.titleLbl.text = self.dataManager.groups[indexPath.section].title;
    header.section = indexPath.section;
    if (self.dataManager.groups[indexPath.section].editting) {
        
        [header editing];
        
    } else {
    
        [header edited];

    }

    return header;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    
    return self.dataManager.groups[section].itemCount;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = self.dataManager.groups[indexPath.section].cellReuseIdentifier;
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                        forIndexPath:indexPath];
    

    return cell;

}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.dataManager.groups.count;

}

@end
