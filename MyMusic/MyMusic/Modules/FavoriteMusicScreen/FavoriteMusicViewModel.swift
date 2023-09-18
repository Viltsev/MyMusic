//
//  FavoriteMusicViewModel.swift
//  MyMusic
//
//  Created by Данила on 17.09.2023.
//

import Foundation
import Combine
import CombineExt

final class FavoriteMusicViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension FavoriteMusicViewModel {
    func bind() {
        
    }
}

extension FavoriteMusicViewModel {
    struct Input {
        let isTopTrackLoadSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var isTopTrackLoad: Bool = false
    }
}


/*
final class FavoriteMusicViewModel: ObservableObject {
     let input: Input = Input()
     @Published var output: Output = Output()
     var cancellable = Set<AnyCancellable>()
     
     init() {
         bind()
     }
 }

extension FavoriteMusicViewModel {
     func bind() {
         
     }
 }

extension FavoriteMusicViewModel {
     struct Input {
         
     }
     
     struct Output {
         
     }
 }
 */
