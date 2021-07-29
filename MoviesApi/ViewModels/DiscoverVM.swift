//
//  DiscoverVM.swift
//  TheMovies
//
//  Created by Mikhail Pchelnikov on 05/08/2018.
//  Copyright © 2018 Michael Pchelnikov. All rights reserved.
//

import RxCocoa
import RxSwift

final class DiscoverVM: BaseViewModel {

    var movies = [Movie]()
    var loadNextData = BehaviorSubject<LoadOption>(value: LoadOption.fromStart)
    let endOfData = BehaviorRelay<Bool>(value: false)

    private var currentPage: Int = 1

    override init() {
        super.init()

        loadNextData
            .subscribe(onNext: { [weak self] option in
                self?.trendingMovies(with: .fromStart)
                self?.getPopularMovies(with: .fromStart)
            }).disposed(by: disposeBag)
    }
    
    func trendingMovies(with option: LoadOption) {
        Observable.just(option)
            .do(onNext: { [weak self] option in self?.inProgress.onNext(true) })
            .flatMapFirst { [weak self] option -> Observable<(LoadOption, MoviesResponse)> in
                guard let `self` = self else { return Observable.empty() }
                switch option {
                case .fromStart:
                    return self.api.trendingMovies(.trendingMovies).map { r in (option, r) }
                case .paused:
                    return Observable.empty()
                case .continueLoading:
                    return Observable.empty()
                }
            }
            .subscribe(onNext: { [weak self] option, response in
                self?.handleMoviesResponse(response, with: option, popular: false)
            }, onError: { [weak self] (error) in
                self?.handleError(error)
            }).disposed(by: disposeBag)

    }

    func getPopularMovies(with option: LoadOption) {
        Observable.just(option)
            .do(onNext: { [weak self] option in self?.inProgress.onNext(true) })
            .flatMapFirst { [weak self] option -> Observable<(LoadOption, MoviesResponse)> in
                guard let `self` = self else { return Observable.empty() }

                switch option {
                case .fromStart:
                    self.currentPage = 1
                    return self.api.popularMovies(.popularMovies(page: self.currentPage)).map { r in (option, r) }
                case .continueLoading:
                    self.isPageLoading.accept(true)
                    self.currentPage += 1
                    return self.api.popularMovies(.popularMovies(page: self.currentPage)).map { r in (option, r) }
                case .paused:
                    return Observable.empty()
                }
            }
            .subscribe(onNext: { [weak self] option, response in
                self?.handleMoviesResponse(response, with: option, popular: true)
            }, onError: { [weak self] (error) in
                self?.handleError(error)
            }).disposed(by: disposeBag)
    }

    private func handleMoviesResponse(_ response: MoviesResponse, with option: LoadOption, popular: Bool) {
        if case let .success(respMovies) = response {
            switch option {
            case .fromStart:
                if popular {
                    movies = Array(respMovies[0...10])
                }else{
                    movies = respMovies
                }
                if respMovies.isEmpty {
                    self.handleError(ApplicationError.noResultsError)
                }
            case .continueLoading:
                movies += respMovies
            case .paused:
                break
            }

            endOfData.accept(respMovies.isEmpty)
            dataRefreshed.onNext(respMovies.isEmpty)
            isPageLoading.accept(false)
            inProgress.onNext(false)
        } else {
            self.handleError(ApplicationError.commonError)
        }
    }

    func movieItem(at indexPath: IndexPath) -> Movie? {
        return movies[safe: indexPath.row]
    }
}
