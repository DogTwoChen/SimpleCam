//
//  SCFilterMaterialView.m
//  SimpleCam
//
//  Created by Lyman Li on 2019/4/13.
//  Copyright © 2019年 Lyman Li. All rights reserved.
//

#import "SCFilterMaterialViewCell.h"

#import "SCFilterMaterialView.h"

static NSString * const kSCFilterMaterialViewReuseIdentifier = @"SCFilterMaterialViewReuseIdentifier";

@interface SCFilterMaterialView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SCFilterMaterialView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

- (void)scrollToIndex:(NSUInteger)index {
    if (_currentIndex == index) {
        return;
    }
    if (index >= _itemList.count) {
        return;
    }
    
    [self selectIndex:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - Private

- (void)commonInit {
    [self createCollectionViewLayout];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:[self bounds] collectionViewLayout:_collectionViewLayout];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[SCFilterMaterialViewCell class] forCellWithReuseIdentifier:kSCFilterMaterialViewReuseIdentifier];
}

- (void)createCollectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置间距
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 0;
    
    //设置item尺寸
    CGFloat itemW = 60;
    CGFloat itemH = 100;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    // 设置水平滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionViewLayout = flowLayout;
}

- (void)selectIndex:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.row;
    
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(filterMaterialView:didScrollToIndex:)]) {
        [self.delegate filterMaterialView:self didScrollToIndex:indexPath.row];
    }
}

#pragma mark - Custom Accessor

- (void)setItemList:(NSArray<SCFilterMaterialModel *> *)itemList {
    _itemList = [itemList copy];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCFilterMaterialViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSCFilterMaterialViewReuseIdentifier forIndexPath:indexPath];
    cell.filterMaterialModel = self.itemList[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectIndex:indexPath];
}

@end
