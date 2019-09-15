import UIKit
import Anchorage

final class CircleWipeView: UIView, ViewRendering {
    
    struct Properties {
        enum Direction {
            case left
            case right
        }
        let direction: Direction
        let complete: CGFloat
        let backgroundColor: UIColor
        let circleWipeColor: UIColor
        static let `default` = Properties(direction: .left, complete: 0, backgroundColor: .black, circleWipeColor: .black)
    }
    
    var duration = 0.3
    var animator: UIViewPropertyAnimator?
    var hasConfiguredCircle = false
    let circle = UIView()
    var cachedOffset: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .bitcoin
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(_ properties: Properties) {
        
        if properties.backgroundColor != backgroundColor {
            self.backgroundColor = properties.backgroundColor
        }
        
        if properties.circleWipeColor != circle.backgroundColor {
            circle.backgroundColor = properties.circleWipeColor
        }
        
        let fractionComplete = properties.direction == .right
            ? properties.complete
            : abs(1 - properties.complete)
        
        animator?.fractionComplete = fractionComplete
        
        
        print("cached offset \(cachedOffset)")
        if properties.complete == 0 && cachedOffset.rounded() == 1 {
            backgroundColor = circle.backgroundColor
        }
        
        cachedOffset = fractionComplete
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
