/// Contains information that identify city
struct City {
    let name: String
    let latitude: String
    let longitude: String
}

/// Contain data about weather in particular city
struct CityWeather {
    struct Forecast {
        let weekday: String
        let temp: [String] // 0 - day, 1 - night
    }
    let name: String
    let temp: String
    let image: String
    let windSpeed: String
    let windDir: String
    let forecasts: [Forecast]
}
