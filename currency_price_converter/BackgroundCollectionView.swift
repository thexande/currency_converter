import UIKit

final class BackgroundCollectionView: UICollectionView, ViewRendering, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    struct Properties {
        struct Page {
            let image: UIImage?
        }
        
        let pages: [Page]
        
        static let `default`: Properties = .init(pages: [])
    }
    
    var properties: Properties = .default
    var onScrollRatioCompleteDidChange: ((CGFloat) -> Void)?
    
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
        let percentage = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.width) / scrollView.frame.width
        print(percentage)
        if percentage > 0 {
            onScrollRatioCompleteDidChange?(percentage)
        }
    }
}
