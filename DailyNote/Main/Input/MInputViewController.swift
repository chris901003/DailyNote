// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MInputViewController: UIViewController {
    let placeholder = "輸入新的一段內容吧!"
    let manager = MInputManager()
    weak var delegate: PresentableVC?

    let label = UILabel()
    let textView = UITextView()

    let iconContent = UIView()
    let imageIcon = UIImageView()
    let clockView = MIClockView()
    let sendIcon = UIImageView()

    var textViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTextViewHeight()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDate()
    }

    private func adjustTextViewHeight() {
        if (textView.alpha == 0) {
            UIView.animate(withDuration: 0.25) {
                self.textViewHeightConstraint.constant = 30
                self.view.layoutIfNeeded()
            }
        } else {
            let view = UITextView()
            view.font = textView.font
            view.text = textView.text
            view.isScrollEnabled = false
            let size = CGSize(width: textView.frame.width, height: .infinity)
            let estimatedSize = view.sizeThatFits(size)
            UIView.animate(withDuration: 0.25) {
                self.textViewHeightConstraint.constant = min(max(30, estimatedSize.height), 120)
                self.view.layoutIfNeeded()
            }
        }
    }

    private func setup() {
        manager.vc = self
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 15

        label.text = placeholder
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabelAction)))
        label.isUserInteractionEnabled = true

        textView.text = manager.inputData.note
        textView.font = .systemFont(ofSize: 16, weight: .semibold)
        textView.backgroundColor = .clear
        textView.alpha = 0
        textView.delegate = self

        imageIcon.image = UIImage(systemName: "photo")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        imageIcon.contentMode = .scaleAspectFit
        imageIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPhotoAction)))
        imageIcon.isUserInteractionEnabled = true

        manager.setClockDate()

        sendIcon.image = UIImage(systemName: "paperplane")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
        sendIcon.contentMode = .scaleAspectFit
        sendIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendAction)))
        sendIcon.isUserInteractionEnabled = true
    }

    private func layout() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])

        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 11),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 10)
        textViewHeightConstraint.isActive = true

        view.addSubview(iconContent)
        iconContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconContent.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            iconContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            iconContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            iconContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
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

        iconContent.addSubview(clockView)
        clockView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clockView.centerYAnchor.constraint(equalTo: iconContent.centerYAnchor),
            clockView.leadingAnchor.constraint(equalTo: imageIcon.trailingAnchor, constant: 12)
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
extension MInputViewController {
    @objc private func tapLabelAction() {
        textView.becomeFirstResponder()
    }

    @objc private func tapPhotoAction() {
        manager.showPhotoMenu()
    }

    @objc private func sendAction() {
        do {
            try manager.sendAction()
            clockView.setNextTimeRange()
        } catch {
            let alert = UIAlertController(title: "創建失敗", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default)
            alert.addAction(okAction)
            delegate?.presentVC(alert)
        }
    }

    @objc private func receiveDidBecomeActive(_ notification: Notification) {
        setupDate()
    }

    private func setupDate() {
        let endDate = Date.now

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: endDate)
        guard let startDate = hour == 0 ? calendar.startOfDay(for: endDate) : calendar.date(byAdding: .hour, value: -1, to: endDate) else { return }
        clockView.setStartAndEndTime(startDate: startDate, endDate: endDate)
    }
}

// MARK: - UITextViewDelegate
extension MInputViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.alpha = 1
        label.alpha = 0
        adjustTextViewHeight()
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight()
        manager.inputData.note = textView.text
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        manager.inputData.note = textView.text
        label.text = textView.text.isEmpty ? placeholder : textView.text
        textView.alpha = 0
        label.alpha = 1
        adjustTextViewHeight()
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MInputViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            manager.inputData.photos.append(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
