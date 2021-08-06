//
//  SelectorView.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/04.
//

import UIKit

protocol SelectorViewDelegate {
    func selectorSelect(_ selector: SelectorView, option: UIView)
}

class SelectorView: UIView {
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var lineSpacing: CGFloat = 10
    
    var buttonsInColumn: CGFloat = 0
    var buttonsInRow: CGFloat
    
    var options: [UIView] = []
//    var selectedOption: UIView?
    
    var layout: Bool = true
    
    var delegate: SelectorViewDelegate?
    
    init(_ count: Int, row: Int) {
        self.buttonsInRow = CGFloat(row)
        
        super.init(frame: .zero)
        
        for index in 0 ..< count {
            let button = UIView()
            button.backgroundColor = .systemBlue
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selected(_:))))
            button.tag = index
            addSubview(button)
            options.append(button)
        }
        
        buttonsInColumn = (CGFloat(options.count) / buttonsInRow).rounded(.up)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("selector layout subviews")
        
        let vSpace = lineSpacing * (buttonsInColumn - 1) + contentInset.top + contentInset.bottom
        let hSpace = lineSpacing * (buttonsInRow - 1) + contentInset.left + contentInset.right
        
        var origin = CGPoint(x: contentInset.left, y: contentInset.top)
        let size = CGSize(width: (frame.width - hSpace) / buttonsInRow, height: (frame.height - vSpace) / buttonsInColumn)
        
        for button in options {
            button.frame = CGRect(origin: origin, size: size)
            
            origin.y += size.height
            origin.y += lineSpacing
            
            if origin.y >= frame.height - contentInset.top - contentInset.bottom {
                origin.y = contentInset.top
                origin.x += size.width + lineSpacing
            }
        }
    }
    
    @objc func selected(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else {
            return
        }
        print("selector selected \(selectedView.tag)")
        
        delegate?.selectorSelect(self, option: selectedView)
    }
}
