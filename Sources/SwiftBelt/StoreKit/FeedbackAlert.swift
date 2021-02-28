//
//  FeedbackAlert.swift
//  
//
//  Created by Thomas Delgado on 27/02/21.
//

import UIKit

class FeedbackAlert: BaseViewController {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var alertView: UIView!

    static let textPadding = UIEdgeInsets(top: 15,
                                          left: 15,
                                          bottom: 10,
                                          right: 15)
    let placeholderKey = "feedbackAlertPlaceholder"
    var minimumTextLength = Int.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTextView()
    }

    func configureView() {
        alwaysMoveKeyboard = true
        fixedKeyboardOffset = 120
        labelTitle.font = DesignSheet.Font.headline
        labelDescription.font = DesignSheet.Font.body
        buttonSend.setAppearanceFor(.disabled)
        alertView.cornerRadius = DesignSheet.cornerRadius
    }

    func configureTextView() {
        textView.borderColor = DesignSheet.borderColor
        textView.textContainerInset = FeedbackAlert.textPadding
        textView.cornerRadius = DesignSheet.cornerRadius
        textView.placeholder = placeholderKey.localized()
        textView.borderWidth = 1
        textView.delegate = self
    }

    @IBAction func didTapClose(_ sender: Any) {
//        StoreReviewManager.shared.negativeReviewWith("") { _ in }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapSend(_ sender: Any) {
        buttonSend.startAnimating()
//        StoreReviewManager.shared.negativeReviewWith(textView.text) {[weak self] _ in
//            self?.buttonSend.stopAnimating()
//            self?.dismiss(animated: true, completion: nil)
//        }
    }

}

extension FeedbackAlert: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.layer.animatedSelectionWith(selectionColor: DesignSheet.borderColor.cgColor)
        }
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.layer.animatedSelectionWith(selectionColor: DesignSheet.primaryColor.cgColor)
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceHolder(textView)
        if textView.text.count > minimumTextLength {
            buttonSend.isEnabled = true
            buttonSend.setAppearanceFor(.primary)
        } else {
            buttonSend.isEnabled = false
            buttonSend.setAppearanceFor(.disabled)
        }
    }
}

