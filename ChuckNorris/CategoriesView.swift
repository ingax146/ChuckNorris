//
//  CategoriesView.swift
//  ChuckNorris
//
//  Created by Ingemar Axelsson on 2024-10-27.
//

import SwiftUI

struct Categories : Codable {
    var items: [String]
}

extension CategoriesView {
    @Observable
    class ViewModel {
        private(set)var categories : [String] = []
        
        func fetchCategories() async {
            do {
                let url = URL(string: "https://api.chucknorris.io/jokes/categories")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedData = try JSONDecoder().decode([String].self, from: data)
                categories = decodedData
            } catch  {
                print("Error fetching categories \(error.localizedDescription)");
            }
        }
    }
}

struct CategoriesView : View {
    @State var viewModel: ViewModel = .init()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.categories, id: \.self) { category in
                    NavigationLink(category.capitalized) {
                        RandomJokeView(category)
                    }
                }
            }.navigationTitle("Categories")
        }.task {
            await viewModel.fetchCategories()
        }
    }
}

#Preview {
    CategoriesView()
}
