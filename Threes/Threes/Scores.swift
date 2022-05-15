//
//  Scores.swift
//  assign3
//
//  Created by Yan Pinglan on 4/18/22.
//

import SwiftUI

var df = DateFormatter()

func initDate() -> String {
    let date = Date()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let fDate = df.string(from: date)
    return fDate
}

struct Scores: View {
    
    @ObservedObject var triples: Triples = Triples()
    
    @State var myScore: Int = 0
    
    //@State var dateTemp: [ScoreTable]
    
    var body: some View {
        
        VStack{
            Text("Highest Score")
                .font(.largeTitle)
                .fontWeight(.heavy)
            /*
            Button("Update") {
                self.triples.updateScoreView(data: ScoreTable(id: triples.count, myScore: triples.score, time: initDate()))
            }
             */
            List(triples.dateArr, id:\.id){ data in
                    HStack {
                        Text("\(data.id))\t       \(data.myScore)\t     \(data.time)")
                    }
            }
            
        }
    }
}

struct Scores_Previews: PreviewProvider {
    static var previews: some View {
        Scores()
    }
}
