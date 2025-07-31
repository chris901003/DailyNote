// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol NoteEditPhotoCellDelegate: AnyObject {
    func tapPhotoCell(cell: NoteEditPhotoCell)
}

class NoteEditPhotoCell: UICollectionViewCell {
    static let cellId = "NoteEditPhotoCellId"

    let imageView = UIImageView()

    weak var delegate: NoteEditPhotoCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func config(image: UIImage?) {
        imageView.image = image
    }

    private func setup() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPhotoCell)))
        contentView.isUserInteractionEnabled = true

        imageView.contentMode = .scaleAspectFit
    }

    private func layout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    @objc private func tapPhotoCell() {
        delegate?.tapPhotoCell(cell: self)
    }
}
