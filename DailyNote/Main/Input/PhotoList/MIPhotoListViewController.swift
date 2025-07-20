// Created for DailyNote in 2025
// Using Swift 6.0
//
//
// Created by HongYan on 2025/7/17.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

protocol MIPhotoListViewControllerDelegate: AnyObject {
    func deleteImage(data: MIPhotoListViewController.Data)
}

extension MIPhotoListViewController {
    enum ImageType {
        case photoLibrary(id: String)
        case camera
    }

    struct Data {
        let type: ImageType
        let image: UIImage
    }
}

class MIPhotoListViewController: UIViewController {
    let topBar = UIView()
    let collectionLayout = UICollectionViewFlowLayout()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    var datas: [Data]
    weak var delegate: MIPhotoListViewControllerDelegate?

    init(datas: [Data]) {
        self.datas = datas
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    private func setup() {
        view.backgroundColor = .white

        topBar.backgroundColor = .systemGray4
        topBar.layer.cornerRadius = 3

        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MIPLImageCell.self, forCellWithReuseIdentifier: MIPLImageCell.cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
    }

    private func layout() {
        view.addSubview(topBar)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            topBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 6),
            topBar.widthAnchor.constraint(equalToConstant: 30)
        ])

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MIPhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MIPLImageCell.cellId, for: indexPath) as? MIPLImageCell else {
            return UICollectionViewCell()
        }
        cell.config(image: datas[indexPath.row].image)
        cell.delegate = self
        return cell
    }
}

// MARK: - MIPLImageCellDelegate
extension MIPhotoListViewController: MIPLImageCellDelegate {
    func deleteImageAction(cell: MIPLImageCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let deletedData = datas.remove(at: indexPath.row)
        delegate?.deleteImage(data: deletedData)
        collectionView.deleteItems(at: [indexPath])
    }
}
