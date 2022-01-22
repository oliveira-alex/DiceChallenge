//
//  ContentView.swift
//  DiceChallenge
//
//  Created by Alex Oliveira on 05/01/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var results = Results()
    var dices = Dices()
    
    @State private var selectedTab = "Dices"
    @State private var shouldFlick = false
//    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
                .tag("Settings")
            
            DicesView()
                .tabItem {
                    Image(systemName: "dice.fill")
                }
                .tag("Dices")
            
            ResultsView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                }
                .tag("Results")
        }
        .environmentObject(dices)
        .environmentObject(results)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .flickFrameWidth(shouldFlick) // tweak fix bug with rotation
        .onRotate { newOrientation in
//            orientation = newOrientation
            
            shouldFlick = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                shouldFlick = false
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "pageIndicatorTintColor")
        }
    }
}

struct FlickFrameWidthViewModifier: ViewModifier {
    let shouldFlick: Bool

    func body(content: Content) -> some View {
        if shouldFlick {
            content
                .padding()
        } else {
            content
        }
    }
}

extension View {
    func flickFrameWidth(_ shouldFlick: Bool) -> some View {
        self.modifier(FlickFrameWidthViewModifier(shouldFlick: shouldFlick))
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
//            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(results: .example, dices: .threeDices)
//            .preferredColorScheme(.dark)
    }
}
