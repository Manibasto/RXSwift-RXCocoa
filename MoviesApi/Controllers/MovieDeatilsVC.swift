//
//  MovieDeatilsVC.swift
//  MoviesApi
//
//  Created by Mani on 3/20/21.
//

import UIKit
import Kingfisher

class MovieDeatilsVC: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieOverView: UILabel!
    var movie: Movie?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = movie?.posterPath, let imageBaseUrl = URL(string: Config.URL.basePoster) {
            let posterPath = imageBaseUrl
                .appendingPathComponent("w500")
                .appendingPathComponent(path)
            movieImage.kf.indicatorType = .activity
            movieImage.kf.setImage(
                with: posterPath,
                options: [.transition(.fade(0.2))], completionHandler:  { [weak self] _ in
                    self?.view.layoutIfNeeded()
                })
        }
        movieTitle.text    = movie?.title
        movieOverView.text = movie?.overview
        
        let rating = movie?.vote_average ?? 0.0
        movieRating.text = (rating == 0.0) ? "" : "Rating: \(movie?.vote_average ?? 0.0)"
        setupWith(date: movie?.releaseDate)
    }
    func setupWith(date: Date?) {
        guard let releaseDate = date else {
            movieReleaseDate.text = nil
            return
        }
        let year = Calendar.current.component(.year, from: releaseDate)
        movieReleaseDate.text = "Release on \(year)"
    }
}
