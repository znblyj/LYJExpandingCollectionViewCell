//
//  PersonCell.swift
//  ExpandingCollectionViewCell
//
//  Created by Shawn Gee on 9/29/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    var person: Person? { didSet { updateContent() } }
    var isExpanded: Bool = false { didSet { updateAppearance() } }
    
    // MARK: - Private Properties
    
    // Views
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        return nameLabel
    }()
    private let ageLabel = UILabel()
    private let favoriteColorLabel = UILabel()
    
    private let favoriteMovieLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .green
        label.isUserInteractionEnabled = true // 启用用户交互
        return label
    }()
    
    private let disclosureIndicator: UIImageView = {
        let disclosureIndicator = UIImageView()
        disclosureIndicator.image = UIImage(systemName: "chevron.down")
        disclosureIndicator.contentMode = .scaleAspectFit
        disclosureIndicator.preferredSymbolConfiguration = .init(textStyle: .body, scale: .small)
        return disclosureIndicator
    }()
    
    // Stacks
    private lazy var rootStack: UIStackView = {
        let rootStack = UIStackView(arrangedSubviews: [labelStack, disclosureIndicator])
        rootStack.alignment = .top
        rootStack.distribution = .fillProportionally
        return rootStack
    }()
    private lazy var labelStack: UIStackView = {
        let labelStack = UIStackView(arrangedSubviews: [
            nameLabel,
            ageLabel,
            favoriteColorLabel,
            favoriteMovieLabel,
        ])
        labelStack.axis = .vertical
        labelStack.spacing = padding
        return labelStack
    }()
    
    // Constraints
    private var closedConstraint: NSLayoutConstraint?
    private var openConstraint: NSLayoutConstraint?
    
    // Layout
    private let padding: CGFloat = 8
    private let cornerRadius: CGFloat = 8
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        backgroundColor = .systemGray6
        clipsToBounds = true
        layer.cornerRadius = cornerRadius

        contentView.addSubview(rootStack)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加点击手势到 favoriteMovieLabel
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFavoriteMovieTap))
        favoriteMovieLabel.addGestureRecognizer(tapGesture)
        
        setUpConstraints()
        updateAppearance()
    }
    
    @objc private func handleFavoriteMovieTap() {
        guard let person = person else { return }
        print("Tapped favorite movie: \(person.favoriteMovie)")
    }
    
    private func setUpConstraints() {
        disclosureIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            rootStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])
        
        // We need constraints that define the height of the cell when closed and when open
        // to allow for animating between the two states.
        closedConstraint =
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        closedConstraint?.priority = .defaultLow // use low priority so stack stays pinned to top of cell
        
        openConstraint =
            favoriteMovieLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        openConstraint?.priority = .defaultLow
    }

    private func updateContent() {
            guard let person = person else { return }
            nameLabel.text = person.name
            ageLabel.text = "Age: \(person.age)"
            favoriteColorLabel.text = "Favorite color: \(person.favoriteColor)"
            favoriteMovieLabel.text = "Favorite movie: \(person.favoriteMovie)"
        }

    private func updateAppearance() {
        closedConstraint?.isActive = !isExpanded
        openConstraint?.isActive = isExpanded

        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * 0.999 )
            self.disclosureIndicator.transform = self.isExpanded ? upsideDown :.identity
        }
    }
}
