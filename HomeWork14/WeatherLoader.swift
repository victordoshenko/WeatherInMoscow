//
//  WeatherLoader.swift
//  HomeWork14
//
//  Created by Victor Doshchenko on 22.02.2020.
//  Copyright © 2020 Victor Doshchenko. All rights reserved.
//

import Alamofire

class WeatherLoader {

    let cityid = 524901 // Москва
    let appid = "1f1754ec8c1869e24c4876b51763c049"

    func loadCurrentWeather(completion: @escaping (_ city: City) -> Void) {        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?lang=ru&units=metric&id=\(cityid)&appid=\(appid)").responseJSON {
            response in
            if let data = response.data,
                let city = try? JSONDecoder().decode(City.self, from: data) {
                completion(city)
            }
        }
    }
    
    func loadCurrentWeatherImage(_ city: City, completion: @escaping (_ image: UIImage) -> Void) {
        Alamofire.request("https://openweathermap.org/img/w/\(city.weather[0].icon).png").response {
            response in
            if let image = UIImage(data: response.data!) {
                completion(image)
            }
        }
    }

    func loadWeatherAll(completion: @escaping (_ list: [List]) -> Void) {
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast?lang=ru&units=metric&id=\(self.cityid)&appid=\(self.appid)").responseJSON {
            response in
            if let data = response.data,
                let forecast = try? JSONDecoder().decode(Forecast.self, from: data) {
                    let list = forecast.list
                    completion(list)
                }
        }
    }
    
    func loadWeatherAllImages(_ list: [List], completion: @escaping (_ images: [String:UIImage]) -> Void) {
        var images: [String:UIImage] = [:]
        for item in list {
            // Оптимизированная загрузка картинок:
            // Если ещё не загружали картинку с таким кодом, то загружаем
            if images[item.weather[0].icon] == nil {
                if let imageUrl = URL(string: "https://openweathermap.org/img/w/\(item.weather[0].icon).png"),
                    let imageData = try? Data(contentsOf: imageUrl),
                    let image = UIImage(data: imageData) {
                        images[item.weather[0].icon] = image
                    }
            }
        }
        completion(images)
    }

}
