//
//  UserDetailView.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/11/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import UIKit

class UserDetailView: UIView {
    
    var backgroundImageView: UIImageView?
    var backgroundBlurView: UIVisualEffectView?
    
    var avatarView: UIView?
    var avatarImageView: UIImageView?
    var avatarSlackName: UILabel?
    var avatarTitleName: UILabel?
    
    var contactStackView: UIStackView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeViews()
    }
    
    func initializeViews() {
        backgroundColor = .white

        initializeBackgroundView()
        initializeAvatarView()
        initializeContactView()
    }
    
    var constraintsInitialized = false
    override func layoutSubviews() {
        if !constraintsInitialized {
            // first time through initialize
            // all the view constraints
            //
            initializeBackgroundConstraints()
            initializeAvatarConstraints()
            initializeContactConstraints()
            constraintsInitialized = true
        }
        
        super.layoutSubviews()
    }
    
    func setContacts(_ contacts: [String: URL]) {
        guard let contactStackView = contactStackView else { return }
        
        // remove existing contact buttons in stack
        //
        for view in contactStackView.arrangedSubviews {
            contactStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // create a button for each contact type
        // that will open the assocaited uri
        //
        for (contact, value) in contacts {
            let button = Button() {
                UIApplication.shared.open(value) { success in
                    if !success {
                        let alert = UIAlertController(title: contact + " not supported",
                                                      message: nil,
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                                               comment: "Default action"), style: .default))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 7
            button.layer.masksToBounds = true
            button.setTitle(contact, for: .normal)
            
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.widthAnchor.constraint(equalToConstant: 120).isActive = true
            
            contactStackView.addArrangedSubview(button)
        }
    }

    fileprivate func initializeBackgroundView() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            backgroundImageView = UIImageView()
            guard let backgroundImageView = backgroundImageView else { return }
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.alpha = 0.75
            backgroundImageView.backgroundColor = UIColor.slackPurp()
            addSubview(backgroundImageView)
        
            backgroundBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            guard let backgroundBlurView = backgroundBlurView else { return }
            backgroundBlurView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(backgroundBlurView)
        }
    }

    fileprivate func initializeAvatarView() {
        avatarView = UIView()
        guard let avatarView = avatarView else { return }
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.backgroundColor = .clear
        avatarView.isHidden = true
        addSubview(avatarView)
        
        avatarImageView = UIImageView()
        guard let avatarImageView = avatarImageView else { return }
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = .clear
        avatarImageView.layer.cornerRadius = 70
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.borderColor = UIColor.darkGray.cgColor
        avatarImageView.layer.masksToBounds = true
        avatarView.addSubview(avatarImageView)

        avatarTitleName = UILabel()
        guard let avatarTitleName = avatarTitleName else { return }
        avatarTitleName.translatesAutoresizingMaskIntoConstraints = false
        avatarTitleName.font = UIFont.systemFont(ofSize: 19)
        avatarTitleName.textColor = .black
        avatarView.addSubview(avatarTitleName)
        
        avatarSlackName = UILabel()
        guard let avatarSlackName = avatarSlackName else { return }
        avatarSlackName.translatesAutoresizingMaskIntoConstraints = false
        avatarSlackName.font = UIFont.systemFont(ofSize: 19)
        avatarSlackName.textColor = .darkGray
        avatarView.addSubview(avatarSlackName)
    }

    fileprivate func initializeContactView() {
        contactStackView = UIStackView()
        guard let contactStackView = contactStackView else { return }
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.backgroundColor = .clear
        contactStackView.axis = .vertical;
        contactStackView.distribution = .equalSpacing;
        contactStackView.alignment = .center;
        contactStackView.spacing = 20;
        addSubview(contactStackView)
    }
    
    fileprivate func initializeBackgroundConstraints() {
        guard let backgroundImageView = backgroundImageView,
            let backgroundBlurView = backgroundBlurView else { return }
        
        addConstraint(NSLayoutConstraint(item: backgroundImageView,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundImageView,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundImageView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .top,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundImageView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundBlurView,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundBlurView,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundBlurView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .top,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: backgroundBlurView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
    }

    fileprivate func initializeAvatarConstraints() {
        guard let avatarView = avatarView,
            let avatarImageView = avatarImageView,
            let avatarSlackName = avatarSlackName,
            let avatarTitleName = avatarTitleName else { return }
        
        addConstraint(NSLayoutConstraint(item: avatarView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: avatarView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: avatarView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 200))
        addConstraint(NSLayoutConstraint(item: avatarView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 200))
        
        addConstraint(NSLayoutConstraint(item: avatarImageView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: avatarView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: avatarImageView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: avatarView,
                                         attribute: .top,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: avatarImageView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 140))
        addConstraint(NSLayoutConstraint(item: avatarImageView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 140))
        
        addConstraint(NSLayoutConstraint(item: avatarTitleName,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: avatarImageView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 10))
        addConstraint(NSLayoutConstraint(item: avatarTitleName,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: avatarView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: avatarTitleName,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 20))
        
        addConstraint(NSLayoutConstraint(item: avatarSlackName,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: avatarTitleName,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 2))
        addConstraint(NSLayoutConstraint(item: avatarSlackName,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: avatarView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: avatarSlackName,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 20))
    }

    fileprivate func initializeContactConstraints() {
        guard let contactStackView = contactStackView else { return }
        
        addConstraint(NSLayoutConstraint(item: contactStackView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: avatarView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 10))
        addConstraint(NSLayoutConstraint(item: contactStackView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: avatarView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
    }
}
