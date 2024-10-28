//
//  ContentView.swift
//  ChuckNorris
//
//  Created by Ingemar Axelsson on 2024-10-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack() {
            AsyncImage(url: URL(string: "https://api.chucknorris.io/img/chucknorris_logo_coloured_small@2x.png")!) { image in
                image.image?.resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)
            }
            List {
                NavigationLink("Random joke") {
                    RandomJokeView(nil);
                }
                NavigationLink("Browse by category") {
                    CategoriesView();
                }
                NavigationLink("Search for jokes") {
                    SearchJokesView();
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
