//
//  SDateView.h
//  CityPicker
//
//  Created by Superman on 2018/6/19.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDateView : UIView
@property (nonatomic,copy) NSString * btnImage;;
@property (nonatomic,copy) NSString * titleImage;
@property (nonatomic,copy) NSString * titleStr;
@property (nonatomic,copy) NSString * titlePic;
@property (nonatomic, copy) void(^ActionDistrictViewSelectBlock)(NSString *desStr,NSDictionary *selectDistrictDict);


@property (nonatomic, copy) NSString *teamStatu;

-(id)initWithFrame:(CGRect)frame Data:(NSArray *)dataArr;

-(void)showPickerView;
@end
