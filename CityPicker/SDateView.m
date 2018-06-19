//
//  SDateView.m
//  CityPicker
//
//  Created by Superman on 2018/6/19.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "SDateView.h"
#import "UIViewExt.h"
#import "PrefixHeader.pch"

@interface SDateView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *handerView;
@property (nonatomic, assign) CGFloat ViewWidth;
@property (nonatomic, assign) CGFloat ViewHeight;
@property (nonatomic, assign) CGFloat originHeight;
@property (nonatomic, assign) CGFloat originWidth;
@property (nonatomic, strong) NSArray * dataArr;
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) NSDictionary *districtDict;

@property (nonatomic, strong) NSString *provinceStr;
@property (nonatomic, strong) NSString *cityStr;
@property (nonatomic, strong) NSString *provinceSubCode;
@property (nonatomic, strong) NSString *provinceCode;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *districtStr;

@property (nonatomic, strong) NSArray *ProvinceArray;
@property (nonatomic, strong) NSArray *CityArray;
@property (nonatomic, strong) NSArray *districtArray;
@end

@implementation SDateView
-(id)initWithFrame:(CGRect)frame Data:(NSArray *)dataArr
{
    self = [super init];
    if (self) {
        self.ViewWidth=frame.size.width-20;
        self.ViewHeight = frame.size.height;
        self.originHeight = frame.origin.y;
        self.dataArr = dataArr;
        self.frame=CGRectMake((DeviceWidth-self.ViewWidth)*0.5, (DeviceHeight-self.ViewHeight)*0.5, self.ViewWidth, self.ViewHeight);
    }
    return self;
}
-(UIPickerView *)pickerView{
    if (_pickerView!=nil) {
        return _pickerView;
    }
    _pickerView= [[UIPickerView alloc]initWithFrame:[self getMainViewFrame]];
    _pickerView.backgroundColor=[UIColor whiteColor];
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    return _pickerView;
}
-(CGRect)getMainViewFrame
{
    CGRect rect = self.frame;
    rect.origin.x = (self.width - self.ViewWidth) / 2.0;
    rect.origin.y = TitleHeight;
    rect.size.width = self.ViewWidth;
    rect.size.height = self.ViewHeight;
    return rect;
}

-(UIView *)titleView{
    if (_titleView!=nil) {
        return _titleView;
    }
    CGRect rect;
    rect.origin.x=0;
    rect.origin.y=0;
    rect.size.width=self.ViewWidth;
    rect.size.height=TitleHeight;
    
    _titleView=[[UIView alloc]initWithFrame:rect];
    _titleView.backgroundColor=RGB(249, 249, 249);
    if (self.titlePic) {
        UIImageView *titlePic=[[UIImageView alloc]initWithFrame:rect];
        titlePic.image=[UIImage imageNamed:self.titlePic];
        [_titleView addSubview:titlePic];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:self.btnImage] forState:UIControlStateNormal];
        btn.frame=CGRectMake(self.ViewWidth-40, 9, 24, 24);
        [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:btn];
    }else{
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(5, 9, 55, 24);
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:ALLGRAYCOLOR forState:UIControlStateNormal];
        cancelBtn.backgroundColor = [UIColor clearColor];
        cancelBtn.layer.cornerRadius = 5;
        [cancelBtn addTarget:self action:@selector(btnDownCancel) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:cancelBtn];
        [_titleView bringSubviewToFront:cancelBtn];
        
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(self.ViewWidth-60, 9, 55, 24);
        sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:ALLOrangeCOLOR forState:UIControlStateNormal];
        sureBtn.backgroundColor = [UIColor clearColor];
        sureBtn.layer.cornerRadius = 5;
        [sureBtn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:sureBtn];
        [_titleView bringSubviewToFront:sureBtn];
    }
    return _titleView;
}
-(void)show{
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=9;

    self.handerView=[UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _handerView.backgroundColor=[UIColor blackColor];
    _handerView.alpha=0.3;
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:_handerView];
    [window addSubview:self];
    self.alpha=0.f;
    self.transform=CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform=CGAffineTransformIdentity;
        self.alpha=1;
    }];
}
-(void)showPickerView{
    self.districtDict=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"districtMGE" ofType:@"plist"] ];
    self.ProvinceArray=self.districtDict[Key_Division];
    [self addSubview:self.titleView];
    [self addSubview:self.pickerView];
    [self show];
}
-(void)btnDown
{
    [self dismiss];
}

