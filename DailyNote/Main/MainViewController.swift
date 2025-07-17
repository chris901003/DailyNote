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
    let mainInputView = MInputView()
    
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
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .onDrag

        mainInputView.delegate = self
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
        
        mainContentView.addSubview(mainInputView)
        mainInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainInputView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            mainInputView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            mainInputView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -12)
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
            self.scrollView.scrollRectToVisible(self.mainInputView.frame, animated: true)
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
        present(vc, animated: true)
    }
}
