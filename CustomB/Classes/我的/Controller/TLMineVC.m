//
//  TLMineVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLMineVC.h"
#import "TLUIHeader.h"
#import "UIImageView+WebCache.h"
#import "TLSettingCell.h"
#import "TLSettingModel.h"

@interface TLMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mineTableView;
//
@property (nonatomic, strong) UIImageView *userPhotoImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UIView *levelView;
@property (nonatomic, strong) UILabel *professionalTitleLbl;

@property (nonatomic, copy) NSArray <TLSettingModel *>*models;

@end

@implementation TLMineVC

- (void)viewWillAppear:(BOOL)animated {


    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //账户
    TLSettingModel *accountBalanceItem = [[TLSettingModel alloc] init];
    accountBalanceItem.imgName = @"账户余额";
    accountBalanceItem.text = @"账户余额";
    accountBalanceItem.subText = @"账户余额";
    
    //系统消息
    TLSettingModel *sysMsgItem = [[TLSettingModel alloc] init];
    sysMsgItem.imgName = @"系统消息";
    sysMsgItem.text = @"系统消息";
    
    //账户设置
    TLSettingModel *accountItem = [[TLSettingModel alloc] init];
    accountItem.imgName = @"账户设置";
    accountItem.text = @"账户设置";
    
    self.models = @[accountBalanceItem,sysMsgItem,accountItem];

    
    
    [self setUpUI];
    
    [self data];
    
}

- (void)data {

    [self.userPhotoImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.nameLbl.text = @"田磊";
    self.professionalTitleLbl.text = @"特技着装顾问";

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [TLSettingCell defaultCellHeight];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.models.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TLSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[TLSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    cell.model = self.models[indexPath.row];
    return cell;
}


- (void)setUpUI {

    CGFloat userPhotoWidth = 75;
    
    self.mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.mineTableView];
    self.mineTableView.delegate = self;
    self.mineTableView.dataSource = self;
    self.mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 205)];
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.image = [UIImage imageNamed:@"我的背景"];
    
    self.mineTableView.tableHeaderView = topImageView;
    //
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectZero
                                   textAligment:NSTextAlignmentLeft
                                backgroundColor:[UIColor clearColor]
                                           font:FONT(18)
                                      textColor:[UIColor whiteColor]];
    [topImageView addSubview:titleLbl];
    titleLbl.text = @"我的";
    
    //
    self.userPhotoImageView =  [[UIImageView alloc] initWithFrame:CGRectZero];
    [topImageView addSubview:self.userPhotoImageView];
    self.userPhotoImageView.layer.cornerRadius = userPhotoWidth/2.0;
    self.userPhotoImageView.layer.masksToBounds = YES;
    self.userPhotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userPhotoImageView.layer.borderWidth = 1;
    self.userPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userPhotoImageView.image = [UIImage imageNamed:@"默认头像"];

    //
    self.nameLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(24)
                                 textColor:[UIColor whiteColor]];
    [topImageView addSubview:self.nameLbl];
    
    //
    self.levelView = [[UIView alloc] init];
    [topImageView addSubview:self.levelView];
    self.levelView.backgroundColor = [UIColor colorWithHexString:@"#dab616"];
    
    //
    self.professionalTitleLbl = [UILabel labelWithFrame:CGRectZero
                              textAligment:NSTextAlignmentLeft
                           backgroundColor:[UIColor clearColor]
                                      font:FONT(12)
                                 textColor:[UIColor colorWithHexString:@"#dab616"]];
    [topImageView addSubview:self.professionalTitleLbl];
    
    
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topImageView.mas_left).offset(37);
        make.bottom.equalTo(topImageView.mas_bottom).offset(-30);
        make.width.height.mas_equalTo(userPhotoWidth);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userPhotoImageView.mas_right).offset(30);
        make.bottom.equalTo(self.userPhotoImageView.mas_centerY).offset(5);
        
    }];
    
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_left);
        make.top.equalTo(self.nameLbl.mas_bottom).offset(7);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(30);
    }];
    
    [self.professionalTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.levelView.mas_right).offset(5);
        make.centerY.equalTo(self.levelView.mas_centerY);
    }];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_top).offset(35);
        make.centerX.equalTo(topImageView.mas_centerX);
    }];
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
