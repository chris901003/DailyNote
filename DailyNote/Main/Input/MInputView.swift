// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MInputView: UIView {
    let label = UILabel()
    let textView = UITextView()

    let iconContent = UIView()
    let imageIcon = UIImageView()
    let clockIcon = UIImageView()
    let sendIcon = UIImageView()

    var textViewHeightConstraint: NSLayoutConstraint!

    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let view = UITextView()
        view.text = textView.text
        view.isScrollEnabled = false
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = view.sizeThatFits(size)
        textViewHeightConstraint.constant = estimatedSize.height
    }

    private func setup() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 15

        label.text = "輸入新的一段內容吧!"
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabelAction)))
        label.isUserInteractionEnabled = true

        textView.text = "輸入新的一段內容吧!"
        textView.font = .systemFont(ofSize: 16, weight: .semibold)
        textView.backgroundColor = .clear
        textView.alpha = 0

        imageIcon.image = UIImage(systemName: "photo")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        imageIcon.contentMode = .scaleAspectFit

        clockIcon.image = UIImage(systemName: "clock")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        clockIcon.contentMode = .scaleAspectFit

        sendIcon.image = UIImage(systemName: "paperplane")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        sendIcon.contentMode = .scaleAspectFit
    }

    private func layout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 10)
        textViewHeightConstraint.isActive = true

        addSubview(iconContent)
        iconContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconContent.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            iconContent.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconContent.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            iconContent.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])

        iconContent.addSubview(imageIcon)
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageIcon.topAnchor.constraint(equalTo: iconContent.topAnchor),
            imageIcon.leadingAnchor.constraint(equalTo: iconContent.leadingAnchor),
            imageIcon.bottomAnchor.constraint(equalTo: iconContent.bottomAnchor),
            imageIcon.widthAnchor.constraint(equalToConstant: 25),
            imageIcon.heightAnchor.constraint(equalToConstant: 25)
        ])

        iconContent.addSubview(clockIcon)
        clockIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clockIcon.centerYAnchor.constraint(equalTo: iconContent.centerYAnchor),
            clockIcon.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 12),
            clockIcon.widthAnchor.constraint(equalToConstant: 25),
            clockIcon.heightAnchor.constraint(equalToConstant: 25)
        ])

        iconContent.addSubview(sendIcon)
        sendIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendIcon.centerYAnchor.constraint(equalTo: iconContent.centerYAnchor),
            sendIcon.trailingAnchor.constraint(equalTo: iconContent.trailingAnchor),
            sendIcon.widthAnchor.constraint(equalToConstant: 25),
            sendIcon.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

// MARK: - Utility
extension MInputView {
    @objc private func tapLabelAction() {
        textView.becomeFirstResponder()
    }
}
