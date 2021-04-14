//
//  ScoreView.swift
//  Assign3
//
//  Created by Hai Le on 4/11/21.
//

import SwiftUI

struct Score: Hashable {
    var score: Int
    var time: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
    
    init(score: Int, time: Date) {
        self.score = score
        self.time = time
    }
}

class ScoreList : ObservableObject {
    @Published var scoreList:[Score] = [Score] ()
    
    init() {
        self.add_score(element: Score(score: 300, time:Date()))
        self.add_score(element:Score(score: 400, time:Date()))
    }
    
    func add_score(element: Score) {
        scoreList.append(element)
        scoreList.sort { $0.score > $1.score }
    }
}

struct ScoreView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var listArr:ScoreList
    
    var body: some View {
        // portrait mode
        if(verticalSizeClass == .regular) {
            HStack {
                
                Text("High Scores")
                    .fontWeight(.bold)
                    .font(.title)
                    .offset(x: 110, y: -300)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                List(0...listArr.scoreList.count - 1, id:\.self) { item in
                    
                    Text("\(item+1)) \(listArr.scoreList[item].score)          \(self.dateToString(time: listArr.scoreList[item].time))")
                        .fontWeight(.bold)
                        .font(.system(size: 11))
                        .foregroundColor(.black) 
                }.offset(x:-80, y: 120)
                .lineSpacing(0)
                .lineLimit(1)
            }
        } else {
            HStack {
                Text("High Scores")
                    .fontWeight(.bold)
                    .font(.title)
                    .offset(x: 110, y: -120)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                
                List(0...listArr.scoreList.count - 1, id:\.self) { item in
                    Text("\(item+1)) \(listArr.scoreList[item].score)          \(self.dateToString(time: listArr.scoreList[item].time))")
                        .fontWeight(.bold)
                        .font(.system(size: 11))
                        .foregroundColor(.black)
                }.offset(x:-100, y: 80)
                .lineSpacing(0)
                .lineLimit(1)
            }
        }

    }
    
    func dateToString(time: Date)->String {
         let timeFormatter = DateFormatter()
         timeFormatter.dateFormat = "HH:mm:ss, dd/MM/YYYY"
         let stringDate = timeFormatter.string(from: time)
         return stringDate
    }
}
/*
struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
 */
