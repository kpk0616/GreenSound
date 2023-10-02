//
//  CrosswalkView.swift
//  GreenSound
//
//  Created by 박의서 on 2023/08/02.
//

import SwiftUI

struct CrosswalkView: View {
    @State private var backgroundColor = Color("mainYellow")
    private var viewController = HostedViewController()
    
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
                    Image("finding")
                }
                .background(backgroundColor)
            }
        }
        .background(backgroundColor)
    }
}

struct CrosswalkView_Previews: PreviewProvider {
    static var previews: some View {
        CrosswalkView()
    }
}
