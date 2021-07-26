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
    let tendencySubject = SimpleSubject()
    let characterSubject = SimpleSubject()
    let birthSubject = SimpleSubject()
    let constellationSubject = SimpleSubject()
    let hobbySubject = SimpleSubject()
    let dreamSubject = SimpleSubject()
    let specialtySubject = SimpleSubject()
    let favoriteSentenceSubjetc = SimpleSubject()

    init(frame: CGRect, profile: UIImage?) {
        super.init(frame: frame)
        
        profileImage.image = profile
        profileImage.frame.size = CGSize(width: 400, height: 400)
        profileImage.contentMode = .scaleAspectFit
        setBanner(profileImage, height: 400)
        
        nameLabel.frame.size = CGSize(width: 0, height: UIFont.boldSystemFont(ofSize: 24).lineHeight)
        nameLabel.font = .boldSystemFont(ofSize: 24)
        push(nameLabel, spacing: 20)

        push(speciesSubject, spacing: 10)
        push(genderSubject, spacing: 10)
        push(tendencySubject, spacing: 10)
        push(characterSubject, spacing: 10)
        push(birthSubject, spacing: 10)
        push(constellationSubject, spacing: 10)
        push(hobbySubject, spacing: 10)
        push(dreamSubject, spacing: 10)
        push(specialtySubject, spacing: 10)
        push(favoriteSentenceSubjetc, spacing: 10)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fatch(_ citizenInfo: CitizenInfo) {
        nameLabel.text = citizenInfo.name
        nameLabel.sizeToFit()
        
        speciesSubject.fatch(title: "종", subject: citizenInfo.species)
        genderSubject.fatch(title: "성별", subject: citizenInfo.gender)
        tendencySubject.fatch(title: "성향", subject: citizenInfo.tendency)
        characterSubject.fatch(title: "성격", subject: citizenInfo.character)
        birthSubject.fatch(title: "생일", subject: citizenInfo.birth)
        constellationSubject.fatch(title: "별자리", subject: citizenInfo.constellation)
        hobbySubject.fatch(title: "취미", subject: citizenInfo.hobby)
        dreamSubject.fatch(title: "장래희망", subject: citizenInfo.dream)
        specialtySubject.fatch(title: "장기", subject: citizenInfo.specialty)
        favoriteSentenceSubjetc.fatch(title: "좋아하는 문장", subject: citizenInfo.favoriteSentence)
        
        contentView.layoutIfNeeded()
        
        contentView.playCascade()
    }
}
