//
//  UIView+AnimateSample.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import UIKit

extension UIView {
    /// 최상위 ViewController가 UINavigationController일 경우 반환한다.
    var rootNavigationController: UINavigationController? {
        guard let window = self.window else {
            return nil
        }
        
        return window.rootViewController as? UINavigationController
    }
}
