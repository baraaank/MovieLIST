//
//  Service.swift
//  MovieListCase
//
//  Created by BaranK Kutlu on 2.06.2022.
//

import Foundation
import Alamofire

final class Service {
    
    static let shared = Service()
    private var images = NSCache<NSString, NSData>()
    private init() {}
    public var lowerThanHoundred = false
    
    struct Constants {
        static let apiKey = "bd7847090fea4f76f5ce0c22bd1a85b8"
        static let baseAPIURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)language=en-US&page=1"
    }
    
    func fetchFilms(page: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        guard !lowerThanHoundred else {
            return
        }
        
        let finalUrl = "https://api.themoviedb.org/3/movie/popular?api_key=bd7847090fea4f76f5ce0c22bd1a85b8&language=en-US&page=\(page)"
        let request = AF.request(finalUrl, method: .get)
        request.responseDecodable(of: Movie.self) { response in
            switch response.result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                print("error \(error)")
                completion(.failure(error))
            }
        }
    }
    
    //caching images
    func fetchImages(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        
        if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
            print("using cached images")
            completion(imageData as Data, nil)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: imageURL) { localURL, response, error in
            guard let localURL = localURL, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let data = try Data(contentsOf: localURL)
                self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
                completion(data, error)
                
            } catch let error {
                completion(nil, error)
            }
            
        }
        task.resume()
    }
    
    func image(movieResult: MovieCellViewModel, completion: @escaping (Data?, Error?) -> (Void)) {
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(movieResult.poster_path)")!
        fetchImages(imageURL: url, completion: completion)
    }
    
}


