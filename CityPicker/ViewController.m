//
//  ViewController.m
//  CityPicker
//
//  Created by Superman on 2018/6/19.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "ViewController.h"
#import "SDateView.h"
#import "UIViewExt.h"

@interface ViewController ()
@property (nonatomic,strong) UILabel * provinceLabel;
@property (nonatomic,strong) UILabel * cityLabel;
@property (nonatomic,strong) UILabel * areaLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn=[[UIButton alloc]init];
    btn.frame=CGRectMake((DeviceWidth-130)*0.5,100 , 130,50 );
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor yellowColor]];
    [btn addTarget:self action:@selector(chooseAc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.view.backgroundColor=[UIColor whiteColor];
    

    UILabel *provinceLabel=[[UILabel alloc]init];
    provinceLabel.frame=CGRectMake((DeviceWidth-220)*0.5, btn.bottom+100, 220, 37);
    provinceLabel.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:provinceLabel];
    _provinceLabel=provinceLabel;
    
    UILabel *cityLabel=[[UILabel alloc]init];
    cityLabel.frame=CGRectMake(provinceLabel.left, provinceLabel.bottom+30, 220, 37);
    cityLabel.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:cityLabel];
    _cityLabel=cityLabel;
    
    UILabel *areaLabel=[[UILabel alloc]init];
    areaLabel.frame=CGRectMake(cityLabel.left, cityLabel.bottom+30, 220, 37);
    areaLabel.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:areaLabel];
    _areaLabel=areaLabel;
    
    
}
-(void)chooseAc{
    SDateView *dateView=[[SDateView alloc]initWithFrame:CGRectMake(0, DeviceHeight-250, DeviceWidth, 250) Data:nil];
    [dateView showPickerView];
    
    dateView.ActionDistrictViewSelectBlock=^(NSString *desStr, NSDictionary *selectDistrictDict){
        self.provinceLabel.text=[selectDistrictDict objectForKey:Key_DistrictSelectProvince];
        self.cityLabel.text=[selectDistrictDict objectForKey:Key_DistrictSelectCity];
        self.areaLabel.text=[selectDistrictDict objectForKey:Key_DistrictSelectProvinceSub];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



























@end
