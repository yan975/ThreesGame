//
//  TestNum.swift
//  assign3
//
//  Created by Yan Pinglan on 4/18/22.
//

import SwiftUI

struct TestNum: View {
    
    @EnvironmentObject var triples: Triples
    @State var singleTile:Tile
    
    init(singleTile: Tile) {
        self.singleTile = singleTile
    }
    
    var body: some View {
        
        ZStack {
            if (singleTile.val == 0) {
                Text("nil")
                    .frame(width: 60, height: 60)
                    .foregroundColor(.black)
                    .font(Font.system(size: 30.0))
                    //.fontWeight(.heavy)
                    .background(Color.white)
                    .cornerRadius(12.0)
                    .shadow(color: .black, radius: 5.0, x: 5.0, y: 5.0)
            } else if (singleTile.val == 1) {
                //Rectangle()
                Text(singleTile.val.description)
                .frame(width: 60, height: 60)
                .foregroundColor(.black)
                .font(Font.system(size: 30.0))
                .background(Color.blue)
                .cornerRadius(12.0)
                .shadow(color: .black, radius: 5.0, x: 5.0, y: 5.0)
            } else if (singleTile.val == 2) {
                Text(singleTile.val.description)
                .frame(width: 60, height: 60)
                .foregroundColor(.black)
                .font(Font.system(size: 30.0))
                .background(Color.red)
                .cornerRadius(12.0)
                .shadow(color: .black, radius: 5.0, x: 5.0, y: 5.0)
            } else {
                Text(singleTile.val.description)
                    //.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.black)
                    .font(Font.system(size: 30.0))
                    .background(Color.yellow)
                    .cornerRadius(12.0)
            }
        }
        .offset(x: CGFloat(-102 + 68 * singleTile.col),
                y: CGFloat(-102 + 68 * singleTile.row))
    
    }
}


struct TestNum_Previews: PreviewProvider {
    @ObservedObject static var triples: Triples = Triples()
    @State static var testRow =
                        [Tile(val: 3, id: 1, row: 0, col: 0),
                          Tile(val: 1, id: 2, row: 1, col: 1),
                          Tile(val: 6, id: 3, row: 2, col: 2),
                          Tile(val: 2, id: 4, row: 3, col: 3)]
    static var previews: some View {
        
        ZStack {
            Board()
            ForEach(testRow) { x in
                    TestNum(singleTile: x)
            }
        }
    }
}
