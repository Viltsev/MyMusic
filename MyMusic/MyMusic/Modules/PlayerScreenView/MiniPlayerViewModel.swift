//
//  MiniPlayerViewModel.swift
//  MyMusic
//
//  Created by Данила on 26.09.2023.
//

import Foundation
import SwiftUI
import Combine
import CombineExt

final class MiniPlayerViewModel: ObservableObject {
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        bind()
    }
}

extension MiniPlayerViewModel {
    private func bind() {
        bindSheetButton()
        bindRepeatTrack()
    }
    
    private func bindSheetButton() {
        input.sheetButtonSubject
            .sink { [weak self] in
                switch $0 {
                    case .artistsView:
                        self?.output.sheet = .artistsView
                }
            }
            .store(in: &cancellable)
    }
    
    private func bindRepeatTrack() {
        input.repeatTrackSubject
            .sink { [weak self] in
                self?.output.repeatTrack.toggle()
            }
            .store(in: &cancellable)
    }
}

extension MiniPlayerViewModel {
    struct Input {
        let sheetButtonSubject = PassthroughSubject<Sheet, Never>()
        let repeatTrackSubject = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var sheet: Sheet? = nil
        var repeatTrack: Bool = false
    }
    
    enum Sheet: Identifiable {
        case artistsView

        var id: Int {
            self.hashValue
        }
    }
}
