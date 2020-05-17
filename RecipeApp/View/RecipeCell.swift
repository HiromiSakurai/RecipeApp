//
//  RecipeCell.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/16.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Nuke

typealias FavoriteButtonHandler = (() -> Void)
typealias FavoriteCell = RecipeCell

final class RecipeCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    private var favoriteButtonHandler: FavoriteButtonHandler?

    private var isFavorite: Bool = false {
        didSet {
            let buttonImage = isFavorite ?
                    UIImage(named: "favorite_filled") :
                    UIImage(named: "favorite")
            favoriteButton.setImage(buttonImage, for: .normal)
        }
    }

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "favorite"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpViews()
        setUpBindings()
    }

    func set(title: String,
             thumbnailURL: URL,
             isFavorite: Bool,
             favoriteButtonHandler: FavoriteButtonHandler?) {
        titleLabel.attributedText = .init(
            string: "\(title)",
            font: .systemFont(ofSize: LayoutConst.titleFontSize),
            lineSpacing: LayoutConst.titleLineSpacing,
            alignment: .left
        )

        self.isFavorite = isFavorite

        favoriteButton.isHidden = favoriteButtonHandler == nil
        self.favoriteButtonHandler = favoriteButtonHandler

        let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.33))
        Nuke.loadImage(with: thumbnailURL, options: options, into: imageView)
    }

    private func setUpBindings() {
        favoriteButton.rx.tap.asSignal()
            .emit(onNext: { [unowned self] _ in
                self.favoriteButtonHandler?()
            })
            .disposed(by: disposeBag)
    }

    private func setUpViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)

        imageView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.height.equalTo(imageView.snp.width).multipliedBy(1.0)
        }

        favoriteButton.snp.makeConstraints { maker in
            maker.height.width.equalTo(32)
            maker.top.equalToSuperview().offset(8)
            maker.right.equalToSuperview().offset(-8)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom).offset(LayoutConst.titleMarginTop)
            maker.right.equalToSuperview().offset(-LayoutConst.titleMarginSide)
            maker.left.equalToSuperview().offset(LayoutConst.titleMarginSide)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecipeCell {
    enum LayoutConst {
        static let titleMarginTop: CGFloat = 8.0
        static let titleMarginSide: CGFloat = 4.0
        static let titleLineSpacing: CGFloat = 1.0

        static let titleFontSize: CGFloat = 14.0
    }
}
