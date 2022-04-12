//
//  LYBaseTableViewCell.h
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (LYIdentifier)

/// 可重用标识符
+ (NSString *)ly_identifier;

@end

@interface LYBaseTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath * ly_indexPath;

/// 快速创建 可重用的cell
/// @param tableView 父视图
/// @param indexPath 位置
+ (instancetype _Nullable)ly_cellWith:(UITableView *_Nullable)tableView forIndexPath:(NSIndexPath *_Nonnull)indexPath;

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
