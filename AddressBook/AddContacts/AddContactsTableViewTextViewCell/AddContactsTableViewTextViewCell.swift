//
//  AddContactsTableViewTextViewCell.swift
//  AddressBook
//
//  Created by Pratik Hirve on 06/11/19.
//  Copyright © 2019 Pratik Hirve. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol AddContactsTableViewTextViewCellDelegate: class {
    func addressTextViewHeightChanged()
}

class AddContactsTableViewTextViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var addressTextView: IQTextView! {
        didSet {
            addressTextView.placeholder = "Text"
            addressTextView.delegate = self
            addressTextView.isScrollEnabled = false
        }
    }

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    // MARK: - Parameter
    weak var delegate: AddContactsTableViewTextViewCellDelegate?
    weak var textChangedDelegate: AddContactsTableViewCellTextChangedDelegate?
    var cellType: AddNewContactCellTypes?

    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AddContactsTableViewTextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let constraint = CGSize(width: addressTextView.frame.width, height: CGFloat(MAXFLOAT))
        let rect: CGRect = textView
            .text
            .boundingRect(with: constraint,
                          options: .usesLineFragmentOrigin,
                          attributes:
                [NSAttributedString.Key.font: textView.font ?? UIFont.systemFont(ofSize: 14)],
                                                      context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)

        heightConstraint.constant = size.height + 20

        delegate?.addressTextViewHeightChanged()
        guard let cellType = self.cellType else {
            print("Please set cellType")
            return }
        textChangedDelegate?.textChangedFor(cellType: cellType, text: textView.text)
    }
}
