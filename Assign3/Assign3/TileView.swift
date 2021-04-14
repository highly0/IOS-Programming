//
//  TileView.swift
//  Assign3
//
//  Created by Hai Le on 4/13/21.
//

import SwiftUI

struct TileView: View {
    var tile = Tile(val: 0, id: 0, row: 0, col: 0)
    var width:CGFloat
    var height:CGFloat
    
    init(tile: Tile, isPortrait: Bool) {
        //print("after: \(tile)")
        self.tile = tile
        //print("after: \(self.tile)")
        if isPortrait {
            width = 70
            height = 70
        } else {
            width = 43
            height = 43
        }
    }
    
    func getColor(_ val: Int) -> Color {
        var col:Color
        if val == 0 {
            col = Color.white
        } else if val == 1 {
            col = Color.red
        } else if val == 2 {
            col = Color.blue
        } else {
            col = Color.orange
        }
        return col
    }
    
    var body: some View {
        Text("\(tile.val)")
            .font(.system(size: 15, weight: .heavy, design: .default))
            .padding()
            .frame(width: self.width, height: self.height)
            .background(self.getColor(tile.val))
            .cornerRadius(5).foregroundColor(.white)
            .animation(.easeInOut(duration: 0.4))
    }
}
