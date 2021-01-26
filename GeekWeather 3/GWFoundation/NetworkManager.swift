//
//  NetworkManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

public protocol URLSessionProtocol {
    func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
      -> URLSessionDataTaskProtocol
}

public protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {
    public func dataTaskWithUrl(_ url: RequestURL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url.url, completionHandler: completion)
    }
}

public protocol NetworkManagerDelegate: AnyObject {
    func didFinishFetching(_ weatherModel: WeatherModel)
    func networkError(_ error: Error?)
}

final public class NetworkManager {
    
    public var session: URLSessionProtocol?
    
    private weak var delegate: NetworkManagerDelegate?
    
    private var mockData: Data?
    
    public init() {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        config.timeoutIntervalForResource = 5
        config.timeoutIntervalForRequest = 5
        
        session = URLSession(configuration: config)
    }
    
    public init(_ delegate: NetworkManagerDelegate,
                _ session: URLSessionProtocol? = URLSession.shared) {
        self.session = session
        self.delegate = delegate
    }
    
    public init(_ delegate: NetworkManagerDelegate,
                _ data: Data) {
        self.delegate = delegate
        self.mockData = data
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
            print("#### Parsing Mocked Data ####")
            self?.prepareData(data)
        }
        
    }
    
    public init(_ delegate: NetworkManagerDelegate,
                _ error: Error) {
        self.delegate = delegate
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.delegate?.networkError(error)
        }
        
    }
    
    public func fetch(_ url: RequestURL) {
        let task = session?.dataTaskWithUrl(url) { [weak self] (data, _, error) in
            
            print("#### Making Network Call ####")
            if let error = error {
                self?.delegate?.networkError(error)
                return
            }
            
            if let data = data {
                print("#### Parsing Network Data ####")
                self?.prepareData(data)
            }
        }
        task?.resume()
    }
    
    public func fetch(_ url: RequestURL,_ completion: @escaping (WeatherModel?, Error?) -> Void) {
        
        if let data = self.mockData {
            let decoder = JSONDecoder()
            print("#### Parsing Mock Data ####")
            do {
                let response = try decoder.decode(WeatherModel.self, from: data)
                let model = self.formatData(response: response)
                completion(model, nil)
            } catch {
                completion(nil, error)
            }
            
            return
        }
        
        session?.dataTaskWithUrl(url, completion: { (data, response, error) in
            
            print("#### Making a Network Call ####")
            if let error = error {
                completion(nil, error)
                print("#### Network Error: \(error.localizedDescription) ####")
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
                    print("👀Response",json)
                     
                    print("#### Parsing Data Here ####")
                    let response = try decoder.decode(WeatherModel.self, from: data)
                    let model = self.formatData(response: response)
                    completion(model, nil)
                } catch {
                    completion(nil, error)
                    print("#### Network Data Error: \(error.localizedDescription) ####")
                }
            }
            
        }).resume()
    }
    
    public func prepareData(_ data: Data) {
        let decoder = JSONDecoder()
        
        do {
            
         
            let response = try decoder.decode(WeatherModel.self, from: data)
            
            let model = formatData(response: response)
            delegate?.didFinishFetching(model)
            
        } catch {
            delegate?.networkError(error)
        }
    }
    
    public func formatData(response: WeatherModel) -> WeatherModel {
        
        let daily = response.daily
        var hourly = response.hourly
        
        var i = 0
        
        for day in daily {
            var times = [day.sunrise, day.sunset]

            for j in i..<hourly.count {
                
                if times.isEmpty {
                    i = j
                    break
                }
                
                let sunTime = times[0]
                let hour = hourly[j].dt
                
                if sunTime < hour {
                    let d1 = Date(timeIntervalSince1970: sunTime)
                    let d2 = Date(timeIntervalSince1970: hour)
                    
                    let differenceInSeconds = abs(d1.timeIntervalSince(d2))
                    let minutesPassed = differenceInSeconds / 60
                    
                    if minutesPassed < 60 && d1.timeIntervalSince1970 > Date().timeIntervalSince1970 {
                        
                        let icon = (times.count == 2) ? "sunrise" : "sunset"
                        let newHourly = Hourly(dt: sunTime,
                                               temp: 0.0,
                                               feels_like: 0.0,
                                               pressure: 0.0,
                                               humidity: 0.0,
                                               dew_point: 0.0,
                                               clouds: 0.0,
                                               visibility: 0.0,
                                               wind_speed: 0.0,
                                               wind_deg: 0.0,
                                               pop: 0.0,
                                               weather: [Weather(id: 0, main: "", description: "", icon: icon)])
                        
                        hourly.insert(newHourly, at: j)
                    }
                    times.removeFirst()
                }
            }
        }
    
        return WeatherModel(lat: response.lat,
                            lon: response.lon,
                            timezone: response.timezone,
                            timezone_offset: response.timezone_offset,
                            current: response.current,
                            hourly: hourly,
                            daily: daily,
                            alerts: response.alerts)
    }

}
