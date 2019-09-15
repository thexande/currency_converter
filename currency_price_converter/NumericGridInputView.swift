import UIKit
import Anchorage

protocol NumericInputGridViewDelegate: AnyObject {
    func didSelectNumeral(_ numberal: Int)
    func didSelectDecimal()
    func didSelectDelete()
}

final class NumericGridInputView: UIView {
    
    weak var delegate: NumericInputGridViewDelegate?
    
    private func makeItemView(for item: ItemView.Properties) -> UIView {
        let view = ItemView()
        view.render(item)
        
        view.onAction = { [weak self] action in
            switch action {
            case .addDecimalPlace:
                self?.delegate?.didSelectDecimal()
            case .delete:
                self?.delegate?.didSelectDelete()
            case .selectedNumber(let numeral):
                self?.delegate?.didSelectNumeral(numeral)
            }
            
        }
        
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var rows: [UIStackView] = [.init(), .init(), .init()]
        
        for index in 1...9 {
            if index <= 3 {
                rows[0].addArrangedSubview(makeItemView(for: .number(index)))
            } else if index <= 6 {
                rows[1].addArrangedSubview(makeItemView(for: .number(index)))
            } else if index <= 9 {
                rows[2].addArrangedSubview(makeItemView(for: .number(index)))
            }
        }
        
        let fourthRowProperties: [ItemView.Properties] = [.symbol(.decimal), .number(0), .symbol(.delete)]
        
        rows.append(.init(arrangedSubviews: fourthRowProperties.map(makeItemView(for:))))
        
        for row in rows {
            row.axis = .horizontal
            row.distribution = .fillEqually
        }
        
        let stack = UIStackView(arrangedSubviews: rows)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.edgeAnchors == edgeAnchors
        stack.heightAnchor == stack.widthAnchor * 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
