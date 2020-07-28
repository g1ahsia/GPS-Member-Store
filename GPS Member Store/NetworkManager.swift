//
//  NetworkManager.swift
//  GPS
//
//  Created by Allen Hsiao on 2020/7/6.
//  Copyright © 2020 Allen Hsiao. All rights reserved.
//

import Foundation

var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJncHNAZG9tYWluLmNvbS50dyIsImp0aSI6IjM4OTQyNTg4LWJmZTYtNDU4Ni1iZDcxLWU0NmJiMjZhMWUzNyIsInVpZCI6Ijg2NDAwIiwibmJmIjoxNTkzODA2NTM5LCJleHAiOjE1OTg5OTA1MzksImlhdCI6MTU5MzgwNjUzOSwiaXNzIjoiR3BzQXBpU2VydmljZSJ9._BO9rxX6g6Xm9r0LVRaV_Q1ypyxbmPhNDxryrpwBJfQ"

class NetworkManager {
    
    class func login(account : String, password: String, completionHandler: @escaping ([String : Any]) -> Void) {
        let url = URL(string: DOMAIN_URL_STRING + "v0.1/consumer/login")!
        var request = URLRequest(url: url)
        var result = [String : Any]()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "account": account,
            "password": password
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }


        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error logging in: \(error)")
                return
            }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
          return
        }

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//            if let result = json["result"] as? [String : Any] {
            result = json
            print (json)
//            }
        }
        completionHandler(result)
      })
      task.resume()
    }

    
    class func fetchStore(id : Int, completionHandler: @escaping (Store) -> Void) {
        let url = URL(string: DOMAIN_URL_STRING + "v0.1/store/\(id)")!
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            var store = Store.init(id: 0, code: "", name: "", latitude: 0, longitude: 0)
            if let error = error {
                print("Error with fetching store: \(error)")
                return
            }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
          return
        }

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let result = json["result"] as? [String : Any] {
                if let fetchedStore = Store(json: result) {
                    store = fetchedStore
                    print(store)
                }
            }
        }
        completionHandler(store)
      })
      task.resume()
    }

    
    class func fetchMerchandises(completionHandler: @escaping ([Merchandise]) -> Void) {
        let url = URL(string: DOMAIN_URL_STRING + "v0.1/merchandise/list")!
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            var merchandises: [Merchandise] = []
            if let error = error {
                print("Error with fetching merchandises: \(error)")
                return
            }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
          return
        }

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let results = json["results"] as? [Any] {
                for case let result in results {
                    if let merchandise = Merchandise(json: result as! [String : Any]) {
                        print(merchandise)
                        merchandises.append(merchandise)
                    }
                }
            }
        }
        completionHandler(merchandises)
      })
      task.resume()
    }
    
    class func fetchProducts(completionHandler: @escaping ([Product]) -> Void) {
        let url = URL(string: DOMAIN_URL_STRING + "v0.1/product/list")!
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            var products: [Product] = []
            if let error = error {
                print("Error with fetching merchandises: \(error)")
                return
            }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
          return
        }

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let results = json["results"] as? [Any] {
                for case let result in results {
                    if let product = Product(json: result as! [String : Any]) {
                        print(product)
                        products.append(product)
                    }
                }
            }
        }
        completionHandler(products)
      })
      task.resume()
    }


    class func fetchCoupons(completionHandler: @escaping ([Coupon]) -> Void) {
        let url = URL(string: DOMAIN_URL_STRING + "v0.1/coupon/consumer/list")!
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            var coupons: [Coupon] = []
            if let error = error {
                print("Error with fetching merchandises: \(error)")
                return
            }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
          return
        }

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let results = json["results"] as? [Any] {
                for case let result in results {
                    if let coupon = Coupon(json: result as! [String : Any]) {
                        print(coupon)
                        coupons.append(coupon)
                    }
                }
            }
        }
        completionHandler(coupons)
      })
      task.resume()
    }


    class func fetchCategories(completionHandler: @escaping ([Category]) -> Void) {
        let url = URL(string: DOMAIN_URL_STRING + "category/list")!
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            var categories: [Category] = []
            if let error = error {
                print("Error with fetching categories: \(error)")
                return
            }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
          return
        }

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let results = json["results"] as? [Any] {
                print(categories)
                for case let result in results {
                    if let category = Category(json: result as! [String : Any]) {
                        print(category)
                        categories.append(category)

                    }
                }
            }
        }
        completionHandler(categories)
      })
      task.resume()
    }

    
    class func fetchAreas(completionHandler: @escaping ([
        Area]) -> Void) {
        let url = URL(string: DOMAIN_URL_STRING + "v0.1/store/list")!
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            var areas: [Area] = []
            if let error = error {
                print("Error with fetching areas: \(error)")
                return
            }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
          return
        }

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let results = json["results"] as? [Any] {
                for case let result in results {
                    if let area = Area(json: result as! [String : Any]) {
                        print(area)
                        areas.append(area)

                    }
                }
            }
        }
        completionHandler(areas)
      })
      task.resume()
    }
    
    class func fetchElectronicDocs(completionHandler: @escaping ([ElectronicDoc]) -> Void) {
        let url = URL(string: DOMAIN_URL_STRING + "v0.1/electronic-doc/list")!
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            var electronicDocs: [ElectronicDoc] = []
            if let error = error {
                print("Error with fetching merchandises: \(error)")
                return
            }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
          return
        }

        if let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let results = json["results"] as? [Any] {
                for case let result in results {
                    if let electronicDoc = ElectronicDoc(json: result as! [String : Any]) {
                        print(electronicDoc)
                        electronicDocs.append(electronicDoc)
                    }
                }
            }
        }
        completionHandler(electronicDocs)
      })
      task.resume()
    }

}

