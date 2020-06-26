//
//  NoirSelectCollectionViewCell.swift
//  MTTN
//
//  Created by Naman Jain on 31/05/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Pastel

class NoirSelectCollectionViewCell: UICollectionViewCell {
    var socialViewController: SocialViewController?
    
    
    var cardNumber: String?{
        didSet{
            guard let number = cardNumber else { return }
            numberLabel.text = number
            numberLabel.alpha = 1
            titleLabel.alpha = 0
        }
    }
    
    var cardName: String?{
        didSet{
            guard let name = cardName else { return }
            nameLabel.text = name
            nameLabel.alpha = 1
            titleLabel.alpha = 0
        }
    }
    
    lazy var pastelView: PastelView = {
        let view = PastelView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        // Custom Direction
        view.startPastelPoint = .bottomLeft
        view.endPastelPoint = .topRight
        
        
        // Custom Duration
        view.animationDuration = 1.2
        
        // Custom Color
        view.setColors([UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                        UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0),
                        UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0),
                        UIColor(red: 45/255, green: 45/255, blue: 45/255, alpha: 1.0),
                        UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                        UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1.0),
                        UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                        UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0),
                        UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                        UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 1.0),
                        UIColor(red: 0, green: 0, blue: 0, alpha: 1.0),
                        UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0)])
        view.startAnimation()
        return view
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TAP TO ACTIVATE NOIR CARD"
        label.textColor = #colorLiteral(red: 0.7739099264, green: 0.6036915779, blue: 0.204376936, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var noirSelectLabel: UILabel = {
        let label = UILabel()
        label.text = "N  O  I  R     S  E  L  E  C  T"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var offersLabel: UILabel = {
        let label = UILabel()
        label.text = "NOIR SELECT OFFERS"
        label.textColor = #colorLiteral(red: 0.7739099264, green: 0.6036915779, blue: 0.204376936, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "NAMAN JAIN"
        label.textColor = #colorLiteral(red: 0.7739099264, green: 0.6036915779, blue: 0.204376936, alpha: 1)
        label.alpha = 0
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1709 1808 2701 0903"
        label.textColor = #colorLiteral(red: 0.7739099264, green: 0.6036915779, blue: 0.204376936, alpha: 1)
        label.alpha = 0
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()
    
    lazy var validThruLabel: UILabel = {
        let label = UILabel()
        label.text = "VALID THRU 01/20"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoDark)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showNoirCardsOffers), for: .touchUpInside)
        return button
    }()
    
    lazy var seperatorLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            seperatorLineView.backgroundColor = .quaternaryLabel
        } else {
            setupTheming()
        }
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(pastelView)
        pastelView.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 16, rightConstant: 10)
        addSubview(noirSelectLabel)
        noirSelectLabel.anchorWithConstants(top: pastelView.topAnchor, left: pastelView.leftAnchor, bottom: nil, right: pastelView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        addSubview(nameLabel)
        nameLabel.anchorWithConstants(top: noirSelectLabel.bottomAnchor, left: pastelView.leftAnchor, bottom: nil, right: pastelView.rightAnchor, topConstant: 40, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        addSubview(numberLabel)
        numberLabel.anchorWithConstants(top: nameLabel.bottomAnchor, left: pastelView.leftAnchor, bottom: nil, right: pastelView.rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
//        addSubview(validThruLabel)
//        validThruLabel.anchorWithConstants(top: nil, left: pastelView.leftAnchor, bottom: pastelView.bottomAnchor, right: pastelView.rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        addSubview(infoButton)
        _ = infoButton.anchor(top: nil, left: nil, bottom: pastelView.bottomAnchor, right: pastelView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 4, widthConstant: 30, heightConstant: 30)
        addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: pastelView.topAnchor, left: pastelView.leftAnchor, bottom: pastelView.bottomAnchor, right: pastelView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
        
        addSubview(seperatorLineView)
        _ = seperatorLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func showNoirCardsOffers(){
        
    }
}

extension NoirSelectCollectionViewCell: Themed {
    func applyTheme(_ theme: AppTheme) {
        seperatorLineView.backgroundColor = theme.separatorColor
    }
}

