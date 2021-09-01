import Alamofire
import Kingfisher
import SwiftyJSON

class HomeViewModel {
    /// List of initial cities. Coordinates obtained from from http://api.sputnik.ru/maps/geocoder/
    private let initialCities = [
        City(name: "Москва", latitude: "55.750683", longitude: "37.617496"),
        City(name: "Абакан", latitude: "53.715286", longitude: "91.43887"),
        City(name: "Новосибирск", latitude: "55.02822", longitude: "82.92345"),
        City(name: "Красноярск", latitude: "56.008266", longitude: "92.87062"),
        City(name: "Калининград", latitude: "54.706642", longitude: "20.510517"),
        City(name: "Дивногорск", latitude: "55.959644", longitude: "92.37542"),
        City(name: "Казань", latitude: "55.782356", longitude: "49.124226"),
        City(name: "Норильск", latitude: "69.34984", longitude: "88.200516"),
        City(name: "Краснодар", latitude: "45.035435", longitude: "38.97571"),
        City(name: "Дзержинск", latitude: "56.238216", longitude: "43.46174"),
    ]
    
    // MARK: - API properties
    private let geocoderBaseURL = "http://search.maps.sputnik.ru/search/addr?"
    private let yandexIconURL = "https://yastatic.net/weather/i/icons/funky/dark/"
    private let yandexBaseURL = "https://api.weather.yandex.ru/v2/forecast?"
    private let yandexParameters: [String: String] = [
        "lang": "ru_RU",
        "limit": "7",
        "hours": "false",
        "extra": "false"
    ]
    private let yandexHeaders: HTTPHeaders = [
        "X-Yandex-API-Key": "1e7b0aa4-6476-4d4d-bd38-7bf11cbc8b94"
    ]
    
    /// Array of loaded weather data for default cities
    var citiesWeather: [CityWeather] = []
    
    // MARK: - Private API
    
    private func loadData(forCity city: City, onSuccess: @escaping (CityWeather) -> Void, onFailure: @escaping () -> Void) {
        var cityParams = yandexParameters
        cityParams["lat"] = city.latitude
        cityParams["lon"] = city.longitude
        AF.request(yandexBaseURL, parameters: cityParams, headers: yandexHeaders).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let forecasts = self.getForecasts(from: json)
                let clippedForecasts = Array(forecasts.dropFirst()) // we don't need current day (i.e. first element)
                guard let name = json["geo_object"]["locality"]["name"].string,
                      let temp = json["fact"]["temp"].int,
                      let image = json["fact"]["icon"].string,
                      let windSpeed = json["fact"]["wind_speed"].float,
                      let windDir = json["fact"]["wind_dir"].string
                else {
                    onFailure()
                    return
                }
                let cityWeather = CityWeather(name: name,
                                              temp: String(temp),
                                              image: image,
                                              windSpeed: String(windSpeed),
                                              windDir: windDir,
                                              forecasts: clippedForecasts)
                onSuccess(cityWeather)
            case .failure:
                onFailure()
            }
        }
    }
    
    /// Extract forecasts data from JSON object
    /// - Parameter json: JSON object to parse
    /// - Returns: array of forecasts for several days
    private func getForecasts(from json: JSON) -> [CityWeather.Forecast] {
        return json["forecasts"].map { (_, subJson) in
            let weekday = getWeekdayName(from: subJson)
            let dayTemp = String(subJson["parts"]["day"]["temp_avg"].int!)
            let nightTemp = String(subJson["parts"]["night"]["temp_avg"].int!)
            return CityWeather.Forecast(weekday: weekday, temp: [dayTemp, nightTemp])
        }
    }
    
    /// Extract weekday name from JSON object
    /// - Parameter json: JSON to parse
    /// - Returns: `String` that represent weekday name
    private func getWeekdayName(from json: JSON) -> String {
        let dateString = json["date"]
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "Ru")
        let date = dateFormatter.date(from: dateString.string!)
        let weekday = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date!) - 1]
        return weekday
    }
    
    // MARK: - Public API
    
    /// Load weather data for initial list of cities
    /// - Parameters:
    ///   - onSuccess: closure to execute in successful case
    ///   - onError: closure to execute in failure case
    func loadWeatherList(onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        for city in initialCities {
            loadData(forCity: city, onSuccess: { [unowned self] cityWeather in
                citiesWeather.append(cityWeather)
                onSuccess()
            }, onFailure: {
                onError()
            })
        }
    }
    
    /// Load weather data for specified city
    /// - Parameters:
    ///   - cityName: name of city for which data will be loaded
    ///   - onSuccess: closure to execute in successful case
    ///   - onError: closure to execute in failure case
    func loadWeather(for cityName: String, onSuccess: @escaping (CityWeather) -> Void, onError: @escaping (String) -> Void) {
        AF.request(geocoderBaseURL, parameters: ["q": cityName, "addr_limit": "1"]).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard let latitude = json["result"]["address"][0]["features"][0]["geometry"]["geometries"][0]["coordinates"][1].double,
                      let longitude = json["result"]["address"][0]["features"][0]["geometry"]["geometries"][0]["coordinates"][0].double
                else {
                    onError(cityName)
                    return
                }
                let city = City(name: cityName, latitude: String(latitude), longitude: String(longitude))
                self.loadData(forCity: city, onSuccess: { cityWeather in
                    onSuccess(cityWeather)
                }, onFailure: {
                    onError(cityName)
                })
            case .failure:
                onError(cityName)
            }

        }
    }
    
    /// Load and set image that represents weather in city
    /// - Parameters:
    ///   - index: city position in initial city list
    ///   - view: `UIImageView` in which the image will be load
    func setWeatherImage(forIndex index: Int, for view: UIImageView) {
        guard let url = URL(string: yandexIconURL + citiesWeather[index].image + ".svg") else { return }
        view.kf.setImage(with: url, options: [.processor(SVGImageProcessor())])
    }
    
    /// Provides convenient access to weather data of initial cities
    subscript(index: Int) -> CityWeather { citiesWeather[index] }
}
