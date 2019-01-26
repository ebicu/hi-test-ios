//
//  UniversityTableViewController.swift
//  Teste Hi
//
//  Created by Joao pedro Costa Miranda on 24/01/19.
//  Copyright © 2019 Joao. All rights reserved.
//

import UIKit

// University definition to decode the JSON
struct UniList: Decodable{
	let results: [Uni]
}

struct	Uni: Decodable {
	let id: Int
	let name: String
	let url: URL
	let city: String
	let state: String
	let type: Funding
	let lat: Float
	let lon: Float
	
	init(id: Int, name: String, city: String, state: String, lat: Float, lon: Float, type: Funding = .Public, url: URL = URL(string: "")!) {
    self.id = id
    self.name = name
    self.url = url
    self.city = city
    self.state = state
    self.type = type
    self.lat = lat
    self.lon = lon
    
}
	
	enum Funding : Int, Decodable {
		case Public = 1
		case NonProfit = 2
		case ForProfit = 3
	}
	
	enum CodingKeys : String, CodingKey {
        case id
        case name = "school.name"
        case url = "school.school_url"
        case city = "school.city"
        case state = "school.state"
        case type = "school.ownership"
        case lat = "location.lat"
        case lon = "location.lon"
    }
}

class UniversityTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var loadingActInd: UIActivityIndicatorView!
	@IBOutlet weak var loadingView: UIView!
	
	var uniList : [Uni] = []
	var selectedState : String = ""
	var currentPage : Int = -1
	var requestingSchools : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingActInd.startAnimating()
        
		fetchSchools(page: 0, callback: {() in 
				self.loadingActInd.stopAnimating()
				self.loadingView.isHidden = true
			 })
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniList.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uniCell", for: indexPath)

        let uni = self.uniList[indexPath.row]

		cell.textLabel!.text = uni.name
		cell.detailTextLabel?.text = uni.city
		
		if indexPath.row > self.uniList.count - 10 {
			
			fetchSchools(page: self.uniList.count / 100 as Int)
		
		}

        return cell
    }
    
    // MARK: - Request
    
    func fetchSchools(page: Int, callback: @escaping () -> () = {() in return}) {
    	print("Page \(page) requested, \(self.uniList.count) records currently stored")
    	if self.currentPage >= page || requestingSchools {
    		return
		}
		
		self.requestingSchools = true
	
		let url = URL(string: "https://api.data.gov/ed/collegescorecard/v1/schools?"
								+ 
									"school.state=\(selectedState)"
								+
									"&_fields=id,latest.student.size,location.lon,location.lat,school.name,school.school_url,school.city,school.state,school.ownership"
								+ 
									"&_per_page=100"
								+
									"&_page=\(page)"
								+ 	
									"&_sort=latest.student.size:desc"
								+ 
									"&api_key=DlhQyaEDCtpkkAJsnM8KSkFJMjaKKsbqXMuyVd2w")!
									
			print(url)
        
			let session = URLSession(configuration: URLSessionConfiguration.default)
			let task = session.dataTask(with: url) { (data, response, error) in
				 self.requestingSchools = false
				 if error != nil {
					  print(error!.localizedDescription)
				 } else {
					do{
						let uniListResult = try JSONDecoder().decode(UniList.self, from: data ?? Data()) 
						self.currentPage = page
						self.uniList += uniListResult.results
						self.tableView.reloadData()
						callback()
					} catch {
						print("Error 0x01: Couldn't decode: \(error)")
					}

				 }
			}
			task.resume()
    
	}

}


