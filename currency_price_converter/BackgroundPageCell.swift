import UIKit
import Anchorage

final class BackgroundPageCell: UICollectionViewCell, ViewRendering {
    
    typealias Properties = BackgroundCollectionView.Properties.Page
    let backgroundImage = UIImageView()
    
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
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

