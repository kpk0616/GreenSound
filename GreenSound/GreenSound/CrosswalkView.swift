//
//  CrosswalkView.swift
//  GreenSound
//
//  Created by 박의서 on 2023/08/02.
//

import SwiftUI

struct CrosswalkView: View {
    @State private var trafficColor = Color.red
    @State private var isPossibleCross = false
    @State private var timeText = "정지"
    @State private var directionText = "어느 방향"
    @State private var crossWalkTime = -1
    @State private var isCorrectDirection = true
    
    @Binding var isShowingCrosswalkView: Bool
    
    var body: some View {
        
        ZStack {
            ZStack {
                // Camera View
                if !isCorrectDirection { // TODO: toggle
                    Image("warningSign")
                }
            }
            VStack {
                Button {
                    isShowingCrosswalkView.toggle()
                } label: {
                    Image("backToBeginButton")
                        .resizable()
                        .scaledToFit()
                }
                Spacer()
                    .frame(maxHeight: 210)
                ZStack {
                    Rectangle()
                        .foregroundColor(trafficColor)
                    VStack {
                        Text(timeText)
                            .foregroundColor(.white)
                            .font(.system(size: 120, weight: .heavy))
                            .padding([.bottom])
                        Text(directionText)
                            .foregroundColor(.white)
                            .font(.system(size: 40, weight: .heavy))
                    }
                }
            }
        }.ignoresSafeArea()
    }
}

extension CrosswalkView {
    private func judgeIsPossibleCross() { // TODO: 실행
        if (isPossibleCross) {
            trafficColor = .green
            timeText = "\(crossWalkTime)초"
        } else {
            trafficColor = .red
            timeText = "정지"
            crossWalkTime = -1
        }
    }
}

struct CrosswalkView_Previews: PreviewProvider {
    static var previews: some View {
        CrosswalkView(isShowingCrosswalkView: .constant(false))
    }
}
