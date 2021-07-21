//
//  CitizenDetailForm.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/07/21.
//

import UIKit

class CitizenDetailForm: VStackScroll {
    /// 프로필 이미지 (배너)
    let profileImage = UIImageView()
    
    let nameLabel = UILabel()
    
    let speciesSubject = SimpleSubject()
    let genderSubject = SimpleSubject()

    init(profile: UIImage?) {
        super.init()
        
        profileImage.image = profile
        profileImage.frame.size = CGSize(width: 400, height: 400)
        profileImage.contentMode = .scaleAspectFit
        pushHeader(profileImage, height: 400)
        
        nameLabel.frame.size = CGSize(width: 0, height: 40)
        nameLabel.font = .boldSystemFont(ofSize: 24)
        push(nameLabel, spacing: 0)

        push(speciesSubject, spacing: 10)
        push(genderSubject, spacing: 10)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fatch(_ citizenInfo: CitizenInfo) {
        nameLabel.text = citizenInfo.name
        nameLabel.sizeToFit()
        
        speciesSubject.fatch(title: "종", subject: citizenInfo.species)
        genderSubject.fatch(title: "성별", subject: citizenInfo.gender)
    }
}
