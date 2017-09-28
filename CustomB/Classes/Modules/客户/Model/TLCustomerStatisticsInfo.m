//
//  TLCustomerStatisticsInfo.m
//  CustomB
//
//  Created by  tianlei on 2017/8/29.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLCustomerStatisticsInfo.h"
#import "NSString+Extension.h"

@implementation TLCustomerStatisticsInfo

+ (NSDictionary *)mj_objectClassInArray {

    return @{@"sizeDataList" : [TLMeasureModel class]};

}

- (NSArray<NSDictionary *> *)figure {
    
    return self.sysDictMap[@"figure"];
    
}

-(NSArray<NSDictionary *> *)measure {
    
    return self.sysDictMap[@"measure"];

}

-(NSArray<NSDictionary *> *)other {
    
    return self.sysDictMap[@"other"];
    
}

- (NSString *)getBirthdayStr {
    
    if (!self.birthday) {
        return @"";
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    //
    NSDate *date01 = [formatter dateFromString:self.birthday];
    formatter.dateFormat = @"MM月dd日";
    formatter.locale = [NSLocale currentLocale];
    
    //
    return [formatter stringFromDate:date01];

}

@end
