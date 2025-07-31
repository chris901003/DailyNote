// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol NoteEditAddPhotoCellDelegate: AnyObject {
    func tapAddPhotoCell()
}

class NoteEditAddPhotoCell: UICollectionViewCell {
    static let cellId = "NoteEditAddPhotoCellId"

    let iconView = UIImageView()

    var isAddedBorder = false
    weak var delegate: NoteEditAddPhotoCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !isAddedBorder {
            addDashedBorder(color: .systemBlue, cornerRadius: 15.0, lineWidth: 2.5)
            isAddedBorder = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCell)))
        contentView.isUserInteractionEnabled = true

        iconView.image = UIImage(systemName: "plus")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
    }

    private func layout() {
        contentView.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 50),
            iconView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func tapCell() {
        delegate?.tapAddPhotoCell()
    }
}
