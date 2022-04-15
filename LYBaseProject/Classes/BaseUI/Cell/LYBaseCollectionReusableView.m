//
//  LYBaseCollectionReusableView.m
//  Example
//
//  Created by muios on 2022/4/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYBaseCollectionReusableView.h"

@implementation LYBaseCollectionReusableView

+ (instancetype _Nullable)ly_collectionHeaderWith:(UICollectionView *_Nullable)collectionView forIndexPath:(NSIndexPath *_Nonnull)indexPath
{
    NSString *tmpReuseIdentifier = NSStringFromClass([self class]);
    LYBaseCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:tmpReuseIdentifier forIndexPath:indexPath];
    
    return headerView;
}

+ (instancetype _Nullable)ly_collectionFooterWith:(UICollectionView *_Nullable)collectionView forIndexPath:(NSIndexPath *_Nonnull)indexPath
{
    NSString *tmpReuseIdentifier = NSStringFromClass([self class]);
    LYBaseCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:tmpReuseIdentifier forIndexPath:indexPath];
    
    return footerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildSubview];
    }
    return self;
}


- (void)buildSubview
{
    
}
@end
