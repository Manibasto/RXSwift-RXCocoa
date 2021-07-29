//
//  BaseViewModel.swift
//  MoviesApi
//
//  Created by Mani on 3/19/21.
//

import Foundation
import RxCocoa
import RxSwift

enum LoadOption {
    case fromStart
    case continueLoading
    case paused
}

typealias InProgress = Bool
typealias IsEmptyData = Bool
typealias ErrorMessage = String

/// Base class for view models, which contains common declarations and implemetations.
class BaseViewModel {

    let api = Dependencies.shared.api
    
    let isPageLoading = BehaviorRelay<Bool>(value: false)
    
    let inProgress = PublishSubject<InProgress>()
    var dataRefreshed = PublishSubject<IsEmptyData>()
    let onError = PublishSubject<ErrorMessage>()
    
    var disposeBag = DisposeBag()
    
    func handleError(_ error: Error) {
        isPageLoading.accept(false)
        inProgress.onNext(false)
        
        switch error {
        case ApplicationError.commonError:
            onError.onNext(ApplicationError.commonError.description)
        case ApplicationError.noResultsError:
            onError.onNext(ApplicationError.noResultsError.description)
        case let ApplicationError.apiError(type: apiError):
            onError.onNext(apiError.description)
        default:
            onError.onNext(error.localizedDescription)
        }
    }
}
