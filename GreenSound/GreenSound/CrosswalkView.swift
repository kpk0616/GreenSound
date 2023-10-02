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
    case redSign
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
    @State private var isExitApp = false
    private var viewController = HostedViewController()
    @ObservedObject private var pedestrianStatusManager: StatusManager = StatusManager.shared
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    isExitApp.toggle()
                } label: {
                    Image("endButton", label: Text("종료하기 버튼"))
                        .resizable()
                        .scaledToFit()
                }
                .alert(isPresented: $isExitApp) {
                    // 종료하기 버튼 Alert
                    let exitButton = Alert.Button.cancel(Text("종료")) {
                        exit(0)
                    }
                    
                    return Alert(title: Text("앱을 종료할까요?"), message: nil, primaryButton: .default(Text("계속 사용")), secondaryButton: exitButton)
                }
                .accessibilityLabel("종료하기 버튼")
                .accessibilityHint("현재 앱을 종료합니다.")
                viewController
                    .frame(height: 473)
                Spacer()
                VStack {
                    LottieView(jsonName: "loading")
                    switch pedestrianStatusManager.status {
                    case .finding:
                        Image("finding")
                            .accessibilityRemoveTraits(.isImage)
                    case .arrived:
                        Image("arriveSign")
                    case .haveToDepart:
                        Image("greenSign")
                    case .redSign:
                        Image("redSign")
                    default:
                        Image("finding")
                    }
                }
                .background(backgroundColor)
            }
        }
        .background(backgroundColor)
        .onChange(of: StatusManager.shared.status, perform: { status in
            // 상태에 따라 배경색 변경
            switch(status) {
            case .finding, .arrived:
                backgroundColor = Color("mainYellow")
            case .redSign, .leave:
                backgroundColor = Color("mainRed")
            case .crossing, .haveToDepart:
                backgroundColor = Color("mainGreen")
            }
        })
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
