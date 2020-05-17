//
//  FavoriteListViewController.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/16.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import UIKit
import SnapKit

final class FavoriteListViewController: UIViewController {
    private let favoriteCountLabel: UILabel = {
        let label = UILabel()
        label.text = "お気に入り件数: 5"
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let favoriteListCollectionView: UICollectionView = {
        let inset = RecipeListFlowLayout.LayoutConst.contentInset
        let sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: RecipeListFlowLayout(sectionInset: sectionInset))
        cv.backgroundColor = .white
        cv.register(RecipeCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }

    private func setUpViews() {
        view.backgroundColor = .white
        navigationItem.title = "お気に入り一覧"

        favoriteListCollectionView.dataSource = self

        view.addSubview(favoriteCountLabel)
        view.addSubview(favoriteListCollectionView)
        favoriteCountLabel.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            maker.left.equalToSuperview().offset(16)
        }
        favoriteListCollectionView.snp.makeConstraints { maker in
            maker.top.equalTo(favoriteCountLabel.snp.bottom).offset(12)
            maker.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FavoriteListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCell
    }
}

