// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/28.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import PhotosUI

class BasePhotoPickerManager {
    private var photos: [UIImage] = []
    private var selectedImageIds: [String] = []
    private var images: [UIImage] = []
    weak var delegate: PresentableVC?

    func config(photos: [UIImage]) {
        self.photos = photos
    }

    func showPhotoLibrary() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 0
        config.filter = .images
        config.preselectedAssetIdentifiers = selectedImageIds

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        delegate?.presentVC(picker)
    }

    func showPhotoList() {
        let photoListViewController = BPPPhotoListViewController(datas: getDatas())
        photoListViewController.delegate = self
        if let sheet = photoListViewController.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    UIScreen.main.bounds.height / 2
                })
            ]
        }
        delegate?.presentVC(photoListViewController)
    }

    func getImages() -> [UIImage] {
        images + photos
    }

    private func getDatas() -> [BPPPhotoListViewController.Data] {
        zip(images, selectedImageIds).map { image, id in
            BPPPhotoListViewController.Data(type: .photoLibrary(id: id), image: image)
        } + photos.map { BPPPhotoListViewController.Data(type: .camera, image: $0) }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension BasePhotoPickerManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let newSelectedImageIds = results.compactMap { $0.assetIdentifier }
        let diff = Set(selectedImageIds).subtracting(Set(newSelectedImageIds))
        diff.forEach { id in
            guard let index = selectedImageIds.firstIndex(of: id) else { return }
            images.remove(at: index)
            selectedImageIds.remove(at: index)
        }

        for result in results {
            let provider = result.itemProvider
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    guard let self else { return }
                    if let uiImage = image as? UIImage {
                        images.append(uiImage)
                        selectedImageIds.append(result.assetIdentifier ?? "")
                    }
                }
            }
        }
    }
}

// MARK: - BPPPhotoListViewControllerDelegate
extension BasePhotoPickerManager: BPPPhotoListViewControllerDelegate {
    func deleteImage(data: BPPPhotoListViewController.Data) {
        switch data.type {
            case .camera:
                guard let idx = photos.firstIndex(of: data.image) else { return }
                photos.remove(at: idx)
            case .photoLibrary(let id):
                guard let idx = selectedImageIds.firstIndex(of: id) else { return }
                selectedImageIds.remove(at: idx)
                images.remove(at: idx)
        }
    }
}
