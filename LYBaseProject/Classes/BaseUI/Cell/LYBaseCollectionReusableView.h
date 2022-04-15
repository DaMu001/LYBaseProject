//
//  LYBaseCollectionReusableView.h
//  Example
//
//  Created by muios on 2022/4/14.
//  Copyright © 2022 babo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYBaseCollectionReusableView : UICollectionReusableView
/// 快速创建头部
+ (instancetype _Nullable)ly_collectionHeaderWith:(UICollectionView *_Nullable)collectionView forIndexPath:(NSIndexPath *_Nonnull)indexPath;

/// 快速创建尾部
+ (instancetype _Nullable)ly_collectionFooterWith:(UICollectionView *_Nullable)collectionView forIndexPath:(NSIndexPath *_Nonnull)indexPath;

/**
 设置headerView 内容
 */
- (void)buildSubview;

@end

NS_ASSUME_NONNULL_END
