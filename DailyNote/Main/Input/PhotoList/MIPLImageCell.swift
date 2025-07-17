// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MIPLImageCell: UICollectionViewCell {
    static let cellId = "MIPLImageCellId"
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(image: UIImage) {
        imageView.image = image
    }

    private func setup() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "InitialBackground")
    }

    private func layout() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
