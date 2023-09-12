//
//  AudioPlayer.swift
//  MyMusic
//
//  Created by Данила on 27.08.2023.
//

import Foundation
import AVFoundation

class AudioPlayer: ObservableObject {
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
                self.pauseAudio()
            }
        }
    }

    func playAudio(from playerItem: AVPlayerItem, totalTime: Double) {
        self.isPlaying.toggle()
        self.totalTime = totalTime
        
        player.replaceCurrentItem(with: playerItem)
        

        if let currentTime = currentTime {
            player.seek(to: currentTime)
            //self.currentTime = nil
        }
        
        if self.currentTimeSliderValue >= self.totalTime! {
            restartAudio(newTrack: false)
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
