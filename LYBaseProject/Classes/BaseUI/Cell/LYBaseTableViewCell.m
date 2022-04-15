//
//  LYBaseTableViewCell.m
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYBaseTableViewCell.h"

@implementation UITableViewCell (LYIdentifier)

/// 可重用标识符
+ (NSString *)ly_identifier
{
    return NSStringFromClass([self class]);
}

@end

@implementation LYBaseTableViewCell

+ (instancetype _Nullable)ly_tableviewCellWith:(UITableView *_Nullable)tableView forIndexPath:(NSIndexPath *_Nonnull)indexPath
{
    NSString *tmpReuseIdentifier = [self ly_identifier];
    LYBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tmpReuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LYBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tmpReuseIdentifier];
    }
    
    cell.ly_indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        [self setupCell];
        
        [self buildSubview];
    }
    
    return self;
}

- (void)setupCell
{

}

- (void)buildSubview
{

}

@end
