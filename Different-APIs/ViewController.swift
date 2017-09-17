//
//  ViewController.swift
//  Different-APIs
//
//  Created by Matthew Harrilal on 9/15/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let network1 = Network()
        print(network1.networking())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


struct airBNB {
    let bathrooms:Double?
    let bedrooms:Double?
    let city:String?
    let beds:Double?
    
    init(bathrooms:Double?,bedrooms:Double?,city:String?,beds:Double?) {
        self.bathrooms = bathrooms
        self.bedrooms = bedrooms
        self.city = city
        self.beds = beds
       
    }
    
}

extension airBNB: Decodable {
    enum firstLayerKeys:String,CodingKey {
        case listing
        
    }
    enum additionalKeys: String, CodingKey {
       case bathrooms
        case bedrooms
        case city
        case beds
       
    }
   
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: firstLayerKeys.self)
        let listing = try container.nestedContainer(keyedBy: additionalKeys.self, forKey: .listing)
        let bathrooms = try listing.decodeIfPresent(Double.self, forKey: .bathrooms) ?? 0.0
        let bedrooms = try listing.decodeIfPresent(Double.self, forKey: .bedrooms) ?? 0.0
        let city = try listing.decodeIfPresent(String.self, forKey: .city) ?? "The city of this listing is not available"
        let beds = try listing.decodeIfPresent(Double.self, forKey: .beds) ?? 0.0
        
        
        self.init(bathrooms: bathrooms, bedrooms: bedrooms, city: city, beds: beds)
    }
}
struct ListingList: Decodable {
    let search_results: [airBNB]
    
}

class Network {
    func networking() {
        enum HTTPsMethods: String {
            case get = "GET"
            
        }
        let session = URLSession.shared
        var getRequest = URLRequest(url: URL(string: "https://api.airbnb.com/v2/search_results?key=915pw2pnf4h1aiguhph5gc5b2")!)
        getRequest.httpMethod = HTTPsMethods.get.rawValue
        session.dataTask(with: getRequest) { (data, response, error) in
            if let data = data {
                let airBNB1 = try? JSONDecoder().decode(ListingList.self, from: data)
               print(airBNB1)
            }
        }.resume()
        
    }
    
}

