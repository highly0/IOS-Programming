//
//  AboutView.swift
//  Assign3
//
//  Created by Hai Le on 4/11/21.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State private var isClicked : Bool = false
    @State private var isClicked2 : Bool = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        //portrait mode
        if(verticalSizeClass == .regular) {
            GeometryReader { geo in
                    ZStack {
                        Text("Credits")
                            .fontWeight(.bold)
                            .font(.title)
                            .offset(y: -200)
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        
                        Button(action: {
                            openURL(URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstleyVEVO")!)
                        }) {
                            HStack {
                                Image(systemName: "clear")
                                    .font(.title)
                                Text("Do NOT click me")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 10.0))
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(40)
                        }
                        //.frame(width: 30, height: 30, alignment: .center)
                        .offset(x:-100, y: -300)
                        
                        Button(action: {
                            self.isClicked.toggle()
                        }, label : {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60, alignment: .center)
                                .rotationEffect(isClicked ? .degrees(90) : .degrees(0))
                                .animation(.spring())
                        }).offset(y:-150)
                        
                        Text("Game made by Hai Le😁")
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .frame(width: 100, height: 100, alignment: .center)
                            .offset(x: -30, y: isClicked ? geo.size.height / 2 - 400 : geo.size.height / 2 + 100)
                            .animation(.spring())
                        
                        Button(action: {
                            self.isClicked.toggle()
                        }, label : {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .offset(x: 50, y: isClicked ? geo.size.height / 2 - 400 : geo.size.height / 2 + 100)
                                .animation(.spring())
                        })
                        
                        Text("and a lot of caffeine☕️")
                            .foregroundColor(.blue)
                           // .fontWeight(.bold)
                            .frame(width: 100, height: 100, alignment: .center)
                            .offset(x: 30, y: isClicked ? geo.size.height / 2 - 280 : geo.size.height / 2 + 100)
                            .animation(.spring())
                         
                    }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }
        } else {
            GeometryReader { geo in
                    ZStack {
                        Text("Credits")
                            .fontWeight(.bold)
                            .font(.title)
                            .offset(x:-20, y: -120)
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        
                        Button(action: {
                            openURL(URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstleyVEVO")!)
                        }) {
                            HStack {
                                Image(systemName: "clear")
                                    .font(.title)
                                Text("Do NOT click me")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 10.0))
                                   // .font(.title)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(40)
                        }
                        //.frame(width: 30, height: 30, alignment: .center)
                        .offset(x:-320, y: -120)
                        
                        Button(action: {
                            self.isClicked.toggle()
                        }, label : {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60, alignment: .center)
                                .rotationEffect(isClicked ? .degrees(90) : .degrees(0))
                                .animation(.spring())
                        }).offset(x:-20, y: -60)
                        
                        Text("Game made by Hai Le😁")
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .frame(width: 100, height: 100, alignment: .center)
                            .offset(x: -30, y: isClicked ? geo.size.height / 2 - 140 : geo.size.height / 2 + 100)
                            .animation(.spring())
                        
                        Button(action: {
                            self.isClicked.toggle()
                        }, label : {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .offset(x: 50, y: isClicked ? geo.size.height / 2 - 140 : geo.size.height / 2 + 100)
                                .animation(.spring())
                        })
                        
                        Text("and a lot of caffeine☕️")
                            .foregroundColor(.blue)
                           // .fontWeight(.bold)
                            .frame(width: 100, height: 100, alignment: .center)
                            .offset(x: 30, y: isClicked ? geo.size.height / 2 - 70 : geo.size.height / 2 + 100)
                            .animation(.spring())
                         
                    }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }
        }
        

    }
    func animation() {
        self.isClicked.toggle()
    }
}
