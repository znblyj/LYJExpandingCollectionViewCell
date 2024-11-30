//
//  PeopleViewController.swift
//  ExpandingCollectionViewCell
//
//  Created by Shawn Gee on 9/28/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    enum Section {
        case main
    }

    private let people: [Person] = [
        Person(name: "Shawn", age: 31, favoriteColor: "Blue", favoriteMovie: "Dinner For Schmucks"),
        Person(name: "Bob", age: 54, favoriteColor: "Red", favoriteMovie: "Saving Private Ryan"),
        Person(name: "Susan", age: 23, favoriteColor: "Teal", favoriteMovie: "The Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion King"),
        Person(name: "Shawn", age: 31, favoriteColor: "Blue", favoriteMovie: "Dinner For Schmucks"),
        Person(name: "Bob", age: 54, favoriteColor: "Red", favoriteMovie: "Saving Private Ryan"),
        Person(name: "Susan", age: 23, favoriteColor: "Teal", favoriteMovie: "The Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion King"),
        Person(name: "Shawn", age: 31, favoriteColor: "Blue", favoriteMovie: "Dinner For Schmucks"),
        Person(name: "Bob", age: 54, favoriteColor: "Red", favoriteMovie: "Saving Private Ryan"),
        Person(name: "Susan", age: 23, favoriteColor: "Teal", favoriteMovie: "The Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion King"),
        Person(name: "Shawn", age: 31, favoriteColor: "Blue", favoriteMovie: "Dinner For Schmucks"),
        Person(name: "Bob", age: 54, favoriteColor: "Red", favoriteMovie: "Saving Private Ryan"),
        Person(name: "Susan", age: 23, favoriteColor: "Teal", favoriteMovie: "The Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion King"),
        Person(name: "Shawn", age: 31, favoriteColor: "Blue", favoriteMovie: "Dinner For Schmucks"),
        Person(name: "Bob", age: 54, favoriteColor: "Red", favoriteMovie: "Saving Private Ryan"),
        Person(name: "Susan", age: 23, favoriteColor: "Teal", favoriteMovie: "The Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion King"),
        Person(name: "Shawn", age: 31, favoriteColor: "Blue", favoriteMovie: "Dinner For Schmucks"),
        Person(name: "Bob", age: 54, favoriteColor: "Red", favoriteMovie: "Saving Private Ryan"),
        Person(name: "Susan", age: 23, favoriteColor: "Teal", favoriteMovie: "The Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion KingThe Lion King"),
    ]

    private var expandedStates: [UUID: Bool] = [:] // 用于存储每个cell的展开状态

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, Person>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpDataSource()
        collectionView.delegate = self
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setUpCollectionView() {
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: String(describing: PersonCell.self))
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Person>(collectionView: collectionView) {
            (collectionView, indexPath, person) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: PersonCell.self),
                for: indexPath) as? PersonCell else {
                    fatalError("Could not cast cell as \(PersonCell.self)")
            }
            cell.person = person
            cell.isExpanded = self.expandedStates[person.id] ?? false // 设置cell的展开状态
            return cell
        }
        collectionView.dataSource = dataSource

        var snapshot = NSDiffableDataSourceSnapshot<Section, Person>()
        snapshot.appendSections([.main])
        snapshot.appendItems(people)
        dataSource?.apply(snapshot)
    }
}

extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let person = dataSource?.itemIdentifier(for: indexPath) else { return }
        // 切换cell的展开状态
        expandedStates[person.id] = !(expandedStates[person.id] ?? false)
        
        // 仅刷新当前点击的 Cell
        if let cell = collectionView.cellForItem(at: indexPath) as? PersonCell {
            cell.isExpanded = expandedStates[person.id] ?? false
        }
        
        dataSource?.refresh()
    }
}

extension UICollectionViewDiffableDataSource {
    func refresh(completion: (() -> Void)? = nil) {
        self.apply(self.snapshot(), animatingDifferences: true, completion: completion)
    }
}
