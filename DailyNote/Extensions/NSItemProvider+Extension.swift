// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/31.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

extension NSItemProvider {
    func loadUIImage() async -> UIImage? {
        await withCheckedContinuation { continuation in
            self.loadObject(ofClass: UIImage.self) { image, _ in
                continuation.resume(returning: image as? UIImage)
            }
        }
    }
}
