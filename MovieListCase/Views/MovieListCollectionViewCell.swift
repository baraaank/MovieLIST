//
//  MovieListCollectionViewCell.swift
//  MovieListCase
//
//  Created by BaranK Kutlu on 2.06.2022.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "movieListCollectionViewCellReuseIdentifier"
    var representedIdentifier: Int = 0
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.layer.masksToBounds = false
        
        label.attributedText = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .bold)])
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.01
        label.textAlignment = .left
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.gray])
        label.textAlignment = .left
        
        return label
    }()
    
    private let pointLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let navigateImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.forward", withConfiguration: UIImage.SymbolConfiguration.init(weight: .medium))
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray5.withAlphaComponent(0.6)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayer()
        backgroundColor = .white
        configureContentLayout()
        
    }
    
    func configureLayer() {
        contentView.layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 20.0
        layer.shadowOpacity = 0.2
        layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(yearLabel)
        verticalStackView.addArrangedSubview(pointLabel)
        contentView.addSubview(navigateImageView)
        
    }
    
    func configureContentLayout() {
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -16),
            movieImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.26),
            
            navigateImageView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -38),
            navigateImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            navigateImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            navigateImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.36),
            
            verticalStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 8),
            verticalStackView.trailingAnchor.constraint(equalTo: navigateImageView.leadingAnchor, constant: -8),
            verticalStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            verticalStackView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor),
            nameLabel.heightAnchor.constraint(lessThanOrEqualTo: verticalStackView.heightAnchor, multiplier: 0.6),
            pointLabel.heightAnchor.constraint(equalTo: verticalStackView.heightAnchor, multiplier: 0.2),
            yearLabel.heightAnchor.constraint(equalTo: verticalStackView.heightAnchor, multiplier: 0.2),
            
        ])
    }
    
    func configureImages(with image: UIImage?) {
        movieImageView.image = image
    }
    
    func configureCellDatas(with viewModel: MovieCellViewModel) {
        nameLabel.text = viewModel.original_title
        let yearString = viewModel.dateYear(viewModel.release_date)
        yearLabel.text = yearString
        let starString = viewModel.stringWithStar(viewModel.vote_average, size: 12)
        pointLabel.attributedText = starString
    }
}
