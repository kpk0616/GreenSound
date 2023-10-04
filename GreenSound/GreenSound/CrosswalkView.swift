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
    case readyToNext
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
    
    @State private var hideButton: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    isExitApp.toggle()
                } label: {
                    Image("endButton")
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
                viewController
                    .frame(height: 473)
                Spacer()
                ZStack {
                    VStack {
                        switch pedestrianStatusManager.status {
                        case .finding:
                            LottieView(jsonName: "loading")
                            Image("finding")
                        case .arrived:
                            LottieView(jsonName: "loading")
                            Image("arriveSign")
                        case .haveToDepart:
                            HStack {
                                Spacer()
                                Image("greenSign")
                                    .padding([.top, .bottom], 45)
                                Spacer()
                            }
                        case .redSign:
                            HStack {
                                Spacer()
                                Image("redSign")
                                    .padding([.top], 50)
                                    .padding([.bottom], 45)
                                Spacer()
                            }
                        case .leave:
                            HStack {
                                Spacer()
                                Image("leaveSign")
                                    .padding([.top, .bottom], 45)
                                Spacer()
                            }
                        case .crossing:
                            HStack {
                                Spacer()
                                Image("crossing")
                                    .padding([.top, .bottom], 45)
                                Spacer()
                            }
                        case .readyToNext:
                            HStack {
                                Spacer()
                                Image("nextSign")
                                    .padding([.top, .bottom], 45)
                                Spacer()
                            }
                        default:
                            HStack {
                                Spacer()
                                Image("finding")
                                    .padding([.top], 50)
                                    .padding([.bottom], 45)
                                Spacer()
            }
                        }
                    }
//                    VStack {
//
//                        HStack {
//                            Button {
//                                StatusManager.shared.playSound("05_횡단보도도착")
//                            } label: {
//                                Text("횡단보도도착")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//
//                            Button {
//                                StatusManager.shared.playSound("10_횡단보도이탈")
//                            } label: {
//                                Text("횡단보도이탈")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//
//                            Button {
//                                StatusManager.shared.playSound("04_횡단보도가까이")
//                            } label: {
//                                Text("횡단보도가까이")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//
//                            Button {
//                                StatusManager.shared.playSound("07_초록불다음신호")
//                            } label: {
//                                Text("초록불다음신호")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//
//                            Button {
//                                StatusManager.shared.playSound("09_빨간불")
//                            } label: {
//                                Text("초록불다음신호")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//
//                            Button {
//                                StatusManager.shared.playSound("08_초록불건너자")
//                            } label: {
//                                Text("초록불건너자")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//
//                        }
//                        HStack {
//                            Button {
//                                pedestrianStatusManager.updateStatus(to: .finding)
//                            } label: {
//                                Text("찾기")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//                            .padding()
//
//                            Button {
//                                pedestrianStatusManager.updateStatus(to: .arrived)
//                            } label: {
//                                Text("도착")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }.padding()
//
//                            Button {
//                                pedestrianStatusManager.updateStatus(to: .haveToDepart)
//
//                            } label: {
//                                Text("출발")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//                            .padding()
//
//                            Button {
//                                pedestrianStatusManager.updateStatus(to: .redSign)
//                            } label: {
//                                Text("빨강대기")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//                            .padding()
//                            Button {
//                                hideButton.toggle()
//                            } label: {
//                                Text("감추기")
//                                    .foregroundStyle(hideButton ? .clear : .blue)
//                            }
//                            .padding()
//                        }
//                    }
//                    .background(hideButton ? .clear : .yellow)
                }
                .background(backgroundColor)
            }
        }
        .background(backgroundColor)
        .onChange(of: StatusManager.shared.status, perform: { status in
            // 상태에 따라 배경색 변경
            switch(status) {
            case .finding, .arrived, .readyToNext:
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
