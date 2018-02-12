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
            initializeBackgroundConstraints()
            initializeAvatarConstraints()
            initializeContactConstraints()
            constraintsInitialized = true
        }
        
        super.layoutSubviews()
    }

    fileprivate func initializeBackgroundView() {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            backgroundImageView = UIImageView()
            guard let backgroundImageView = backgroundImageView else { return }
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.alpha = 0.75
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
        
        avatarSlackName = UILabel()
        guard let avatarSlackName = avatarSlackName else { return }
        avatarSlackName.translatesAutoresizingMaskIntoConstraints = false
        avatarSlackName.font = UIFont.systemFont(ofSize: 19)
        avatarSlackName.textColor = .black
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
        contactStackView.spacing = 30;
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
            let avatarSlackName = avatarSlackName else { return }
        
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
        
        addConstraint(NSLayoutConstraint(item: avatarSlackName,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: avatarImageView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 20))
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
                                         constant: 25))
    }

    fileprivate func initializeContactConstraints() {
        guard let contactStackView = contactStackView else { return }
        
    }
}
