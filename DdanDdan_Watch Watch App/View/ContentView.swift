//
//  ContentView.swift
//  DdanDdan_Watch Watch App
//
//  Created by 이지희 on 10/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isTapped: Bool = false
    @ObservedObject var viewModel = WatchViewModel(goalKcal: 400, currentKcal: 200)
    var petType: PetType = .dog
    
    var centerView: some View {
        Group {
            if isTapped {
                kcalLabel
            } else {
                Image(viewModel.configureUI(petType: petType).0)
            }
        }
    }
    
    var kcalLabel: some View {
        HStack(alignment: .lastTextBaseline) {
            Text("\(viewModel.currentKcal)")
                .font(.neoDunggeunmo48)
                .foregroundStyle(viewModel.isGoalMet ? viewModel.configureUI(petType: petType).1 : .white)
            Text("kcal")
                .font(.neoDunggeunmo16)
                .foregroundStyle(.white)
        }
    }
    
    var body: some View {
        ZStack {
            centerView
            DonutChartView(
                progress: viewModel.calculateProgress(),
                lineColor: viewModel.configureUI(petType: petType).1
            )
        }
        .padding()
        .onTapGesture {
            isTapped.toggle()
        }
    }
}

struct DonutChartView: View {
    var progress: Double
    var lineWidth: CGFloat = 12
    var lineColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)
                .frame(width: 168, height: 168)
            Circle()
                .trim(from: 1 - CGFloat(progress), to: 1)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [lineColor]),
                        center: .center),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .square)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 168, height: 168)
        }
    }
}

#Preview {
    ContentView()
}
