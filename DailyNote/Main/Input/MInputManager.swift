// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/16.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit
import PhotosUI

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
            let imageIconColor: UIColor = inputData.isPhotoEmpty() ? .secondaryLabel : .systemBlue
            let sendIconColor: UIColor = inputData.note.isEmpty ? .secondaryLabel : .systemBlue
            DispatchQueue.main.async { [weak self] in
                self?.vc?.imageIcon.image = UIImage(systemName: "photo")?.withTintColor(imageIconColor, renderingMode: .alwaysOriginal)
                self?.vc?.sendIcon.image = UIImage(systemName: "paperplane")?.withTintColor(sendIconColor, renderingMode: .alwaysOriginal)
            }
        }
    }
    var selectedImageIds: [String] = []

    weak var vc: MInputViewController?

    func showPhotoMenu() {
        let takePhotoAction = UIAlertAction(title: "拍照", style: .default) { [weak self] _ in
            self?.presentCamera()
        }

        let photoLibraryAction = UIAlertAction(title: "相簿", style: .default) { [weak self] _ in
            self?.presentPhotoLibrary()
        }
        let showPhotoAction = UIAlertAction(title: "照片列表", style: .default) {[weak self] _ in
            self?.showPhotoList()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)

        let alertMenu = UIAlertController(title: "照片", message: nil, preferredStyle: .actionSheet)
        alertMenu.addAction(takePhotoAction)
        alertMenu.addAction(photoLibraryAction)
        if !inputData.isPhotoEmpty() { alertMenu.addAction(showPhotoAction) }
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

// MARK: - Camera
extension MInputManager {
    private func presentCamera() {
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

    private func checkCameraPermission() async -> Bool {
        await AVCaptureDevice.requestAccess(for: .video)
    }
}

// MARK: - Photo Library
extension MInputManager: PHPickerViewControllerDelegate {
    private func presentPhotoLibrary() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 0
        config.filter = .images
        config.preselectedAssetIdentifiers = selectedImageIds

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        vc?.delegate?.presentVC(picker)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let newSelectedImageIds = results.compactMap { $0.assetIdentifier }
        let diff = Set(selectedImageIds).subtracting(Set(newSelectedImageIds))
        diff.forEach { id in
            let index = selectedImageIds.firstIndex(of: id)!
            inputData.images.remove(at: index)
            selectedImageIds.remove(at: index)
        }
        

        for result in results {
            let provider = result.itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self else { return }
                    if let uiImage = image as? UIImage {
                        inputData.images.append(uiImage)
                        selectedImageIds.append(result.assetIdentifier ?? "")
                    }
                }
            }
        }
    }
}

// MARK: - Photo List
extension MInputManager {
    private func showPhotoList() {
        let datas: [MIPhotoListViewController.Data] = zip(inputData.images, selectedImageIds).map {
            .init(type: .photoLibrary(id: $1), image: $0)
        } + inputData.photos.map {
            .init(type: .camera, image: $0)
        }
        let photoListViewController = MIPhotoListViewController(datas: datas)
        if let sheet = photoListViewController.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    UIScreen.main.bounds.height / 2
                })
            ]
        }
        photoListViewController.delegate = self
        vc?.present(photoListViewController, animated: true)
    }
}

// MARK: - MIPhotoListViewControllerDelegate
extension MInputManager: MIPhotoListViewControllerDelegate {
    func deleteImage(data: MIPhotoListViewController.Data) {
        switch data.type {
            case .camera:
                guard let index = inputData.photos.firstIndex(of: data.image) else { return }
                inputData.photos.remove(at: index)
            case .photoLibrary(let id):
                guard let index = inputData.images.firstIndex(of: data.image) else { return }
                inputData.images.remove(at: index)
                selectedImageIds.removeAll { $0 == id }
        }
    }
}
