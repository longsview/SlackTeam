//
//  UserViewController.swift
//  SlackTeam
//
//  Created by Nicholas Long on 2/9/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    func configureView() {
        // Update the user interface for the detail item
        //
        guard let detail = detailItem, let detailView = view as? UserDetailView else { return }
        detailView.avatarView?.isHidden = false
        title = detailItem?.realName
        
        guard let icon192 = detail.icon192, let imageUrl = URL(string:icon192) else { return }
        detailView.backgroundImageView?.setImageWith(imageUrl, placeholderImage:nil)
        detailView.avatarImageView?.setImageWith(imageUrl, placeholderImage:nil)
        
        guard let name = detail.name else { return }
        detailView.avatarSlackName?.text = "@" + name
        detailView.avatarTitleName?.text = detail.title
        
        var contacts = [String:URL]()
        if let email = detail.email, !email.isEmpty, let url = URL(string: "mailto:"+email) {
            contacts["email"] = url
        }
        if let skype = detail.skype, !skype.isEmpty, let url = URL(string: "skype:"+skype+"?call") {
            contacts["skype"] = url
        }
        if let phone = detail.phone, !phone.isEmpty, let url = URL(string: "tel:"+phone) {
            contacts["phone"] = url
        }
        detailView.setContacts(contacts)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    var detailItem: User? {
        didSet {
            configureView()
        }
    }

    func openPreviewUrl(_ url: URL, alertMessage: String) {
        UIApplication.shared.open(url) { success in
            // Alert user if the given contact protocol is not supported
            //
            if !success {
                let alert = UIAlertController(title: alertMessage,
                                              message: nil,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                                       comment: "Default action"), style: .default))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }

    override var previewActionItems: [UIPreviewActionItem] {
        guard let detail = detailItem else { return [UIPreviewActionItem]() }

        var contacts = [UIPreviewAction]()
        if let email = detail.email, !email.isEmpty, let url = URL(string: "mailto:"+email) {
            let emailAction = UIPreviewAction(title: "Email", style: .default) { [weak self] (action, viewController) -> Void in
                self?.openPreviewUrl(url, alertMessage: "Email not supported")
            }
            contacts.append(emailAction)
        }
        if let skype = detail.skype, !skype.isEmpty, let url = URL(string: "skype:"+skype+"?call") {
            let skypeAction = UIPreviewAction(title: "Skype", style: .default) { [weak self] (action, viewController) -> Void in
                self?.openPreviewUrl(url, alertMessage: "Skype not supported")
            }
            contacts.append(skypeAction)
        }
        if let phone = detail.phone, !phone.isEmpty, let url = URL(string: "tel:"+phone) {
            let callAction = UIPreviewAction(title: "Call", style: .default) { [weak self] (action, viewController) -> Void in
                self?.openPreviewUrl(url, alertMessage: "Phone not supported")
            }
            contacts.append(callAction)
        }
        return contacts
    }
}

