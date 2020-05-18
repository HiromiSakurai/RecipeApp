//
//  RecipeListViewController.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/13.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class RecipeListViewController: UIViewController {
    private let viewModel: RecipeListViewModel
    private let disposeBag = DisposeBag()

    private let recipeListCollectionView: UICollectionView = {
        let inset = RecipeListFlowLayout.LayoutConst.contentInset
        let sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: 0, right: inset)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: RecipeListFlowLayout(sectionInset: sectionInset))
        cv.backgroundColor = .white
        cv.register(RecipeCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfRecipeCellViewData>(
        configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RecipeCell else {
                return UICollectionViewCell()
            }

            let favoriteButtonHandler = { [weak self] in
                guard let self  = self else { return }
                if !item.isFavorite {
                    self.showSimpleAlert(with: "\(item.title) をお気に入りに追加！")
                }
                self.viewModel.toggleFavorite(at: indexPath)
            }

            cell.set(title: item.title,
                     thumbnailURL: item.thumbnailURL,
                     isFavorite: item.isFavorite,
                     favoriteButtonHandler: favoriteButtonHandler)
            return cell
    })

    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        setUpBindings()
    }

    private func setUpViews() {
        navigationItem.title = "料理一覧"

        view.addSubview(recipeListCollectionView)
        recipeListCollectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    private func setUpBindings() {
        viewModel.recipeCellViewDataStream()
            .drive(recipeListCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - AlertShowable

extension RecipeListViewController: AlertShowable {}
