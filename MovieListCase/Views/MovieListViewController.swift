//
//  MovieListViewController.swift
//  MovieListCase
//
//  Created by BaranK Kutlu on 2.06.2022.
//

import UIKit

class MovieListViewController: UIViewController {
    
    var movies: [MovieCellViewModel] = []
    var page: Int = 1
    
    var customButton: CustomButton = {
        let button = CustomButton(frame: .zero, buttonTitle: "Add")
        button.isDashed = true
        button.dashedPattern = [8,8]
        button.dashColor = UIColor.systemGreen.cgColor
        button.cornerRadius = 10
        button.textColor = .systemGreen
        button.withIcon = true
        button.buttonTitleSize = 20
        button.buttonIcon = "plus"
        button.titleWeight = .medium
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: -5)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let movieCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { (section, env) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.40))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 36, leading: 16, bottom: 0, trailing: 16)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.42))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets.top = 24
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.bottom = 36
            return section
        }))
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MovieLIST"
        view.backgroundColor = .white
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        customButton.delegate = self
        
        configureNavigationBar()
        addSubviews()
        configureLayouts()
        fetchDatas(page: page)
        
    }
    
    func addSubviews() {
        view.addSubview(movieCollectionView)
        view.addSubview(buttonView)
        buttonView.addSubview(customButton)
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        if let bar = navigationController?.navigationBar {
            bar.standardAppearance = appearance
            bar.scrollEdgeAppearance = appearance
            bar.layer.masksToBounds = false
            bar.layer.shadowColor = UIColor.lightGray.cgColor
            bar.layer.shadowOpacity = 0.2
            bar.layer.shadowRadius = 5
            bar.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        }
        
    }
    
    
    
    func configureLayouts() {
        movieCollectionView.frame = view.bounds
        let heightConstant = (view.frame.size.width * 0.28)
        NSLayoutConstraint.activate([
            
            movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            movieCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -heightConstant),
            
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.28),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            customButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 16),
            customButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -16),
            customButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 16),
            customButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12)
        ])
    }
    
    func fetchDatas(page: Int) {
        Service.shared.fetchFilms(page: page) { [weak self] result in
            switch result {
            case .failure(let error):
                print("failed to get data \(error)")
            case .success(let model):
                self?.movies.append(contentsOf: model.results.map({
                    .init(id: $0.id,
                          poster_path: $0.poster_path,
                          original_title: $0.original_title,
                          vote_average: $0.vote_average,
                          release_date: $0.release_date)
                }))
                
                DispatchQueue.main.async {
                    self?.movieCollectionView.reloadData()
                }
            }
        }
    }
    
    func image(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        return UIImage()
    }
    
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieListCollectionViewCell
        
        let movieIndex = movies[indexPath.row]
        
        let representedIdentifier = movieIndex.id
        cell.representedIdentifier = representedIdentifier
        
        cell.movieImageView.image = nil
        
        Service.shared.image(movieResult: movieIndex) { [weak self] data, error in
            if let img = self?.image(data: data) {
                DispatchQueue.main.async {
                    if (cell.representedIdentifier == representedIdentifier) {
                        cell.configureImages(with: img)
                    }
                }
            }
        }
        cell.configureCellDatas(with: movieIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastIndex = self.movies.count - 1
        if indexPath.row == lastIndex {
            self.page += 1
            fetchDatas(page: page)
            if page > 4 {
                Service.shared.lowerThanHoundred = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieTitle = movies[indexPath.item].original_title
        let vc = MovieTitleViewController()
        vc.movieTitle = movieTitle
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension MovieListViewController: CustomButtonDelegate {
    func customButtonTapped() {
        print("customButtonTapped")
    }
}


