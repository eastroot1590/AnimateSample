//
//  RawScrollViewController.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/08/24.
//

import UIKit

class RawScrollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let image = UIImage(named: "sample")!
        
        let rawScroll = RawScrollView(frame: view.frame)
        rawScroll.contentView = UIImageView(image: image)
        rawScroll.contentSize = image.size
        // center
        rawScroll.contentOffset = CGPoint(x: (image.size.width - view.bounds.width) / 2,
                                                   y: (image.size.height - view.bounds.height) / 2)
        rawScroll.backgroundColor = .systemBlue
        rawScroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(rawScroll)
    }
}
