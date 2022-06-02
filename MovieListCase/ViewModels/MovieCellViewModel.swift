//
//  MovieCellViewModel.swift
//  MovieListCase
//
//  Created by BaranK Kutlu on 2.06.2022.
//

import Foundation
import UIKit


struct MovieCellViewModel {
    let id: Int
    let poster_path: String
    let original_title: String
    let vote_average: Double
    let release_date: String
    
    var avarageVoteString: String {
        return "\(vote_average) / 10"
    }
    
    func dateYear(_ with: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyy-MM-dd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy"
        guard let date: Date = dateFormatterGet.date(from: with) else {
            return ""
        }
        return dateFormatterPrint.string(from: date)
    }
    
    func voteAvarageColors(_ with: Double) -> UIColor {
        switch with {
        case 0..<7:
            return .red
        case 7..<9:
            return .orange
        case 9...10:
            return .green
        default:
            return .red
        }
    }
    
    func stringWithStar(_ with: Double, size: CGFloat) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        let image = UIImage(systemName: "star.fill")?.withTintColor(voteAvarageColors(with)).withConfiguration(UIImage.SymbolConfiguration.init(font: UIFont.systemFont(ofSize: 12, weight: .semibold)))
        imageAttachment.image = image
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " \(avarageVoteString)"))
        let range = NSRange(location: 0, length: (fullString as NSAttributedString).length)
        fullString.addAttributes([NSAttributedString.Key.foregroundColor : voteAvarageColors(vote_average), NSAttributedString.Key.font : UIFont.systemFont(ofSize: size, weight: .bold)], range: range)
        return fullString
    }
    
    func completeImageString(_ with: String) -> URL? {
        return URL(string:"https://image.tmdb.org/t/p/w500\(poster_path)")
    }
    
    
}
