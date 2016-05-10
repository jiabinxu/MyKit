//
//  UICollectionView+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public extension UICollectionView {

    // MARK: Miscellaneous

    final func isSectionValid(section: Int) -> Bool {
        return NSLocationInRange(section, NSMakeRange(0, self.numberOfSections()))
    }

    // MARK: Transform IndexPath

    final func successorOf(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.item < self.numberOfItemsInSection(indexPath.section) - 1 {
            return NSIndexPath(forItem: indexPath.item + 1, inSection: indexPath.section)
        } else if indexPath.section < self.numberOfSections() - 1 {
            return NSIndexPath(forItem: 0, inSection: indexPath.section + 1)
        } else { return nil }
    }

    final func predecessorOf(indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.item > 0 {
            return NSIndexPath(forItem: indexPath.item - 1, inSection: indexPath.section)
        } else if indexPath.section > 0 {
            let section = indexPath.section - 1
            let item = self.numberOfItemsInSection(section) - 1

            return NSIndexPath(forItem: item, inSection: section)
        } else { return nil }
    }

    // MARK: Register Views

    public func register<T: UICollectionViewCell>(type: T.Type, forReuseIdentifier identifier: String) {
        self.registerClass(T.self, forCellWithReuseIdentifier: identifier)
    }

    public func register<T: UICollectionReusableView>(type: T.Type, forKind kind: String, withReuseIdentifier identifier: String) {
        self.registerClass(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
}

public extension UICollectionView {

    private class Dragger: NSObject {

        static var Key = String(self.dynamicType)

        let gesture = UILongPressGestureRecognizer()

        var anchorIndexPath: NSIndexPath?
        var trackedIndexPath: NSIndexPath?

        override func copy() -> AnyObject {
            return self
        }
    }

    private var dragger: Dragger? {
        get { return objc_getAssociatedObject(self, &Dragger.Key) as? Dragger }
        set {
            dragger?.gesture.then(self.removeGestureRecognizer)

            newValue?.gesture.then {
                $0.addTarget(self, action: #selector(handleMultipleSelectionByDragging(_:)))
                self.addGestureRecognizer($0)
            }

            objc_setAssociatedObject(self, &Dragger.Key, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    public var allowsMultipleSelectionWithDragging: Bool {
        get { return dragger != nil }
        set { dragger = newValue ? Dragger() : nil }
    }

    internal final func handleMultipleSelectionByDragging(sender: UILongPressGestureRecognizer) {
        guard case let location = sender.locationInView(self),
            let indexPath = self.indexPathForItemAtPoint(location),
            dragger = self.dragger else { return }

        switch sender.state {

        case .Began:
            self.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            dragger.anchorIndexPath = indexPath
            dragger.trackedIndexPath = indexPath

        case .Changed:
            guard indexPath != dragger.trackedIndexPath else { return }
            selectItemsRecursivelyTo(indexPath)

        default:
            dragger.anchorIndexPath = nil
            dragger.trackedIndexPath = nil
        }
    }

    private final func selectItemsRecursivelyTo(destination: NSIndexPath) {
        guard let dragger = self.dragger,
            anchorIndexPath = dragger.anchorIndexPath,
            trackedIndexPath = dragger.trackedIndexPath
            else { return }

        guard let frontIndexPath = successorOf(trackedIndexPath),
            backIndexPath = predecessorOf(trackedIndexPath)
            else { return }

        switch trackedIndexPath.compare(destination) {

        case .OrderedAscending:
            guard let cell = self.cellForItemAtIndexPath(backIndexPath) else { return }

            if trackedIndexPath != anchorIndexPath {
                cell.selected ? self.selectItemAtIndexPath(trackedIndexPath, animated: false, scrollPosition: .None) : self.deselectItemAtIndexPath(trackedIndexPath, animated: false)
            }

            dragger.trackedIndexPath = frontIndexPath
            selectItemsRecursivelyTo(destination)

        case .OrderedDescending:
            guard let cell = self.cellForItemAtIndexPath(frontIndexPath) else { return }

            if trackedIndexPath != anchorIndexPath {
                cell.selected ? self.selectItemAtIndexPath(trackedIndexPath, animated: false, scrollPosition: .None) : self.deselectItemAtIndexPath(trackedIndexPath, animated: false)
            }

            dragger.trackedIndexPath = backIndexPath
            selectItemsRecursivelyTo(destination)

        case .OrderedSame:
            self.selectItemAtIndexPath(trackedIndexPath, animated: true, scrollPosition: .None)
        }
    }
}