-(void)btnDownCancel
{
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
-(void)dismiss
{
    [self dismiss:YES];
}
-(void)dismiss:(BOOL)animate
{
    if (_pickerView) {
        NSString *provinceCode=[self.ProvinceArray[[_pickerView selectedRowInComponent:0] ] objectForKey:Key_DivisionCode];
        NSString *cityCode=[self.CityArray[[_pickerView selectedRowInComponent:1]] objectForKey:Key_DivisionCode];
        
        NSString *citySubCode=[self.districtArray[[_pickerView selectedRowInComponent:2]] objectForKey:Key_DivisionCode];
        
        NSString *provinceName=[self.ProvinceArray[[_pickerView selectedRowInComponent:0]] objectForKey:Key_DivisionName] ;
        NSString *cityName=[self.CityArray[[_pickerView selectedRowInComponent:1]] objectForKey:Key_DivisionName];
        NSString *citySubName=[self.districtArray[[_pickerView selectedRowInComponent:2]] objectForKey:Key_DivisionName];
        NSString *areaTitle=[NSString stringWithFormat:@"%@%@",provinceName,citySubName];
        if (self.ActionDistrictViewSelectBlock) {
            self.ActionDistrictViewSelectBlock(areaTitle, @{Key_DistrictSelectProvince:provinceName,Key_DistrictSelectProvinceCode:provinceCode, Key_DistrictSelectCity:cityName,
               Key_DistrictSelectCityCode:cityCode,Key_DistrictSelectProvinceSub:citySubName,
               Key_DistrictSelectProvinceSubCode:citySubCode});
        }
    }
    if (!animate) {
        [_handerView removeFromSuperview];
        [self removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.transform=CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha=0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
#pragma mark Picker Data Source Methods
- (void)getSelectDistrictName
{
    NSDictionary *provinceDict=self.ProvinceArray[[_pickerView selectedRowInComponent:0]];
    self.provinceStr=[provinceDict objectForKey:Key_DivisionName];
    
    NSArray *array=[provinceDict objectForKey:Key_DivisionSub];
    if ([_pickerView selectedRowInComponent:1] > array.count-1) {
        return;
    }
    NSDictionary *cityDict=[[provinceDict objectForKey:Key_DivisionSub] objectAtIndex:[_pickerView selectedRowInComponent:1]];
    self.cityStr =[cityDict objectForKey:Key_DivisionName];
    self.districtStr=[self.districtArray[[_pickerView selectedRowInComponent:2]]objectForKey:Key_DivisionName];
    _titleLabel.text=[NSString stringWithFormat:@"%@%@%@",self.provinceStr,self.cityStr,self.districtStr];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return self.ProvinceArray.count;
    }else if (component==1){
        if ([pickerView selectedRowInComponent:0]==-1) {
            return 0;
        }else{
            NSDictionary *provinceDict =self.ProvinceArray[[pickerView selectedRowInComponent:0]];
            self.CityArray=[provinceDict objectForKey:Key_DivisionSub];
            return self.CityArray.count;
        }
    }else{
        if ([pickerView selectedRowInComponent:1]==-1) {
            return 0;
        }else{
            NSDictionary *cityDict=self.CityArray[[pickerView selectedRowInComponent:1]];
            self.districtArray=[cityDict objectForKey:Key_DivisionSub];
            return self.districtArray.count;
        }
    }
}
#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title=nil;
    if (component==0) {
        NSDictionary *provinceDict=self.ProvinceArray[row];
        title=[provinceDict objectForKey:Key_DivisionName];
    }else if (component==1){
        NSDictionary *cityDict=self.CityArray[row];
        title=[cityDict objectForKey:Key_DivisionName];
    }else{
        NSDictionary  *districtDict=self.districtArray[row];
        title=[districtDict objectForKey:Key_DivisionName];
    }
    return title ? title :@"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [self getSelectDistrictName];
    }else if(component==1){
        [pickerView reloadComponent:2];
        [self getSelectDistrictName];
    }else{
        [self getSelectDistrictName];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 70.0;
}

















/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
