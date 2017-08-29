//
//  TLAccountSettingVC.m
//  CustomB
//
//  Created by  tianlei on 2017/8/25.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLAccountSettingVC.h"
//#import ""
#import "TLSettingModel.h"
#import "TLUIHeader.h"
#import "TLUser.h"
#import "TLUserSettingCell.h"
#import "NSString+Extension.h"
#import "ZHChangeNickNameVC.h"
#import "TLImagePicker.h"
#import "TLNetworking.h"
#import "QNUploadManager.h"
#import "TLProgressHUD.h"
#import "TLAlert.h"
#import "TLUploadManager.h"
#import "ZHChangeMobileVC.h"
#import "CustomChangePwdVC.h"
#import "CustomPayPwdVC.h"
#import "ZHBankCardListVC.h"


@interface TLAccountSettingVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *accountSettingTableView;
@property (nonatomic, copy) NSArray < TLSettingModel *>*models;

@property (nonatomic,strong) TLImagePicker *imagePicker;

@property (nonatomic, strong) TLSettingModel *userPhotoItem;
@property (nonatomic, strong) TLSettingModel *nicknameItem;
@property (nonatomic, strong) TLSettingModel *phoneItem;

@end

@implementation TLAccountSettingVC


- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"账户设置";
    __weak typeof(self) weakSelf = self;
    
     //账户
    TLSettingModel *userPhotoItem = [[TLSettingModel alloc] init];
    userPhotoItem.text = @"头像";
    self.userPhotoItem  = userPhotoItem;
        userPhotoItem.imgName = [[TLUser user].photo convertImageUrl];
        [userPhotoItem setAction:^{
            
            [weakSelf choosePhoto];
            
        }];
    
    //
        TLSettingModel *nicknameItem = [[TLSettingModel alloc] init];
        self.nicknameItem  = nicknameItem;
        nicknameItem.text = @"昵称";
        nicknameItem.subText = [TLUser user].nickname;
    [nicknameItem setAction:^{
        
        ZHChangeNickNameVC *vc = [[ZHChangeNickNameVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    //
        TLSettingModel *phoneItem = [[TLSettingModel alloc] init];
        phoneItem.text = @"登录手机号";
        self.phoneItem  = phoneItem;
        phoneItem.subText = [TLUser user].mobile;
    [phoneItem setAction:^{
        
        ZHChangeMobileVC *vc = [[ZHChangeMobileVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];

    
    TLSettingModel *pwdItem = [[TLSettingModel alloc] init];
    pwdItem.text = @"登录密码";
    [pwdItem setAction:^{
        
        CustomChangePwdVC *vc = [[CustomChangePwdVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    TLSettingModel *payPwdItem = [[TLSettingModel alloc] init];
    payPwdItem.text = @"支付密码";
    [payPwdItem setAction:^{
        
        CustomPayPwdVC *vc = [[CustomPayPwdVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    TLSettingModel *cardItem = [[TLSettingModel alloc] init];
    cardItem.text = @"绑定银行卡";
    [cardItem setAction:^{
        
        ZHBankCardListVC *vc = [[ ZHBankCardListVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
   self.models = @[userPhotoItem,nicknameItem,phoneItem,pwdItem,payPwdItem,cardItem];

        
   [self setUpUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
}



- (void)changeInfo {
    
    self.nicknameItem.subText = [TLUser user].nickname;
    self.userPhotoItem.imgName = [[TLUser user].photo convertImageUrl];
    [self.accountSettingTableView reloadData];
}

- (void)loginOut {

    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];

}


- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        _imagePicker.allowsEditing = YES;
        
    }
    return _imagePicker;
}

#pragma mark- 修改头像
- (void)choosePhoto {
    
    __weak typeof(self) weakSelf = self;
    if (!self.imagePicker.pickFinish) {
        
        self.imagePicker.pickFinish = ^(NSDictionary *info){
            
            TLNetworking *getUploadToken = [TLNetworking new];
            getUploadToken.showView = weakSelf.view;
            getUploadToken.code = @"805951";
            getUploadToken.parameters[@"token"] = [TLUser user].token;
            [getUploadToken postWithSuccess:^(id responseObject) {

                [TLProgressHUD showWithStatus:nil];
                QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
                NSString *token = responseObject[@"data"][@"uploadToken"];
                
                UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
                NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
                
                [uploadManager putData:imgData key:[TLUploadManager imageNameByImage:image] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    
                    [TLProgressHUD dismiss];
                    
                    //设置头像
                    
                    TLNetworking *http = [TLNetworking new];
                    http.showView = weakSelf.view;
                    http.code = @"805080";
                    http.parameters[@"userId"] = [TLUser user].userId;
                    http.parameters[@"photo"] = key;
                    http.parameters[@"token"] = [TLUser user].token;
                    [http postWithSuccess:^(id responseObject) {
                        
                        [TLAlert alertWithHUDText:@"修改头像成功"];
                        [TLUser user].photo = key;
                        weakSelf.userPhotoItem.imgName = key;
                        [weakSelf.accountSettingTableView reloadData];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
                        
                    } failure:^(NSError *error) {
                        
                        
                    }];
                    
                    
                } option:nil];
                
            } failure:^(NSError *error) {
                
            }];
            
        };
    }
    
    [self.imagePicker picker];
    
}



- (void)setUpUI {

    
    self.accountSettingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 80) style:UITableViewStylePlain];
    [self.view addSubview:self.accountSettingTableView];
    self.accountSettingTableView.delegate = self;
    self.accountSettingTableView.dataSource = self;
    self.accountSettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.accountSettingTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    //
    UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.accountSettingTableView.yy + 20, SCREEN_WIDTH - 50, 40)];
    [self.view addSubview:outBtn];
    outBtn.centerX = SCREEN_WIDTH/2.0;
    [outBtn addTarget:self
               action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    outBtn.backgroundColor = [UIColor colorWithHexString:@"#b0b0b0"];
    outBtn.titleLabel.font = FONT(14);
    [outBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    outBtn.layer.cornerRadius = 5;

}

//- (void)data {
//    
//    [self.userPhotoImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"默认头像"]];
//    self.nameLbl.text = @"田磊";
//    self.professionalTitleLbl.text = @"特技着装顾问";
//    
//    self.levelView.contentLbl.text=  @"LV10";
//    self.levelView.backgroundColor = [UIColor colorWithHexString:@"#dab616"];
//    
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.models[indexPath.row].action) {
        self.models[indexPath.row].action();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row == 62 ? : [TLUserSettingCell defaultCellHeight];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.models.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TLUserSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
    if (!cell) {
        
        cell = [[TLUserSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
        
    }
    cell.type = indexPath.row == 0 ? TLUserSettingCellTypePhoto :  TLUserSettingCellTypeDefault;
    
    cell.model = self.models[indexPath.row];
    return cell;
}

@end
