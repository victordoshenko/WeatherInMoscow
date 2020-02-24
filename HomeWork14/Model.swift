//
//  Model.swift
//  HomeWork14
//
//  Created by Victor Doshchenko on 22.02.2020.
//  Copyright © 2020 Victor Doshchenko. All rights reserved.
//

import Foundation

struct City: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
    let dt: Int
    var dtd: Date { return (Date(timeIntervalSince1970: Double(dt))) }
    var dts: String {
        return dtd.toString()
    }
    var info: String {
        return "\(dts)\n\(weather[0].weatherDescription)\nТемпература \(main.temp)℃ \nПо ощущениям \(main.feelsLike)℃ \nДавление \(main.pressure) мм рт.ст.\nВлажность \(main.humidity)% \nВетер \(wind.speed) м/с"
    }
}

struct Main: Codable {
    let temp, feelsLike: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
    }
}

struct Weather: Codable {
    let weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}

struct Wind: Codable {
    let speed: Double
}

struct Forecast: Codable {
    var list: [List] = []
}

struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let dtTxt: String
    var dtd: Date { return (Date(timeIntervalSince1970: Double(dt))) }
    var dts: String {
        return dtd.toStringShort()
    }
    var info: String {
        return "\(dts) \(weather[0].weatherDescription)\n \(main.temp)℃ (\(main.feelsLike)℃) \(main.pressure) мм рт.ст. \(main.humidity)%  \(wind.speed) м/с"
    }

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind
        case dtTxt = "dt_txt"
    }
}

extension Date {
    func toString(format: String = "dd.MM.yyyy HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    func toStringShort(format: String = "dd.MM.yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
