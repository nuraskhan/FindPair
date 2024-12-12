//
//  View.swift
//  FindPair
//
//  Created by Aldongarov Nuraskhan on 12.12.2024.
//

import UIKit
import SnapKit

class CardView: UIButton {
    private let contentLabel = UILabel()
    private let contentImageView = UIImageView()
    
    var isRevealed = false {
        didSet {
            updateView()
        }
    }
    
    var card: Card? {
        didSet {
            setupCard()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentLabel.textAlignment = .center
        contentLabel.isHidden = true
        contentLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        addSubview(contentLabel)
        
        contentImageView.contentMode = .scaleAspectFit
        contentImageView.isHidden = true
        addSubview(contentImageView)
        
        layer.cornerRadius = 8
        backgroundColor = .lightGray
        clipsToBounds = true
        
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        contentImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setupCard() {
        guard let card = card else { return }
        
        if card.isImage, let image = card.content as? UIImage {
            contentImageView.image = image
            contentLabel.isHidden = true
            contentImageView.isHidden = false
        } else if !card.isImage, let text = card.content as? String {
            contentLabel.text = text
            contentImageView.isHidden = true
            contentLabel.isHidden = false
        }
    }
    
    private func updateView() {
        contentLabel.isHidden = !(card?.isImage == false && isRevealed)
        contentImageView.isHidden = !(card?.isImage == true && isRevealed)
        backgroundColor = isRevealed ? .white : .lightGray
    }
}
