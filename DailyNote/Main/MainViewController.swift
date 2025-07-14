// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class MainViewController: UIViewController {
    let mainInputView = MInputView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white
    }

    private func layout() {
        view.addSubview(mainInputView)
        mainInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }
}
