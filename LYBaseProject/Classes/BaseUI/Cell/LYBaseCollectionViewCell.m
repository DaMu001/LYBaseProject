//
//  LYBaseCollectionViewCell.m
//  Example
//
//  Created by muios on 2022/4/12.
//  Copyright © 2022 babo. All rights reserved.
//

#import "LYBaseCollectionViewCell.h"

@implementation UICollectionViewCell (LYIdentifier)

/// 可重用标识符
+ (NSString *)ly_identifier
{
    return NSStringFromClass([self class]);
}

@end

@implementation LYBaseCollectionViewCell

+ (instancetype _Nullable)ly_cellWith:(UICollectionView *_Nullable)collectionView forIndexPath:(NSIndexPath *_Nonnull)indexPath
{
    NSString *tmpReuseIdentifier = [self ly_identifier];
    LYBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tmpReuseIdentifier forIndexPath:indexPath];
    
    cell.ly_indexPath = indexPath;
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = [UIColor clearColor];
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
