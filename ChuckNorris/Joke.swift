//
//  Joke.swift
//  ChuckNorris
//
//  Created by Ingemar Axelsson on 2024-10-27.
//

import Foundation

struct Joke : Codable {
    let categories: [String];
    let created_at: String; //TODO Date conversions
    let icon_url: URL;
    let id: String;
    let updated_at: String; //TODO: Date conversions
    let url: URL;
    let value: String;
}
