//
//  CustomButton.swift
//  MovieListCase
//
//  Created by BaranK Kutlu on 2.06.2022.
//

import UIKit

protocol CustomButtonDelegate: AnyObject {
    func customButtonTapped()
}

class CustomButton: UIView {
    private var buttonTitle: String!
    
    var buttonIcon: String? = nil
    var buttonTitleSize: CGFloat = 8.0
    var textColor: UIColor = .black
    var isDashed: Bool = false
    var withIcon: Bool = false
    var cornerRadius: CGFloat = 0.0
    var dashedPattern: [NSNumber] = [2,2]
    var dashColor: CGColor = UIColor.black.cgColor
    var buttonBackgroundColor: UIColor = .white
    var borderWith: CGFloat = 1.0
    var borderColor: CGColor = UIColor.black.cgColor
    var titleWeight: UIFont.Weight = .medium
    
    weak var delegate: CustomButtonDelegate?

    convenience init(frame: CGRect, buttonTitle: String) {
        self.init(frame: frame)
        self.buttonTitle = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    
    private func createButton() {
        let button = UIButton(type: .system)
        if withIcon, buttonIcon != nil  {            
            let attributedTitle = createTitleWithIcon(title: buttonTitle, icon: buttonIcon!)
            button.setAttributedTitle(attributedTitle, for: .normal)
        } else {
            button.setAttributedTitle(NSAttributedString(string: buttonTitle, attributes: [NSAttributedString.Key.foregroundColor : textColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: buttonTitleSize, weight: titleWeight)]), for: .normal)
        }
        button.backgroundColor = buttonBackgroundColor
        button.layer.cornerRadius = cornerRadius
        button.frame = bounds
        
        if isDashed {
            button.addLineDashedStroke(pattern: dashedPattern, radius: cornerRadius, color: dashColor)
        } else {
            button.layer.borderWidth = borderWith
            button.layer.borderColor = borderColor
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        button.addGestureRecognizer(tap)
        addSubview(button)
    }
    
    func createTitleWithIcon(title: String, icon: String) -> NSMutableAttributedString {
        let imageAttachment = NSTextAttachment()
        let image = UIImage(systemName: icon)!.withTintColor(textColor).withConfiguration(UIImage.SymbolConfiguration.init(font: UIFont.systemFont(ofSize: buttonTitleSize, weight: titleWeight)))
        imageAttachment.image = image
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(buttonTitle!)"))
        let range = NSRange(location: 0, length: (fullString as NSAttributedString).length)
        fullString.addAttributes([NSAttributedString.Key.foregroundColor : textColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: buttonTitleSize, weight: titleWeight)], range: range)
        return fullString
    }
    
    
    private func updateView() {
        createButton()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.customButtonTapped()
    }
    
}


extension UIView {
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.addSublayer(borderLayer)
    }
}
