//
//  FloatingMessage.swift
//  MTTN
//
//  Created by Naman Jain on 07/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

open class FloatingMessage: UIViewController{
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.backgroundColor = .orange
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open func floatingMessage(Message: String, onPresentation: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        UIApplication.shared.keyWindow?.addSubview(container)
        container.centerXAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.centerXAnchor).isActive = true
        container.topAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        container.widthAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.widthAnchor, multiplier: 0.85).isActive = true
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.container.alpha = 0
        self.messageLabel.text = Message
        container.addSubview(self.messageLabel)
        _ = messageLabel.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            self.container.transform = CGAffineTransform(translationX: 0, y: -100)
            self.container.alpha = 1
            onPresentation()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.container.transform = .identity
            }, completion: {
                (value: Bool) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { () -> Void in
                    onDismiss()
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.container.transform = CGAffineTransform(translationX: 0, y: -100)
                        self.container.alpha = 0
                    }) { (_) in
                        self.container.removeFromSuperview()
                        self.messageLabel.removeFromSuperview()
                    }
                })
            })
        })
    }
}
