//
//  ContentView.swift
//  cigarettes
//
//  Created by Gianmarco Cremisi on 15/11/23.
//

import Foundation
import SwiftUI
import SwiftData

struct ContentView: View {
    
    @AppStorage("circle.progres") var count: Double = 0
    @Environment(\.modelContext) private var context
    @Query private var history:[CigaretteData]


    @State private var tempoTrascorso: TimeInterval = 0.0
    @State private var isRunning = false
    @State private var timer: Timer?
    
    
    var body: some View {
        
        
        VStack{
            let distance = Date().distance(to: history.last?.date ?? Date())
            Text(String(format: "%.0f", distance))                .foregroundColor(.black).font(.system(size: 50))
            Spacer()
            
            ZStack{
                CircularProgressView(count: $count).frame(width: 400)
                VStack{
                    
                    Text(String(format: "count %.0f" ,count )).font(.system(size: 50))
                    
                   
                }
                
            }
            Spacer()
            Button(action: {
                if(history.isEmpty){
                    additem()
                }
                count += 1
                if self.isRunning {
                    self.stopTimer()
                    self.startTimer()
                } else {
                    self.startTimer()
                }
                context.insert(CigaretteData(date: Date()))
            }, label: {
                Image(systemName: "plus.circle").font(.system(size: 75)).foregroundStyle(.white)
            })
        }
        
        .background(
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.linearGradient(colors: [.black, .white], startPoint: .bottom, endPoint: .top))
        )
        .scaledToFill()
    }
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.tempoTrascorso += 1.0
        }
        isRunning = true
    }
    
    func stopTimer() {
        timer?.invalidate()
        self.tempoTrascorso = 0.0
        timer = nil
        isRunning = false
    }
    func additem(){
        let item = CigaretteData(date: Date())
        context.insert(item)
    }
}

#Preview {
    ContentView()
}
