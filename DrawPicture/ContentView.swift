//
//  ContentView.swift
//  DrawPicture
//
//  Created by 宮本光直 on 2022/01/05.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CustomPaint()) {
                    Text("CustomPaint")
                }
            }
        }
    }
}

struct CustomPaint: View {
    @State private var lines: [PaintLine] = []
    @State private var currentLine: PaintLine?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            if currentLine == nil {
                                currentLine = PaintLine.makeLine(points: [])
                            }
                            guard var line = currentLine else { return }
                            line.points.append(value.location)
                            currentLine = line
                        })
                        .onEnded({ value in
                            guard var line = currentLine else { return }
                            line.points.append(value.location)
                            lines.append(line)
                            currentLine = nil
                        })
                )
            
            // 書き終わったLineの描画
            ForEach(lines) { line in
                Path { path in
                    path.addLines(line.points)
                }.stroke(Color.red, lineWidth: 3)
            }.clipped()
            
            // 今書いているline
            Path { path in
                guard let line = currentLine else { return }
                path.addLines(line.points)
            }.stroke(Color.red, lineWidth: 3)
                .clipped()
        }
        .border(.gray, width: 3)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("手書き絵")
        .navigationBarItems(trailing:
                                Button(action: {
            lines = []
        }, label: {
            Text("clear")
        })
        )
    }
}

struct PaintLine: Identifiable {
    static var idCount: Int = 0
    var id: String
    var points: [CGPoint]
    
    static func makeLine(points: [CGPoint]) -> PaintLine {
        let line = PaintLine(id: "\(PaintLine.idCount)", points: points)
        PaintLine.idCount += 1
        return line
    }
}
