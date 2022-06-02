//
//  MovieTitleViewController.swift
//  MovieListCase
//
//  Created by BaranK Kutlu on 2.06.2022.
//

import UIKit

class MovieTitleViewController: UIViewController {
    
    var movieTitle: String = ""
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.frame = view.bounds
        titleLabel.text = movieTitle
    }
    
}
