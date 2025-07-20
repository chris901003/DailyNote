// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol MIPLImageCellDelegate: AnyObject {
    func deleteImageAction(cell: MIPLImageCell)
}

class MIPLImageCell: UICollectionViewCell {
    static let cellId = "MIPLImageCellId"

    let imageView = UIImageView()
    let deleteButton = UILabel()

    weak var delegate: MIPLImageCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        defaultSetup()
    }

    private func defaultSetup() {
        imageView.image = UIImage(named: "InitialBackground")
        delegate = nil
    }

    func config(image: UIImage) {
        imageView.image = image
    }

    private func setup() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "InitialBackground")

        deleteButton.text = "刪除"
        deleteButton.textAlignment = .center
        deleteButton.textColor = .white
        deleteButton.font = .systemFont(ofSize: 18, weight: .semibold)
        deleteButton.backgroundColor = .systemRed
        deleteButton.layer.cornerRadius = 15.0
        deleteButton.clipsToBounds = true
        deleteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDeleteAction)))
        deleteButton.isUserInteractionEnabled = true
    }

    private func layout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -12)
        ])

        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc private func tapDeleteAction() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn]) {
            self.deleteButton.transform = .init(scaleX: 0.94, y: 0.94)
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveEaseOut]) {
                self.deleteButton.transform = .identity
            } completion: { _ in
                self.delegate?.deleteImageAction(cell: self)
            }
        }
    }
}
