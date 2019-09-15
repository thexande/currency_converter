import UIKit
import Anchorage

final class CircleWipeView: UIView, ViewRendering {
    
    struct Properties {
        let complete: CGFloat
        let backgroundColor: UIColor
        let circleWipeColor: UIColor
        static let `default` = Properties(complete: 0, backgroundColor: .black, circleWipeColor: .black)
    }
    
    var cachedCircle: UIView?
    var duration = 0.3
    var animator: UIViewPropertyAnimator?
    var hasConfiguredCircle = false
    let circle = UIView()
    
    
    func render(_ properties: Properties) {
        
        if properties.backgroundColor != backgroundColor {
            self.backgroundColor = properties.backgroundColor
        }
        
        if properties.circleWipeColor != circle.backgroundColor {
            circle.backgroundColor = properties.circleWipeColor
        }
        
        animator?.fractionComplete = properties.complete
    }
    
    func frameForCircle (withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard frame.size.width > 0, frame.size.height > 0 else { return }
        
        if hasConfiguredCircle == false {
            configureCircle()
            hasConfiguredCircle = true
        }
    }
    
    private func configureCircle() {
        let viewCenter = center
        let viewSize = frame.size
        
        
        circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: .init(x: frame.width / 2, y: frame.height / 2))
        
        circle.layer.cornerRadius = circle.frame.size.height / 2
        circle.center = .init(x: frame.width / 2, y: frame.height / 2)
        circle.transform = CGAffineTransform(scaleX: .leastNonzeroMagnitude, y: .leastNonzeroMagnitude)
        addSubview(circle)
        
        
        animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: {
            self.circle.transform = CGAffineTransform.identity
        })
    }
}
