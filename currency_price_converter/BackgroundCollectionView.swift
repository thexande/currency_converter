import UIKit
import Anchorage

final class BackgroundCollectionView: UICollectionView, ViewRendering, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var properties: Properties = .default
    var onScrollRatioCompleteDidChange: ((CGFloat) -> Void)?
    private let circleWipe = CircleWipeView()
    
    struct Properties {
        struct Page {
            let image: UIImage?
            let backgroundColor: UIColor
        }
        
        let pages: [Page]
        
        static let `default`: Properties = .init(pages: [])
    }
    
    func render(_ properties: BackgroundCollectionView.Properties) {
        self.properties = properties
        reloadData()
    }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        isPagingEnabled = true
        delegate = self
        dataSource = self
        register(BackgroundPageCell.self, forCellWithReuseIdentifier: .init(describing: BackgroundPageCell.self))
        backgroundColor = .clear
        
        backgroundView = circleWipe
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: BackgroundPageCell.self),
                                                            for: indexPath) as? BackgroundPageCell else {
                                                                return UICollectionViewCell()
        }
        
        cell.render(properties.pages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let backgroundColor: UIColor
        let circleWipeColor: UIColor
        let direction: CircleWipeView.Properties.Direction
        
        let percentage = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.width) / scrollView.frame.width
        print(percentage)
        
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
            
            
            let indexes = Array(indexPathsForVisibleItems.sorted().reversed())
            
            guard
                let from = indexes.first?.item,
                let to = indexes[safe: 1]?.item,
                let toColor = properties.pages[safe: to]?.backgroundColor,
                let fromColor = properties.pages[safe: from]?.backgroundColor else { return }
            
            backgroundColor = fromColor
            circleWipeColor = toColor
            direction = .left
            
//            if percentage > 0 {
//                (cellForItem(at: .init(row: to, section: 0)) as? BackgroundPageCell)?.animator?.fractionComplete = abs(1 - percentage)
//                (cellForItem(at: .init(row: from, section: 0)) as? BackgroundPageCell)?.animator?.fractionComplete = percentage
//            }
            
            print("left from: \(from), to: \(to)")

            
        } else {
            
            let indexes = Array(indexPathsForVisibleItems.sorted())

            guard
                let from = indexes.first?.item,
                let to = indexes[safe: 1]?.item,
                let toColor = properties.pages[safe: to]?.backgroundColor,
                let fromColor = properties.pages[safe: from]?.backgroundColor else { return }
            
            print("right from: \(from), to: \(to)")
            
            
//            if percentage > 0 {
//                (cellForItem(at: .init(row: to, section: 0)) as? BackgroundPageCell)?.animator?.fractionComplete = percentage
//                (cellForItem(at: .init(row: from, section: 0)) as? BackgroundPageCell)?.animator?.fractionComplete = abs(1 - percentage)
//            }
            
            backgroundColor = fromColor
            circleWipeColor = toColor
            direction = .right
            
        }
        
    
        circleWipe.render(.init(direction: direction,
                                complete: abs(percentage),
                                backgroundColor: backgroundColor,
                                circleWipeColor: circleWipeColor))
    }
}


extension Collection {
    
    /**
     Convenience Subscript implementation used to make safe access into an array easier.
     */
    subscript (safe index: Index) -> Iterator.Element? {
        guard (index >= startIndex) && (index < endIndex) else { return nil }
        
        return self[index]
    }
}
