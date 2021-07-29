//
//  PopularCell.swift
//  MoviesApi
//
//  Created by Mani on 3/20/21.
//

import UIKit
import Kingfisher

class PopularCell: UITableViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRatings: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieDesc: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setup(with movie: Movie) {
        container.layer.cornerRadius = 6
        movieImage.layer.cornerRadius = 6
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: -1, height: 1)
        container.layer.shadowRadius = 1
        if let path = movie.posterPath, let imageBaseUrl = URL(string: Config.URL.basePoster) {
            let posterPath = imageBaseUrl
                .appendingPathComponent("w500")
                .appendingPathComponent(path)
            movieImage.kf.indicatorType = .activity
            movieImage.kf.setImage(
                with: posterPath,
                options: [.transition(.fade(0.2))], completionHandler:  { [weak self] _ in
                    self?.contentView.layoutIfNeeded()
                })
        }
        movieTitle.text    = movie.title
        movieDesc.text = movie.overview
        
        let rating = movie.vote_average ?? 0.0
        movieRatings.text = (rating == 0.0) ? "" : "Rating: \(movie.vote_average ?? 0.0)"
        setupWith(date: movie.releaseDate)
    }
    func setupWith(date: Date?) {
        guard let releaseDate = date else {
            movieReleaseDate.text = nil
            return
        }
        let year = Calendar.current.component(.year, from: releaseDate)
        movieReleaseDate.text = "Release on \(year)"
    }
    override func prepareForReuse() {
//        movieReleaseDate.text = nil
//        movieTitle.text = nil
//        movieDesc.text = nil
//        movieRatings.text = nil
    }
}

