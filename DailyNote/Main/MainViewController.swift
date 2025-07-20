// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MainViewController: UIViewController {
    let scrollView = UIScrollView()
    let mainContentView = UIView()
    let mainInputViewController = MInputViewController()
    let noteTableView = UITableView()

    var lastExtendIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        registerCell()
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
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .onDrag

        mainInputViewController.delegate = self

        noteTableView.separatorStyle = .none
        noteTableView.keyboardDismissMode = .onDrag
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.showsVerticalScrollIndicator = false
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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

        addChild(mainInputViewController)
        view.addSubview(mainInputViewController.view)
        mainInputViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainInputViewController.view.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            mainInputViewController.view.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            mainInputViewController.view.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -12)
        ])
        mainInputViewController.didMove(toParent: self)

        mainContentView.addSubview(noteTableView)
        noteTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteTableView.topAnchor.constraint(equalTo: mainContentView.safeAreaLayoutGuide.topAnchor),
            noteTableView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            noteTableView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            noteTableView.bottomAnchor.constraint(equalTo: mainInputViewController.view.topAnchor, constant: -12)
        ])
    }
}

// MARK: - Notification Callback
extension MainViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height - 60
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = keyboardHeight
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            self.scrollView.scrollRectToVisible(self.mainInputViewController.view.frame, animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}

// MARK: - PresentableVC
extension MainViewController: PresentableVC {
    func presentVC(_ vc: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            self?.present(vc, animated: true)
        }
    }
}
