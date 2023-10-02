//
//  HomeView.swift
//  GreenSound
//
//  Created by 박의서 on 2023/08/02.
//

import SwiftUI

struct HomeView: View {
    @State private var isSearchingCurrentLocation = true
    @State private var isSearchingText = "현위치 탐색 중"
//    @State private var isShowingCrosswalkView = false
    
    var body: some View {
        ZStack {
            Image("crossBackground") // Background
                .resizable()
                .ignoresSafeArea()
            VStack { // Lottie와 CheckMark
                Spacer()
                    .frame(maxHeight: .infinity)
                if (isSearchingCurrentLocation) {
                    LottieView(jsonName: "loading")
                        .frame(width: 168)
                } else {
                    Image(systemName: "checkmark")
                        .resizable()
                        .foregroundColor(.green)
                        .scaledToFit()
                        .frame(width: 50)
                    Spacer().frame(height: 163)
                }
            }
            VStack { // 건너요 버튼과 텍스트
                Spacer()
                Button {
                        searchCurrentLocation()
                } label: {
                    Image("crossButton")
                }
                .padding([.bottom], 124)
                Text("\(isSearchingText)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding([.bottom], 86)
            }
//            if (isShowingCrosswalkView) {
                CrosswalkView()
//            }
        }
    }
}

extension HomeView {
    private func searchCurrentLocation() {
        isSearchingCurrentLocation.toggle()
        if (isSearchingCurrentLocation) {
//            isShowingCrosswalkView = false
            isSearchingText = "현위치 탐색 중"
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                isShowingCrosswalkView.toggle()
            }
            isSearchingText = "현위치 탐색 완료"
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
