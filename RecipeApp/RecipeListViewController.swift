//
//  RecipeListViewController.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/13.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import UIKit
import SnapKit

final class RecipeListViewController: UIViewController {
    private let recipeListCollectionView: UICollectionView = {
        let inset = RecipeListFlowLayout.LayoutConst.contentInset
        let sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: 0, right: inset)
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
        navigationItem.title = "料理一覧"

        recipeListCollectionView.dataSource = self

        view.addSubview(recipeListCollectionView)
        recipeListCollectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension RecipeListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCell
    }
}
