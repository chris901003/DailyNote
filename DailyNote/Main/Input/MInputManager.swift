// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import PhotosUI

struct MainInputData {
    var note: String
    var startDate: Date
    var endDate: Date
    var photos: [UIImage] = [] // Source from camera
    var images: [UIImage] = [] // Source from photo library

    init(note: String = "", startDate: Date = Date.now, endDate: Date = Date.now) {
        self.note = note
        self.startDate = startDate
        self.endDate = endDate
    }

    static func newInput() -> MainInputData {
        let endDate = Date.now

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: endDate)
        let startDate = hour == 0 ? calendar.startOfDay(for: endDate) : calendar.date(byAdding: .hour, value: -1, to: endDate)
        return .init(startDate: startDate ?? Date.now, endDate: endDate)
    }
}

extension MInputManager {
    enum CustomError: LocalizedError {
        case noteEmpty
        case durationNotFound

        var errorDescription: String? {
            switch self {
                case .noteEmpty:
                    return "內容不能為空"
                case .durationNotFound:
                    return "無法取得時間區間"
            }
        }
    }
}

class MInputManager {
    var inputData = MainInputData.newInput() {
        didSet {
            let color: UIColor = inputData.note.isEmpty ? .secondaryLabel : .systemBlue
            DispatchQueue.main.async { [weak self] in
                self?.vc?.sendIcon.image = UIImage(systemName: "paperplane")?.withTintColor(color, renderingMode: .alwaysOriginal)
            }
        }
    }
    var selectedImageIds: [String] = []

    weak var vc: MInputViewController?

    func showPhotoMenu() {
        let takePhotoAction = UIAlertAction(title: "拍照", style: .default) { _ in
            Task { [weak self] in
                guard let self else { return }
                guard await checkCameraPermission() else {
                    let alert = await UIAlertController(title: "相機存取失敗", message: "請到設定調整相機權限", preferredStyle: .alert)
                    let okAction = await UIAlertAction(title: "確定", style: .default)
                    await alert.addAction(okAction)
                    await vc?.delegate?.presentVC(alert)
                    return
                }

                await MainActor.run { [weak self] in
                    guard let self else { return }
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = vc
                    picker.allowsEditing = false
                    vc?.delegate?.presentVC(picker)
                }
            }
        }

        let photoLibraryAction = UIAlertAction(title: "相簿", style: .default) { [weak self] _ in
            var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            config.selectionLimit = 0
            config.filter = .images
            config.preselectedAssetIdentifiers = self?.selectedImageIds ?? []

            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self?.vc?.delegate?.presentVC(picker)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)

        let alertMenu = UIAlertController(title: "照片", message: nil, preferredStyle: .actionSheet)
        alertMenu.addAction(takePhotoAction)
        alertMenu.addAction(photoLibraryAction)
        alertMenu.addAction(cancelAction)
        vc?.delegate?.presentVC(alertMenu)
    }

    func setClockDate() {
        vc?.clockView.setStartAndEndTime(startDate: inputData.startDate, endDate: inputData.endDate)
    }

    func sendAction() throws {
        guard !inputData.note.isEmpty else { throw CustomError.noteEmpty }
        guard let duration = vc?.clockView.getStartAndEndTime() else { throw CustomError.durationNotFound }

        inputData.startDate = duration.startTime
        inputData.endDate = duration.endTime
    }
}

extension MInputManager {
    func checkCameraPermission() async -> Bool {
        await AVCaptureDevice.requestAccess(for: .video)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension MInputManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        selectedImageIds = results.compactMap { $0.assetIdentifier }

        for result in results {
            let provider = result.itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self else { return }
                    if let uiImage = image as? UIImage {
                        inputData.images.append(uiImage)
                    }
                }
            }
        }
    }
}
