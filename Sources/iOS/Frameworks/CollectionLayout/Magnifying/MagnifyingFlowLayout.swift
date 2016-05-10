//
//  MagnifyingFlowLayout.swift
//  MyKit
//
//  Created by Hai Nguyen on 7/3/15.
//  
//

public class MagnifyingFlowLayout: SnappingFlowLayout {

    // MARK: Property

    public var magnifyingConfig = MagnifyingLayoutConfig()

    internal private(set) var visibleIndexPaths: [NSIndexPath] = []

    // MARK: System Methods

    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        visibleIndexPaths.removeAll(keepCapacity: true)

        return super.layoutAttributesForElementsInRect(rect)?.map {
            switch $0.representedElementCategory {
            case .Cell:
                visibleIndexPaths += [$0.indexPath]
                return self.layoutAttributesForItemAtIndexPath($0.indexPath) ?? $0
            default:
                return $0
            }
        }
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    public override func invalidationContextForBoundsChange(newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        return super.invalidationContextForBoundsChange(newBounds)
            .then { $0.invalidateItemsAtIndexPaths(visibleIndexPaths) }
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItemAtIndexPath(indexPath)?.then {
            guard let contentOffset = self.collectionView?.contentOffset else { return }

            let center = $0.center.shiftToCoordinate(contentOffset)
            let scale = magnifyingConfig.scaleAttributesAt(center)

            $0.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
}