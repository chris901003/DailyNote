// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/27.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class CENoteViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let mainContentView = UIView()
    let noteTextView = UITextView()
    let startDateView = UIDatePicker()
    let sepLabel = UILabel()
    let endDateView = UIDatePicker()
    let photoIcon = UIImageView()
    let sendButton = UIImageView()

    var noteTextViewHeightConstraint: NSLayoutConstraint!
    let noteData: NoteData
    let manager = CENoteManager()
    let photoPickerManager = BasePhotoPickerManager()

    init(noteData: NoteData) {
        self.noteData = noteData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dynamicNoteTextViewHeight()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func setup() {
        photoPickerManager.delegate = self
        photoPickerManager.config(photos: noteData.images)

        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBlurViewAction)))
        blurView.isUserInteractionEnabled = true

        mainContentView.backgroundColor = .white
        mainContentView.layer.cornerRadius = 15.0

        noteTextView.text = noteData.note
        noteTextView.font = .systemFont(ofSize: 14, weight: .medium)
        noteTextView.delegate = self

        startDateView.date = noteData.startDate
        startDateView.datePickerMode = .time
        startDateView.addTarget(self, action: #selector(startOrEndDateChange), for: .valueChanged)

        sepLabel.text = "~"
        sepLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        endDateView.date = noteData.endDate
        endDateView.datePickerMode = .time
        endDateView.addTarget(self, action: #selector(startOrEndDateChange), for: .valueChanged)

        photoIcon.image = UIImage(systemName: "photo.circle")
        photoIcon.contentMode = .scaleAspectFit
        photoIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPhotoAction)))
        photoIcon.isUserInteractionEnabled = true

        sendButton.image = UIImage(systemName: "paperplane")
        sendButton.contentMode = .scaleAspectFit
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSendAction)))
        sendButton.isUserInteractionEnabled = true

        startOrEndDateChange()
    }

    private func layout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true

        contentView.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        contentView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainContentView.widthAnchor.constraint(equalToConstant: 4 * UIScreen.main.bounds.width / 5)
        ])

        mainContentView.addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.topAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.trailingAnchor)
        ])
        noteTextViewHeightConstraint = noteTextView.heightAnchor.constraint(equalToConstant: 100)
        noteTextViewHeightConstraint.isActive = true

        mainContentView.addSubview(startDateView)
        startDateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startDateView.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 8),
            startDateView.leadingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.leadingAnchor),
            startDateView.bottomAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.bottomAnchor),
            startDateView.widthAnchor.constraint(equalToConstant: 70)
        ])

        mainContentView.addSubview(sepLabel)
        sepLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sepLabel.centerYAnchor.constraint(equalTo: startDateView.centerYAnchor),
            sepLabel.leadingAnchor.constraint(equalTo: startDateView.trailingAnchor, constant: 4)
        ])

        mainContentView.addSubview(endDateView)
        endDateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endDateView.centerYAnchor.constraint(equalTo: startDateView.centerYAnchor),
            endDateView.leadingAnchor.constraint(equalTo: sepLabel.trailingAnchor, constant: 4),
            endDateView.widthAnchor.constraint(equalToConstant: 70)
        ])

        mainContentView.addSubview(photoIcon)
        photoIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoIcon.leadingAnchor.constraint(equalTo: endDateView.trailingAnchor, constant: 12),
            photoIcon.centerYAnchor.constraint(equalTo: startDateView.centerYAnchor),
            photoIcon.heightAnchor.constraint(equalToConstant: 30),
            photoIcon.widthAnchor.constraint(equalToConstant: 30)
        ])

        mainContentView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.centerYAnchor.constraint(equalTo: startDateView.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: mainContentView.layoutMarginsGuide.trailingAnchor, constant: -8),
            sendButton.widthAnchor.constraint(equalToConstant: 25),
            sendButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    @objc private func tapBlurViewAction() {
        if noteTextView.isFirstResponder {
            noteTextView.resignFirstResponder()
        } else {
            dismiss(animated: true)
        }
    }

    @objc private func tapSendAction() {
        if noteTextView.text.isEmpty {
            let alert = UIAlertController(title: "保存失敗", message: "至少需要輸入一筆內容", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
            return
        }
        let newNoteData = NoteData(
            note: noteTextView.text,
            images: photoPickerManager.getImages(),
            startDate: startDateView.date,
            endDate: endDateView.date
        )
        manager.sendNote(oldNoteData: noteData, noteData: newNoteData)
        dismiss(animated: true)
    }
}

// MARK: - Photo
extension CENoteViewController {
    @objc private func tapPhotoAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "從相簿選擇", style: .default) { [weak self] _ in
            self?.photoPickerManager.showPhotoLibrary()
        }
        let photoList = UIAlertAction(title: "照片列表", style: .default) { [weak self] _ in
            self?.photoPickerManager.showPhotoList()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(photoLibrary)
        alert.addAction(photoList)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

extension CENoteViewController {
    @objc private func startOrEndDateChange() {
        startDateView.maximumDate = endDateView.date
        endDateView.minimumDate = startDateView.date
    }
}

// MARK: - Keyboard Notification
extension CENoteViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = keyboardHeight
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            let newOffset = CGPoint(x: self.scrollView.contentOffset.x, y: self.scrollView.contentOffset.y + keyboardHeight / 2)
            self.scrollView.setContentOffset(newOffset, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}

// MARK: - UITextViewDelegate
extension CENoteViewController: UITextViewDelegate {
    func dynamicNoteTextViewHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            noteTextView.layoutIfNeeded()
            noteTextViewHeightConstraint.constant = min(UIScreen.main.bounds.height / 3, noteTextView.contentSize.height)
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        dynamicNoteTextViewHeight()
    }
}

// MARK: - PresentableVC
extension CENoteViewController: PresentableVC {
    func presentVC(_ vc: UIViewController) {
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
}
