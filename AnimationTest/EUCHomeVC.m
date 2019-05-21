//
//  EUCHomeVC.m
//  Ielpm_Wallet
//
//  Created by fans on 2017/6/13.
//  Copyright © 2017年 com.yishicompany.www. All rights reserved.
//  

#import "EUCHomeVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "EUCHomeHeader.h"
#import "MsgCenterTipView.h"
#import "AppInViewController.h"
#import "MainViewController.h"
//#import "EUCHomeListM.h"

#import "EUCHomeCell.h"
@interface EUCHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *layout;
@property (nonatomic, strong)EUCHomeHeader *headerView;
@property (nonatomic, strong)UIView *navigationView;
@property (nonatomic, strong)MsgCenterTipView *msgCenterView;

@end

NSString *kCellID = @"EUCHomeCellID";
NSString *kHeaderViewID = @"MineHomeHeaderViewID";
@implementation EUCHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self initData];
    [self addNotification];
    [self setupViews];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    BOOL loginStatus = [UserInfo getLoginStatus];
    self.msgCenterView.hidden = !loginStatus;
    self.headerView.vipV.hidden = !loginStatus;
    [self fetchInfo];
}
- (void)initData{
    self.width = SCREENT_WIDTH;
}
- (void)setupViews{
    if (IPHONE6__) {
        _width += 1;
    }else{
        _width += 2;
    }
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.navigationView];


    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(self.view);
        make.width.equalTo(_width);
    }];

    __ws;
    [self.navigationView makeConstraints:^(MASConstraintMaker *make) {
        if(IOS11_OR_LATER){
            make.top.equalTo(ws.collectionView).offset(20);
        }else{
            make.top.equalTo(ws.collectionView);
        }
        make.left.width.equalTo(ws.collectionView);
        make.height.equalTo(64);
    }];
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchInfo) name:NOTICE_REFRESH_USERINFO object:nil];
}
- (void)fetchInfo{
    __ws;
    [self.viewModel fetchInfo:^(NSDictionary<NSString *,NSString *> *result) {
        [ws updateState:result];
    }];
    
    [self.viewModel fetchList:^(NSDictionary<NSString *,NSString *> *result) {
        [ws.collectionView reloadData];
    }];
}
-(void)updateState:(NSDictionary*)result {
    [self.headerView updateState:result];

    NSString* localMsgId = [UserInfo getMsgMaxGotId];
    NSString* lastMsgId = result[@"lastMsgId"];

    BOOL showRedPoint = lastMsgId.intValue > localMsgId.intValue;
    [self.msgCenterView msgTipShow:showRedPoint];

    MainViewController* vc = [AppInViewController shareInstance].mainVC;
    if (showRedPoint) {
        [vc showTabBarItemBadgeWithIndex:vc.viewControllers.count-1];
    }else{
        [vc hideTabBarItemBadgeWithIndex:vc.viewControllers.count-1];
    }
}
// MARK: - event response
-(void)btnMsgCenterClick
{
    [self.viewModel gotoMessageCenter];
}

-(void) btnProfileClick
{
    [self.viewModel gotoProfile];
}

#pragma mark -  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.viewModel.itemArray.count;
    if (count%2 == 1) {
        return count +1;
    }
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EUCHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if (indexPath.item + 1 > self.viewModel.itemArray.count) {
        cell.isHiddenContent = true;
        return cell;
    }
    EUCHomeCellM *cellModel = self.viewModel.itemArray[indexPath.item];
    cell.cellModel = cellModel;
    cell.isHiddenContent = false;
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewID forIndexPath:indexPath];
        [reusableView addSubview:self.headerView];
        __ws;
        [self.headerView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(reusableView).offset(-20);
            make.left.width.equalTo(reusableView);
            make.height.equalTo(ws.headerView.headerHeight);
        }];
        return  reusableView;
    }
    return [UICollectionReusableView new];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item > self.viewModel.itemArray.count - 1) {
        return;
    }
    [self.viewModel cellSelected:indexPath];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = _collectionView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    _collectionView.contentOffset = offset;
}

#pragma mark - lazy
- (EUCHomeVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[EUCHomeVM alloc] initWithController:self];
    }
    return _viewModel;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor viewBackgroundColor];
        _collectionView.showsVerticalScrollIndicator = false;
        if (@available(iOS 11.0, *)){
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[EUCHomeCell class] forCellWithReuseIdentifier:kCellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout*)layout
{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.itemSize = CGSizeMake(self.width * 0.5, 65.5);
        _layout.headerReferenceSize = CGSizeMake(self.width, self.headerView.headerHeight - 10);
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat layout_miniLine = 0;
        if (IPHONE6__PLUS) {
            layout_miniLine = @(1.0).screenScale;
        }else if(IPHONEX){
            layout_miniLine = @(1.0).screenScale;
        }else{
            layout_miniLine = @(0.1).screenScale;
        }
        _layout.minimumLineSpacing = layout_miniLine;
        _layout.minimumInteritemSpacing = 0;
    }

    return _layout;
}

-(EUCHomeHeader *)headerView
{
    if (!_headerView) {
        _headerView = [[EUCHomeHeader alloc]initWithFrame:CGRectZero controller:self];
    }
    return _headerView;
}

- (UIView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] init];
        
        UIButton *btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnProfile addTarget:self action:@selector(btnProfileClick) forControlEvents:UIControlEventTouchUpInside];
        btnProfile.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnProfile setImage:[UIImage imageNamed:@"userCenter"] forState:UIControlStateNormal];
        btnProfile.imageEdgeInsets = UIEdgeInsetsMake(0, 15,  0,  0);

        [_navigationView addSubview:btnProfile];
        [_navigationView addSubview:self.msgCenterView];

        [btnProfile makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_navigationView);
            make.centerY.equalTo(_navigationView.bottom).offset(-22);
            make.width.height.equalTo(_navigationView.height);
        }];
        [self.msgCenterView  makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_navigationView);
            make.centerY.equalTo(_navigationView.bottom).offset(-22);
            make.width.height.equalTo(_navigationView.height);
        }];
    }
    return _navigationView;
}

//
- (MsgCenterTipView *)msgCenterView
{
    if (!_msgCenterView) {
        _msgCenterView = [[MsgCenterTipView alloc] initWithFrame:CGRectZero];
        _msgCenterView.backgroundColor = [UIColor clearColor];
        _msgCenterView.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0,  15);
        _msgCenterView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_msgCenterView setImage:[UIImage imageNamed:@"msgCenter"] forState:UIControlStateNormal];
        [_msgCenterView addTarget:self action:@selector(btnMsgCenterClick) forControlEvents:UIControlEventTouchUpInside];
        _msgCenterView.hidden = true;
        [_msgCenterView msgTipShow:false];
    }
    return _msgCenterView;
}
@end
