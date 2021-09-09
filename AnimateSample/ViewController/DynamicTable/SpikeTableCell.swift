//
//  SpikeTableCell.swift
//  AnimateSample
//
//  Created by 이동근 on 2021/09/07.
//

import UIKit

class SpikeTableCell: UITableViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    let stack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        titleLabel.text = "default"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleLabel)
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "subtitle\nlongsubtitle\nasdfsad\nasdfsdf\nasfasdge"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        subtitleLabel.isHidden = !selected
    }

}
