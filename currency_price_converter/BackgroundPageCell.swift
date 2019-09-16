import UIKit
import Anchorage

final class BackgroundPageCell: UICollectionViewCell, ViewRendering {
    
    typealias Properties = BackgroundCollectionView.Properties.Page
    let backgroundImage = UIImageView()
    var duration = 0.3
    var animator: UIViewPropertyAnimator?
    
    func render(_ properties: BackgroundCollectionView.Properties.Page) {
        backgroundImage.image = properties.image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundImage)
        backgroundImage.tintColor = .white
        backgroundImage.layer.opacity = 0.1
        
        backgroundImage.heightAnchor == contentView.heightAnchor * 0.8
        backgroundImage.widthAnchor == contentView.heightAnchor * 0.8
        backgroundImage.centerAnchors == contentView.centerAnchors
//        backgroundImage.centerYAnchor == bottomAnchor
        clipsToBounds = true
        
        let originalTransform = backgroundImage.transform
        let scaledTransform = originalTransform.scaledBy(x: 1.8, y: 1.8)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.0, y: -250.0)
        
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: {
//            self.backgroundImage.transform = scaledAndTranslatedTransform
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

