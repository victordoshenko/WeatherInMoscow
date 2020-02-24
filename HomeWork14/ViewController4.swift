//
//  ViewController4.swift
//  HomeWork14
//
//  Created by Victor Doshchenko on 22.02.2020.
//  Copyright © 2020 Victor Doshchenko. All rights reserved.
//

import UIKit
import PromiseKit // PromiseKit использую только ради картинок, чтобы обеспечить синхронность вызовов Alamofire-вских асинхронных запросов
import RealmSwift

class ViewController4: UIViewController {
    let realm = try! Realm()
    // Для Realm храним текст и картинки в сущности WeatherForecast (в элементе с индексом 0 храним текущую погоду)
    var items: Results<WeatherForecast>!

    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    // Для загрузки по сети используем список list и словарь images с уникальными картинками(чтобы оптимизировать скорость загрузки)
    private var list: [List] = []
    private var images: [String:UIImage] = [:]
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = realm.objects(WeatherForecast.self)
        if items.count > 0 {
            self.cityLabel.text = "Москва"
            self.infoLabel.text = items[0].info
            self.weatherImageView.image = UIImage(data: items[0].image!)
            self.listTableView.reloadData()
        }

        let backgroundQueue = DispatchQueue.global(qos: .background)
        
        firstly {
            showLoader()
        }.then(on: backgroundQueue) {
            self.loadCurrentWeatherPromise()
        }.then(on: backgroundQueue) { city in
            self.loadCurrentWeatherImagePromise(city)
        }.then(on: backgroundQueue) {
            self.loadWeatherAllPromise()
        }.then(on: backgroundQueue) { list in
            self.loadWeatherAllImagesPromise(list)
        }.done(on: DispatchQueue.main, flags: nil) {
            _ in

            let curWeather = WeatherForecast()
            curWeather.info = self.infoLabel.text!
            curWeather.image = self.weatherImageView.image?.pngData()
            
            try! self.realm.write {
                self.realm.delete(self.items)
                self.realm.add(curWeather)
                for item in self.list {
                    let oneMore = WeatherForecast()
                    oneMore.info = item.info
                    oneMore.image = self.images[item.weather[0].icon]?.pngData()
                    self.realm.add(oneMore)
                }
            }

            self.activityIndicator.stopAnimating()
            self.listTableView.reloadData()
        }.catch { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    private func showLoader() -> Guarantee<Void> {
        activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        activityIndicator.color = UIColor.black
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        return Guarantee()
    }
    
    private func loadCurrentWeatherPromise() -> Promise<City> {
        return Promise { seal in
            WeatherLoader().loadCurrentWeather {
                city in
                DispatchQueue.main.async {
                    self.cityLabel.text = city.name
                    self.infoLabel.text = city.info
                }
                seal.fulfill(city)
            }
        }
    }
    
    private func loadCurrentWeatherImagePromise(_ city: City) -> Promise<Void> {
        return Promise { seal in
            WeatherLoader().loadCurrentWeatherImage(city) {
                image in
                DispatchQueue.main.async {
                    self.weatherImageView.image = image
                }
                seal.fulfill(Void())
            }
        }
    }

    private func loadWeatherAllPromise() -> Promise<[List]> {
        return Promise { seal in
            WeatherLoader().loadWeatherAll {
                list in
                self.list = list
                seal.fulfill(list)
            }
        }
    }

    private func loadWeatherAllImagesPromise(_ list: [List]) -> Promise<Void> {
        return Promise { seal in
            WeatherLoader().loadWeatherAllImages(list) {
                images in
                self.images = images
                seal.fulfill(Void())
            }
        }
    }

}

extension ViewController4: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count != 0 {
            return items.count - 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3") as! MyTableViewCell
        cell.weatherLabel.text = items[indexPath.row + 1].info
        cell.wImageView.image = UIImage(data: items[indexPath.row + 1].image!)
        return cell
    }
}
