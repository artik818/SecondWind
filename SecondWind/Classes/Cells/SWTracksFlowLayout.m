//
//  SWTracksFlowLayout.m
//  SecondWind
//
//  Created by Momotov Vladimir on 15.05.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import "SWTracksFlowLayout.h"

@implementation SWTracksFlowLayout

- (void)prepareLayout {
    CGSize headerSize = [self headerReferenceSize];
    [self.collectionView setContentOffset:CGPointMake(0.0f, headerSize.height) animated:NO];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // This will schedule calls to layoutAttributesForElementsInRect: as the
    // collectionView is scrolling.
    return NO;
}

- (UICollectionViewScrollDirection)scrollDirection {
    // This subclass only supports vertical scrolling.
    return UICollectionViewScrollDirectionVertical;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    UICollectionView *collectionView = [self collectionView];
    UIEdgeInsets insets = [collectionView contentInset];
    CGPoint offset = [collectionView contentOffset];
    CGFloat minY = insets.top;
    NSLog(@"offcet - y - %f", offset.y);
    // First get the superclass attributes.
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    // Check if we've pulled below past the upper position
    if (offset.y < minY) {
        
        // Figure out how much we've pulled down
        CGFloat deltaY = fabsf(offset.y - minY);
        
        for (UICollectionViewLayoutAttributes *attrs in attributes) {
            
            // Locate the header attributes
            NSString *kind = [attrs representedElementKind];
            if (kind == UICollectionElementKindSectionHeader) {
                
                // Adjust the header's height and y based on how much the user
                // has pulled down.
                CGSize headerSize = [self headerReferenceSize];
                CGRect headerRect = [attrs frame];
                headerRect.size.height = MAX(minY, headerSize.height + deltaY);
                headerRect.origin.y = headerRect.origin.y - deltaY;
                [attrs setFrame:headerRect];
                break;
            }
        }
    }
    return attributes;
}

@end
