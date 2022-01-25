//
//  MyTabView.swift
//  Some Dices
//
//  Created by Alex Oliveira on 24/01/2022.
//

import SwiftUI

struct MyTabView: View {
    @EnvironmentObject var dices: Dices
    @EnvironmentObject var results: Results
    @Binding var selectedTab: String
    @Binding var isShowingFullTabView: Bool
    @Binding var pageTabViewIndexDisplayMode: PageTabViewStyle.IndexDisplayMode
    
    var body: some View {
        if isShowingFullTabView {
            VStack {
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
                .tabViewStyle(.page(indexDisplayMode: pageTabViewIndexDisplayMode))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "pageIndicatorTintColor")
                }
            }
        } else {
            VStack {
                TabView(selection: $selectedTab) {
                    if selectedTab == "Settings" {
                        SettingsView()
                            .tabItem {
                                Image(systemName: "gear")
                            }
                            .tag("Settings")
                    }
                    
                    if selectedTab == "Dices" {
                        DicesView()
                            .tabItem {
                                Image(systemName: "dice.fill")
                            }
                            .tag("Dices")
                    }
                    
                    if selectedTab == "Results" {
                        ResultsView()
                            .tabItem {
                                Image(systemName: "list.bullet.rectangle.portrait")
                            }
                            .tag("Results")
                    }
                }
                .environmentObject(dices)
                .environmentObject(results)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "pageIndicatorTintColor")
                }
            }

        }
    }
}

struct MyTabView_Previews: PreviewProvider {
    static var previews: some View {
        MyTabView(selectedTab: .constant("Dices"), isShowingFullTabView: .constant(false), pageTabViewIndexDisplayMode: .constant(.always))
            .environmentObject(Dices.example)
            .environmentObject(Results.example)
    }
}
