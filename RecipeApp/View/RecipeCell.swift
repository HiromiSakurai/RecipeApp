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

final class RecipeCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.init(named: "hot_dog")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .init(
            string: "キャベツとにんじんのマヨマスタードサラダ",
            font: .systemFont(ofSize: LayoutConst.titleFontSize),
            lineSpacing: LayoutConst.titleLineSpacing,
            alignment: .left
        )
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.height.equalTo(imageView.snp.width).multipliedBy(1.0)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom).offset(LayoutConst.titleMarginTop)
            maker.right.equalToSuperview().offset(-LayoutConst.titleMarginSide)
            maker.left.equalToSuperview().offset(LayoutConst.titleMarginSide)
        }
    }

    func set(title: String, thumbnailURL: URL, isFavorite: Bool) {
        titleLabel.text = title
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
