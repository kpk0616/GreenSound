//
//  LeeoView.swift
//  GreenSound
//
//  Created by hyunho lee on 2023/08/02.
//

import SwiftUI

struct LeeoView: View {
    
    @State var data: String = ""
    @State var data1: String = ""
    @State var data2: Int = 0
    
    var body: some View {
        VStack{
            Text("dataID : \(data)")
            Text("eqmnID : \(data1)")
            Text("neLtsgRmdrCS : \(data2)")
        }
            .onAppear {
                NetworkManager.shared.getRepositories { result in
                    switch result {
                    case .success(let results):
                        data = results.first?.dataID ?? "unexpected"
                        data1 = results.first?.eqmnID ?? "unexpected"
                        data2 = results.first?.neLtsgRmdrCS ?? -1
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                }
            }
    }
}

struct LeeoView_Previews: PreviewProvider {
    static var previews: some View {
        LeeoView()
    }
}

//[{"dataId":"SPAT-CIB1000014500-1690353046-2854549","trsmDy":2,"trsmUtcTime":1.690902000151E12,"trsmYear":"2023","trsmMt":"08","trsmTm":"000000","trsmMs":"151","itstId":"2691","eqmnId":"CIB1000014500","msgCreatMin":306180.0,"msgCreatDs":0.0,"ntBssgRmdrCs":null,"ntBcsgRmdrCs":null,"ntLtsgRmdrCs":1063.0,"ntPdsgRmdrCs":null,"ntStsgRmdrCs":1063.0,"ntUtsgRmdrCs":null,"etBssgRmdrCs":null,"etBcsgRmdrCs":null,"etLtsgRmdrCs":null,"etPdsgRmdrCs":123.0,"etStsgRmdrCs":853.0,"etUtsgRmdrCs":null,"stBssgRmdrCs":null,"stBcsgRmdrCs":null,"stLtsgRmdrCs":883.0,"stPdsgRmdrCs":null,"stStsgRmdrCs":883.0,"stUtsgRmdrCs":null,"wtBssgRmdrCs":null,"wtBcsgRmdrCs":null,"wtLtsgRmdrCs":null,"wtPdsgRmdrCs":173.0,"wtStsgRmdrCs":853.0,"wtUtsgRmdrCs":null,"neBssgRmdrCs":null,"neBcsgRmdrCs":null,"neLtsgRmdrCs":null,"nePdsgRmdrCs":null,"neStsgRmdrCs":null,"neUtsgRmdrCs":null,"seBssgRmdrCs":null,"seBcsgRmdrCs":null,"seLtsgRmdrCs":null,"sePdsgRmdrCs":null,"seStsgRmdrCs":null,"seUtsgRmdrCs":null,"swBssgRmdrCs":null,"swBcsgRmdrCs":null,"swLtsgRmdrCs":null,"swPdsgRmdrCs":null,"swStsgRmdrCs":null,"swUtsgRmdrCs":null,"nwBssgRmdrCs":null,"nwBcsgRmdrCs":null,"nwLtsgRmdrCs":null,"nwPdsgRmdrCs":null,"nwStsgRmdrCs":null,"nwUtsgRmdrCs":null,"rgtrId":"v2x","regDt":"2023-08-01T15:00:00.000+00:00"}]
