//
//  AnimateSampleUserDefault.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/09/09.
//

import Foundation

class AnimateSampleUserDefault {
    static let shared: AnimateSampleUserDefault = AnimateSampleUserDefault()
    
    enum UserDefaultKey: String {
        case gridCellInfo
    }
    
    private init() {
        
    }
    
    func setValue(_ newValue: String?, forKey key: UserDefaultKey) {
        guard let value = newValue else {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
            return
        }
        
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    func getValue(forKey key: UserDefaultKey) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }
}
