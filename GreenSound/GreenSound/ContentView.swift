//
//  ContentView.swift
//  GreenSound
//
//  Created by 박의서 on 2023/07/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TabView {
                Text("리이오 컨텐츠")
                    .tabItem {
                        Text("리이오")
                }.tag(1)
                Text("웨스트 컨텐츠")
                    .tabItem {
                        Text("웨스트")
                }.tag(2)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
