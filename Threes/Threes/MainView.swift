//
//  ContentView.swift
//  assign3
//
//  Created by Yan Pinglan on 4/17/22.
//

import SwiftUI

func initUserData() -> [ScoreTable] {
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var temp: [ScoreTable] = []
    if let storedData = UserDefaults.standard.object(forKey: "dateArr") as? Data {
        let data = try! myDecoder.decode([ScoreTable].self, from: storedData)
        for x in data {
            
            temp.append(ScoreTable.init(id: temp.count, myScore: x.myScore, time: initDate()))
            
        }
    }
    return temp
}

struct MainView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        if verticalSizeClass == .regular {
            BasicView()
        } else {
            HorizView()
        }
    }
}

struct BasicView: View {
    @ObservedObject var triples: Triples = Triples.init(data: initUserData())
    var body: some View {
        Group {
            VStack {
                Score()
                ZStack{
                    Board()
                    ForEach(self.triples.singleRow) { i in
                        TileView(singleTile: i)
                            .gesture(DragGesture(
                                minimumDistance: 0, coordinateSpace: .local)
                                        .onEnded({ p in
                                if abs(p.startLocation.x-p.location.x) < abs(p.startLocation.y - p.location.y) {
                                    if p.startLocation.y > p.location.y {
                                        withAnimation {
                                            triples.collapse(dir: .up)
                                        }
                                    }
                                    else {
                                        withAnimation {
                                            triples.collapse(dir: .down)
                                        }
                                    }
                                }
                                if abs(p.startLocation.x-p.location.x) > abs(p.startLocation.y - p.location.y) {
                                    if p.startLocation.x > p.location.x {
                                        withAnimation {
                                            triples.collapse(dir: .left)
                                        }
                                    }
                                    else {
                                        withAnimation {
                                            triples.collapse(dir: .right)
                                        }
                                    }
                                }
                                
                            })
                            )
                    }
                }
                Move()
                //NewGame()
            }.environmentObject(self.triples)
        }
    }
}

struct HorizView: View {
    @ObservedObject var triples: Triples = Triples.init(data: initUserData())
    var body: some View {
        HStack {
            VStack {
                Score()
                ZStack{
                    Board()
                    ForEach(self.triples.singleRow) { x in
                        TileView(singleTile: x)
                            .gesture(DragGesture(
                                minimumDistance: 0, coordinateSpace: .local)
                                        .onEnded({ p in
                                if abs(p.startLocation.x-p.location.x) < abs(p.startLocation.y - p.location.y) {
                                    if p.startLocation.y > p.location.y {
                                        withAnimation {
                                            triples.collapse(dir: .up)
                                        }
                                    }
                                    else {
                                        withAnimation {
                                            triples.collapse(dir: .down)
                                        }
                                    }
                                }
                                if abs(p.startLocation.x-p.location.x) > abs(p.startLocation.y - p.location.y) {
                                    if p.startLocation.x > p.location.x {
                                        withAnimation {
                                            triples.collapse(dir: .left)
                                        }
                                    }
                                    else {
                                        withAnimation {
                                            triples.collapse(dir: .right)
                                        }
                                    }
                                }
                                
                            })
                            )
                    }
                }
            }
            .padding()
            VStack {
                Move()
                //NewGame()
            }
        }.environmentObject(self.triples)
    }
}

struct Board: View {
    @EnvironmentObject var triples: Triples
    var body: some View {
        ZStack {
            //background
            Rectangle()
            .frame(width: 280.0, height: 280.0)
            .foregroundColor(.gray)
            .cornerRadius(12.0)
            VStack {
                ForEach(0..<4) { x in
                    HStack {
                        ForEach(0..<4) { y in
                            Rectangle()
                            .frame(width: 60.0, height: 60.0)
                            .foregroundColor(Color.white)
                            .cornerRadius(12.0)
                            .shadow(color: .black, radius: 5.0, x: 5.0, y: 5.0)
                        }
                    }
                }
            }
        }
    }
}

struct TileView: View {
    @EnvironmentObject var triples: Triples
    @State var singleTile:Tile
    
    init(singleTile: Tile) {
        self.singleTile = singleTile
    }
    
