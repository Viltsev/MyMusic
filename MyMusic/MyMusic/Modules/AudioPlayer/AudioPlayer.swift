//
//  AudioPlayer.swift
//  MyMusic
//
//  Created by Данила on 27.08.2023.
//

import Foundation
import AVFoundation
import Combine
import CombineExt

final class AudioPlayer: ObservableObject {
    
    let input: Input = Input()
    @Published var output: Output = Output()
    var cancellable = Set<AnyCancellable>()
    
    private var player: AVPlayer
    @Published var currentTimeSliderValue: Double = 0.0
    @Published var isPlaying: Bool = false
    private var currentTime: CMTime?
    private var timeObserverToken: Any?
    private var totalTime: Double?

    init() {
        player = AVPlayer()
        addTimeObserver()
    }
    
    var isTrackEnded: AnyPublisher<Bool, Never> {
        return input.trackEndedSubject.eraseToAnyPublisher()
    }
    
    func getTrackURL(from url: URL) -> AVPlayerItem {
        let playerItem = AVPlayerItem(url: url)
        return playerItem
    }
    
    func restartAudio(newTrack: Bool) {
        self.currentTime = nil
        seekTo(time: 0.0)
        if !newTrack {
            player.play()
        }
    }

    private func addTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            self.currentTimeSliderValue = time.seconds
            if self.currentTimeSliderValue >= self.totalTime! {
                self.input.trackEndedSubject.send(true)
            }
        }
    }

    func playAudio(from playerItem: AVPlayerItem, totalTime: Double) {
        self.isPlaying.toggle()
        self.totalTime = totalTime
        
        player.replaceCurrentItem(with: playerItem)
        

        if let currentTime = currentTime {
            player.seek(to: currentTime)
        }
        
        player.play()

        let durationSeconds = Double(playerItem.duration.value) / Double(NSEC_PER_SEC)
        currentTimeSliderValue = 0.0
        currentTimeSliderValue = min(currentTimeSliderValue, durationSeconds)
        
    }

    func seekTo(time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: cmTime)
    }

    func pauseAudio() {
        player.pause()
        currentTime = player.currentTime()
        self.isPlaying.toggle()
    }
}

extension AudioPlayer {
    struct Input {
        let trackEndedSubject = PassthroughSubject<Bool, Never>()
    }
    
    struct Output {
        var isTrackEnded: Bool = false
    }
}
