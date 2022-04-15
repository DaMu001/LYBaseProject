//
//  LYBaseCollectionViewCell.h
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (LYIdentifier)

/// 可重用标识符
+ (NSString *)ly_identifier;

@end

@interface LYBaseCollectionViewCell : UICollectionViewCell

/**
 记录当前cell的下标
 */
@property (nonatomic,strong,nonnull) NSIndexPath *ly_indexPath;

/// 初始化方式
/// @param collectionView 当前view
/// @param indexPath 当前位置
+ (instancetype _Nullable)ly_collectionCellWith:(UICollectionView *_Nullable)collectionView forIndexPath:(NSIndexPath *_Nonnull)indexPath;

/**
 设置cell 样式 背景色一类的处理
 */
- (void)setupCell;

/**
 设置cell 内容
 */
- (void)buildSubview;

@end

NS_ASSUME_NONNULL_END
