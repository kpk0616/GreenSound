//
//  CrosswalkView.swift
//  GreenSound
//
//  Created by 박의서 on 2023/08/02.
//

import SwiftUI
import AVKit

enum PedestrianStatus {
    case finding
    case arrived
    case leave
    case crossing
    case haveToDepart
}

class StatusManager: ObservableObject {
    static let shared = StatusManager()
    var player: AVAudioPlayer?
    
    private init() { }
        
    // Example property
    @Published var status: PedestrianStatus = .finding
    
    // Example method
    func updateStatus(to newStatus: PedestrianStatus) {
        status = newStatus
    }
    
    func playSound(_ sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
            print("URL 에러")
            return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("음성안내 재생")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CrosswalkView: View {
    @State private var backgroundColor = Color("mainYellow")
    private var viewController = HostedViewController()
    @ObservedObject private var pedestrianStatusManager: StatusManager = StatusManager.shared
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                } label: {
                    Image("endButton", label: Text("종료하기 버튼"))
                        .resizable()
                        .scaledToFit()
                }
                viewController
                    .frame(height: 473)
                Spacer()
                VStack {
                    LottieView(jsonName: "loading")
                    switch pedestrianStatusManager.status {
                    case .finding:
                        Image("finding")
                    case .arrived:
                        Image("arriveSign")
                    case .haveToDepart:
                        Image("greenSign")
                    default:
                        Image("finding")
                    }
                }
                .background(backgroundColor)
            }
        }
        .background(backgroundColor)
        .onAppear {
            StatusManager.shared.playSound("01_안내시작")
        }
    }
}

struct CrosswalkView_Previews: PreviewProvider {
    static var previews: some View {
        CrosswalkView()
    }
}