    var body: some View {
        ZStack {
            if (singleTile.val == 0) {
                Text("")
                    .frame(width: 60, height: 60)
                    .foregroundColor(.black)
                    .font(Font.system(size: 30.0))
                    //.fontWeight(.heavy)
                    .background(Color.white)
                    .cornerRadius(12.0)
                    .shadow(color: .black, radius: 5.0, x: 5.0, y: 5.0)
            } else if (singleTile.val == 1) {
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
                    .frame(width: 60, height: 60)
                    .foregroundColor(.black)
                    .font(Font.system(size: 30.0))
                    .background(Color.yellow)
                    .cornerRadius(12.0)
            }
        }
        //Board: 280*280, Tile: 60*60, space: 280-(60*4)/5 = 8
        //Up left Tile first vertice coordinate: (8, 8)
        //Tile(col:1, row:1) first vertice coordinate: (76, 76)
        //Offset center rectangle first coordinate: (110, 110)
        //Move from (110, 110) on grid to (8, 8) => (-102, -102)
        //Move from (8, 8) to (76, 76) => (+68, +68)
        .offset(x: CGFloat(-102 + 68 * singleTile.col),
                y: CGFloat(-102 + 68 * singleTile.row))
        .animation(.easeInOut(duration: 1))
    }
}

struct Score: View {
    @EnvironmentObject var triples: Triples
    
    var body: some View {
        Text("Score: \(triples.score)")
            .font(.system(size: 25))
    }
}

struct Move: View {
    @EnvironmentObject var triples: Triples
    
    @State var buttonUp = "Up"
    @State var buttonDown = "Down"
    @State var buttonLeft = "Left"
    @State var buttonRight = "Right"
    
    @State var selection = true
    @State var showAlert = false
    
    let selectedMode:[String] = ["Random", "Determ"]
    
    
    var body: some View {
        VStack {
            Button(buttonUp) {
                withAnimation {
                    self.triples.collapse(dir: .up)
                }
            }
                .frame(width: 100.0, height: 50.0)
                .border(Color.black, width: 2.0)
                .font(.system(size: 25))
                .alert("🥳\nScore:\(triples.score)", isPresented: $triples.isOver) {
                            Button("Close", role: .cancel) {
                                triples.updateScoreView(data: ScoreTable(id: triples.count, myScore: triples.score, time: initDate()))
                                triples.sortScoreView()
                                newF1()
                                //Update
                            }
                    }
            
            HStack {
                
                Button(buttonLeft) {
                    withAnimation {
                        self.triples.collapse(dir: .left)
                    }
                }
                    .frame(width: 100.0, height: 50.0)
                    .border(Color.black, width: 2.0)
                    .font(.system(size: 25))
                    .padding(.horizontal)
                    .alert("🥳\nScore:\(triples.score)", isPresented: $triples.isOver) {
                                Button("Close", role: .cancel) {
                                    triples.updateScoreView(data: ScoreTable(id: triples.count, myScore: triples.score, time: initDate()))
                                    triples.sortScoreView()
                                    newF1()
                                    //Update
                                }
                        }
                
                Button(buttonRight) {
                    withAnimation {
                        self.triples.collapse(dir: .right)
                    }
                }
                    .frame(width: 100.0, height: 50.0)
                    .border(Color.black, width: 2.0)
                    .font(.system(size: 25))
                    .padding(.horizontal)
                    .alert("🥳\nScore:\(triples.score)", isPresented: $triples.isOver) {
                                Button("Close", role: .cancel) {
                                    triples.updateScoreView(data: ScoreTable(id: triples.count, myScore: triples.score, time: initDate()))
                                    triples.sortScoreView()
                                    newF1()
                                    //Update
                                }
                        }
                
            }
            Button(buttonDown) {
                withAnimation {
                    self.triples.collapse(dir: .down)
                }
            }
                .frame(width: 100.0, height: 50.0)
                .border(Color.black, width: 2.0)
                .font(.system(size: 25))
                .alert("🥳\nScore:\(triples.score)", isPresented: $triples.isOver) {
                            Button("Close", role: .cancel) {
                                triples.updateScoreView(data: ScoreTable(id: triples.count, myScore: triples.score, time: initDate()))
                                triples.sortScoreView()
                                newF1()
                                //Update
                            }
                    }
            
            
            VStack {
                Button("New Game", action: newF2)
                    .frame(width: 140.0, height: 50.0)
                    .border(Color.black, width: 2.0)
                    .font(.system(size: 25))
                    .padding()
                    .alert("🥳\nScore:\(triples.score)", isPresented: $triples.isOver) {
                                Button("Close", role: .cancel) {
                                    
                                    //Update
                                    triples.updateScoreView(data: ScoreTable(id: triples.count, myScore: triples.score, time: initDate()))
                                    triples.dataStorage()
                                    triples.sortScoreView()
                                    newF1()
                                }
                        }
                    
                Picker(selection: $selection, label: Text("")) {
                    Text("Random").tag(true)
                    Text("Determ").tag(false)
                }.pickerStyle(SegmentedPickerStyle())
                    
            }
            
        }.padding()
    }
    func newF1() {
        self.triples.newgame(rand: selection)
    }
    
    func newF2() {
        if self.triples.score != 0 {
            triples.isOver = true
        } else {
            self.triples.newgame(rand: selection)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
.previewInterfaceOrientation(.portrait)
    }
}
