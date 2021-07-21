//
//  CitizenInfo.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/19.
//

import Foundation

/// 주민 정보를 표현할 수 있는 최소 정보
/// - profileImage : 썸네일 이미지
/// - name : 한글 이름
struct CitizenInfo: Decodable {
    let profileImage: String
    let iconImage: String
    
    let name: String
    let signature: String
    
    let species: String
    let gender: String
    let tendency: String
    let character: String
    let birth: String
    let constellation: String
    let hobby: String
    let specialty: String
    let dream: String
    let favoriteSentence: String
}
