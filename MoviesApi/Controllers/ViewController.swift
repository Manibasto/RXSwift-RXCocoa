//
//  ViewController.swift
//  MoviesApi
//
//  Created by Mani on 3/19/21.
//

import UIKit
import RxCocoa
import RxSwift
import MarkerKit

class ViewController: UIViewController {
    
    @IBOutlet weak var moviesTable: UITableView!
    private let model = DiscoverVM()
    var activityIndicatorView = UIActivityIndicatorView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        bind()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .black
        activityIndicatorView.mrk.centerX(to: view)
        activityIndicatorView.mrk.centerY(to: view, relation: .equal, constant: -100)
    }
    
    func bind() {
        model.inProgress
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
        model.dataRefreshed
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                print(self.model.movies)
                self.setupTable()
            }).disposed(by: disposeBag)
        
        
        model.onError
            .subscribe(onNext: { [weak self] message in DispatchQueue.main.async {
                self?.showError(message: message)
            }
            })
            .disposed(by: disposeBag)
    }
    
    final func showError(message: String) {
        showAlertController(self, title: "Error", message: message, style: .one("Ok"), handler: nil)
    }
    
    func setupTable(){
        moviesTable.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
        moviesTable.register(UINib(nibName: Config.CellIdentifier.MovieTable.trendingMovies, bundle: .main), forCellReuseIdentifier: Config.CellIdentifier.MovieTable.trendingMovies)
        moviesTable.register(UINib(nibName: Config.CellIdentifier.MovieTable.popularMovies, bundle: .main), forCellReuseIdentifier: Config.CellIdentifier.MovieTable.popularMovies)
        moviesTable.delegate = self
        moviesTable.dataSource = self
        moviesTable.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let movielist = Array(model.movies[10...])
            guard let movieItem = movielist[safe: indexPath.row] else {
                return
            }
            tableView.deselectRow(at: indexPath, animated: true)
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MovieDeatilsVC") as? MovieDeatilsVC {
                controller.movie = movieItem
                controller.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        default:
            return 40
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let sectionText = UILabel()
        sectionText.frame = CGRect.init(x: 20, y: 0, width: sectionHeader.frame.width, height: sectionHeader.frame.height)
        if section == 0 {
            sectionText.text = Config.header.headerText.trendingMovies
        }else{
            sectionText.text = Config.header.headerText.popularMovies
        }
        sectionText.font = .systemFont(ofSize: 20, weight: .bold) // my custom font
        sectionText.textColor = .black
        sectionText.textAlignment = .left
        sectionHeader.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        sectionHeader.addSubview(sectionText)
        return sectionHeader
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return Array(model.movies[10...]).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Config.CellIdentifier.MovieTable.trendingMovies, for: indexPath) as? TrendingCell
            cell?.movies = Array(model.movies[0...10])
            cell?.collectionView.reloadData()
            cell?.navigationController = self.navigationController
            return cell ?? UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Config.CellIdentifier.MovieTable.popularMovies, for: indexPath) as? PopularCell
                let movieList = Array(model.movies[10...])
            if let movie = movieList[safe:indexPath.row] {
                cell?.setup(with: movie)
            }
            return cell ?? UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        }else{
            return 200
        }
    }
    
    // MARK: - UIScrollViewDelegate
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !model.isPageLoading.value && !model.endOfData.value else { return }
        
        if isCanLoadNextData(for: scrollView) {
            loadNextData()
        }
    }
    
    private func loadNextData() {
        model.getPopularMovies(with: .continueLoading)
    }
    
    final func isCanLoadNextData(for scrollView: UIScrollView) -> Bool {
        let currentOffset = scrollView.contentOffset.y
        
        if scrollView.contentSize.height < scrollView.frame.size.height {
            return false
        }
        
        let maiximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maiximumOffset - currentOffset
        
        if deltaOffset <= 350 {
            return true
        }
        
        return false
    }
    
    
}
