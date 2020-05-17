//
//  FavoriteListViewController.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/16.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import UIKit
import SnapKit
import RecipeAppKit
import RxSwift
import RxDataSources

final class FavoriteListViewController: UIViewController {
    private let viewModel: FavoriteListViewModel
    private let disposeBag = DisposeBag()

    private let favoriteCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let favoriteListCollectionView: UICollectionView = {
        let inset = FavoriteListFlowLayout.LayoutConst.contentInset
        let sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: RecipeListFlowLayout(sectionInset: sectionInset))
        cv.backgroundColor = .white
        cv.register(RecipeCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfFavoriteCellViewData>(
        configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FavoriteCell else {
                return UICollectionViewCell()
            }

            cell.set(title: item.title,
                     thumbnailURL: item.thumbnailURL,
                     isFavorite: false,
                     favoriteButtonHandler: nil)
            return cell
    })

    init(viewModel: FavoriteListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        setUpBindings()
    }

    private func setUpBindings() {
        viewModel.getFavoriteCellViewData()
            .drive(favoriteListCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.getFavoriteCount()
            .drive(onNext: { [weak self] count in
                self?.favoriteCountLabel.text = "お気に入り件数: \(count)"
            })
            .disposed(by: disposeBag)
    }

    private func setUpViews() {
        view.backgroundColor = .white
        navigationItem.title = "お気に入り一覧"

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Initializable

extension FavoriteListViewController: Initializable {
    static func initialize(viewModel: FavoriteListViewModel) -> FavoriteListViewController {
        .init(viewModel: viewModel)
    }
}
