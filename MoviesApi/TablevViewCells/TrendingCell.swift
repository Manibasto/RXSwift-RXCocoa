//
//  TrendingCell.swift
//  MoviesApi
//
//  Created by Mani on 3/20/21.
//

import UIKit

class TrendingCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var navigationController: UINavigationController?
    var movies: [Movie]? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupColletionView()
        // Configure the view for the selected state
    }
    
    func setupColletionView(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth / 2.7, height: 300)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.register(UINib(nibName: Config.CellIdentifier.MovieTable.trendingCollection, bundle: .main), forCellWithReuseIdentifier: Config.CellIdentifier.MovieTable.trendingCollection)
    }
}

extension TrendingCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieItem = movies?[safe: indexPath.row] else {
            return
        }
        if let controller = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MovieDeatilsVC") as? MovieDeatilsVC {
            controller.movie = movieItem
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
extension TrendingCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.CellIdentifier.MovieTable.trendingCollection, for: indexPath) as? TrendingCollectionCell
        if let movieItem = movies?[safe: indexPath.row] {
            cell?.setup(with: movieItem)
        }
        return cell!
    }
}

extension TrendingCell: UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 100, height: 100)
    //    }
}
