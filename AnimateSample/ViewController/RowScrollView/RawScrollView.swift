//
//  RawScrollView.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/24.
//

import UIKit

class RawScrollView: UIView {
    enum State {
        case `default`
        case dragging(initialOffset: CGPoint)
    }

    var state: State = .default
    
    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let contentView = contentView {
                addSubview(contentView)
                contentView.frame = CGRect(origin: contentOrigin, size: contentSize)
            }
        }
    }
    
    var contentSize: CGSize = .zero {
        didSet {
            contentView?.frame.size = contentSize
        }
    }
    
    var contentOffset: CGPoint = .zero {
        didSet {
            contentView?.frame.origin = contentOrigin
        }
    }
    
    let panRecognizer = UIPanGestureRecognizer()
    
    var contentOffsetBounds: CGRect {
        let width = contentSize.width - bounds.width
        let height = contentSize.height - bounds.height
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    private var contentOrigin: CGPoint {
        CGPoint(x: -contentOffset.x, y: -contentOffset.y)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addGestureRecognizer(panRecognizer)
        panRecognizer.addTarget(self, action: #selector(handlePanRecognizer))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePanRecognizer(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            state = .dragging(initialOffset: contentOffset)
        case .changed:
            let translation = sender.translation(in: self)
            if case .dragging(let initialOffset) = state {
                contentOffset = clampOffset(initialOffset - translation)
            }
        case .ended:
            state = .default
        // Other cases
        default:
            break
        }
    }
    
    func clampOffset(_ offset: CGPoint) -> CGPoint {
        return offset.clamped(to: contentOffsetBounds)
    }
}
