//
//  TrendingCollectionCell.swift
//  MoviesApi
//
//  Created by Mani on 3/20/21.
//

import UIKit
import Kingfisher

class TrendingCollectionCell: UICollectionViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var voteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        container.backgroundColor = .lightGray
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
                .appendingPathComponent("w300")
                .appendingPathComponent(path)
            movieImage.contentMode = .scaleAspectFit
            movieImage.kf.indicatorType = .activity
            movieImage.kf.setImage(
                with: posterPath,
                options: [.transition(.fade(0.2))], completionHandler:  { [weak self] _ in
                    self?.contentView.layoutIfNeeded()
                })
        } 
        movieTitle.text    = movie.title
        movieDesc.text = movie.overview
        voteLabel.text = "Rating: \(movie.vote_average ?? 0.0)"
//        releaseDateView.setupWith(date: movie.releaseDate)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
        movieDesc.text = nil
        movieTitle.text = nil
        voteLabel.text = nil
    }
}
