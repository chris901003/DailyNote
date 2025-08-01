// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol NoteEditViewControllerDelegate: AnyObject {
    func saveNote(note: NoteData)
}

class NoteEditViewController: UIViewController {
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let scrollView = UIScrollView()
    let mainContentView = UIView()
    let contentView = UIView()
    let titleLabel = UILabel()
    let cancelButton = UIImageView()
    let sendButton = UIImageView()
    let noteTextView = UITextView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    let startDateView = UIDatePicker()
    let toLabel = UILabel()
    let endDateView = UIDatePicker()

    let photoManager = BasePhotoPickerManager()
    let note: NoteData
    weak var delegate: NoteEditViewControllerDelegate?

    init(note: NoteData) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerNotification()
        registerCell()
    }

    private func registerNotification() {
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
        photoManager.delegate = self
        photoManager.config(photos: note.images)

        mainContentView.backgroundColor = .clear
        mainContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFocus)))
        mainContentView.isUserInteractionEnabled = true

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20.0
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFocus)))
        contentView.isUserInteractionEnabled = true

        titleLabel.text = "日記"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)

        cancelButton.image = UIImage(systemName: "xmark.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        cancelButton.contentMode = .scaleAspectFit
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCancelAction)))
        cancelButton.isUserInteractionEnabled = true

        sendButton.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        sendButton.contentMode = .scaleAspectFit
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSendAction)))
        sendButton.isUserInteractionEnabled = true

        noteTextView.text = note.note
        noteTextView.font = .systemFont(ofSize: 16, weight: .semibold)
        noteTextView.layer.borderWidth = 1.5
        noteTextView.layer.borderColor = UIColor.systemGray3.cgColor
        noteTextView.layer.cornerRadius = 10.0

        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self

        startDateView.date = note.startDate
        startDateView.datePickerMode = .time
        startDateView.addTarget(self, action: #selector(checkStartTime), for: .valueChanged)

        toLabel.text = "~"
        toLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        endDateView.date = note.endDate
        endDateView.datePickerMode = .time
        endDateView.addTarget(self, action: #selector(checkEndTime), for: .valueChanged)
    }

    private func layout() {
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(mainContentView)
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            mainContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        mainContentView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 4 / 5),
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 3 / 5)
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        contentView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cancelButton.widthAnchor.constraint(equalToConstant: 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        contentView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            sendButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        contentView.addSubview(toLabel)
        toLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            toLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        contentView.addSubview(startDateView)
        startDateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startDateView.trailingAnchor.constraint(equalTo: toLabel.leadingAnchor, constant: -4),
            startDateView.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor),
            startDateView.widthAnchor.constraint(equalToConstant: 70)
        ])

        contentView.addSubview(endDateView)
        endDateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endDateView.leadingAnchor.constraint(equalTo: toLabel.trailingAnchor, constant: 4),
            endDateView.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor),
            endDateView.widthAnchor.constraint(equalToConstant: 70)
        ])

        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: toLabel.topAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])

        contentView.addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            noteTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            noteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            noteTextView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -12)
        ])
    }

    private func registerCell() {
        collectionView.register(NoteEditPhotoCell.self, forCellWithReuseIdentifier: NoteEditPhotoCell.cellId)
        collectionView.register(NoteEditAddPhotoCell.self, forCellWithReuseIdentifier: NoteEditAddPhotoCell.cellId)
    }

    @objc private func dismissFocus() {
        noteTextView.resignFirstResponder()
    }
}

// MARK: - Action
extension NoteEditViewController {
    @objc private func tapCancelAction() {
        let action = UIAlertController(title: "取消", message: "確定要取消嗎", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let okAction = UIAlertAction(title: "確定", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        action.addAction(cancelAction)
        action.addAction(okAction)
        present(action, animated: true)
    }

    @objc private func tapSendAction() {
        guard !noteTextView.text.isEmpty else {
            let alert = UIAlertController(title: "保存失敗", message: "至少寫一點內容吧XD", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
            return
        }
        delegate?.saveNote(
            note: .init(
                note: noteTextView.text,
                images: photoManager.getImages(),
                startDate: startDateView.date,
                endDate: endDateView.date,
                folderName: note.folderName
            )
        )
        dismiss(animated: true)
    }

    @objc private func checkStartTime() {
        if startDateView.date > endDateView.date {
            endDateView.date = startDateView.date
        }
    }

    @objc private func checkEndTime() {
        if endDateView.date < startDateView.date {
            startDateView.date = endDateView.date
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension NoteEditViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoManager.getNumberOfImages() + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteEditAddPhotoCell.cellId, for: indexPath
            ) as? NoteEditAddPhotoCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NoteEditPhotoCell.cellId, for: indexPath
            ) as? NoteEditPhotoCell else {
                return UICollectionViewCell()
            }
            cell.config(image: photoManager.getImage(idx: indexPath.row - 1))
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - NoteEditAddPhotoCellDelegate, NoteEditPhotoCellDelegate, BasePhotoPickerManagerDelegate
extension NoteEditViewController: NoteEditAddPhotoCellDelegate, NoteEditPhotoCellDelegate, BasePhotoPickerManagerDelegate {
    func tapAddPhotoCell() {
        let alert = UIAlertController(title: "添加照片", message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "照片庫", style: .default) { [weak self] _ in
            self?.photoManager.showPhotoLibrary()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .destructive)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    func tapPhotoCell(cell: NoteEditPhotoCell) {
        let alert = UIAlertController(title: "刪除照片", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { [weak self] _ in
            guard let self else { return }
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            photoManager.deleteImage(idx: indexPath.row - 1)
            collectionView.deleteItems(at: [indexPath])
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    func presentVC(_ vc: UIViewController) {
        present(vc, animated: true)
    }

    func didFinishSelected() {
        collectionView.reloadData()
    }
}

// MARK: - Keyboard Notification
extension NoteEditViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self else { return }
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            let convertedRect = noteTextView.convert(noteTextView.bounds, to: scrollView)
            scrollView.scrollRectToVisible(convertedRect, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            scrollView.contentInset.bottom = 0
            scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}
