//
//  TLHuoGeVC.m
//  CustomB
//
//  Created by  tianlei on 2017/9/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLHuoGeVC.h"
#import "TLUser.h"
#import "SGQRCodeTool.h"
#import <Masonry/Masonry.h>


@interface TLHuoGeVC ()

@property (nonatomic, strong) UIImageView *qrImageView;

@end


@implementation TLHuoGeVC

- (UIImageView *)qrImageView {
    
    if (!_qrImageView) {
        
        //添加二维码
        UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, 200, 200)];
        _qrImageView = qrImageView;
        qrImageView.layer.cornerRadius = 5;
        qrImageView.clipsToBounds = YES;
        //        [maskCtrl addSubview:qrImageView];
        
        
    }
    return _qrImageView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    http://cm.tour.hichengdai.com/?#/home?userReferee=U201709291005241229086
    self.title = @"扫码即可注册";
    
    //
    [self.view addSubview: self.qrImageView];
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_centerY).offset(-30);
        make.height.width.mas_equalTo(260);
        
    }];
    
    //m.he-shirts.com
    NSString *userStr = [NSString stringWithFormat:@"http://m.he-shirts.com/?#/home?userReferee=%@",[TLUser user].userId];
    
    self.qrImageView.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:userStr imageViewWidth:300];
    //
    
}



@end
