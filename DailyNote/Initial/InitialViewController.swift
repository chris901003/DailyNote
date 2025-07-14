// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

class InitialViewController: UIViewController {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let continueButton = UILabel()

    let titleText = "Daily Note"

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        animateText()
        animateContinueButton()
    }

    private func setup() {
        imageView.image = UIImage(named: "InitialBackground")
        imageView.contentMode = .scaleAspectFill

        titleLabel.text = ""
        titleLabel.font = .systemFont(ofSize: 36, weight: .semibold)
        titleLabel.textAlignment = .center

        continueButton.text = "點擊繼續使用"
        continueButton.font = .systemFont(ofSize: 18, weight: .semibold)
        continueButton.textColor = .white.withAlphaComponent(0.5)
        continueButton.textAlignment = .center

        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapContinueAction)))
        imageView.isUserInteractionEnabled = true
    }

    private func layout() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        imageView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 164),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])

        imageView.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            continueButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -64),
            continueButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }

    private func animateText() {
        var charIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self else { return }
            if charIndex < titleText.count {
                let index = titleText.index(titleText.startIndex, offsetBy: charIndex + 1)
                titleLabel.text = String(titleText[..<index])
                charIndex += 1
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    guard let self else { return }
                    titleLabel.text = ""
                    animateText()
                }
            }
        }
    }

    private func animateContinueButton() {
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            self.continueButton.transform = .init(scaleX: 1.1, y: 1.1)
        }
    }

    @objc private func tapContinueAction() {
        let rootViewController = RootViewController()
        rootViewController.modalPresentationStyle = .fullScreen
        present(rootViewController, animated: true)
    }
}
