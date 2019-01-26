//
//  StateTableViewController.swift
//  Teste Hi
//
//  Created by Joao pedro Costa Miranda on 24/01/19.
//  Copyright © 2019 Joao. All rights reserved.
//

import UIKit
import Kingfisher

// State definition to decode the JSON
struct	State: Decodable {
	let name: String
	let code: String
	let flag: URL
	
	enum CodingKeys : String, CodingKey {
        case code
        case name = "state"
        case flag = "state_flag_url"
    }
}

class StateTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var loadingActInd: UIActivityIndicatorView!
	@IBOutlet weak var loadingView: UIView!
	
	var stateList : [State] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingActInd.startAnimating()
        
		let url = URL(string: "https://api.myjson.com/bins/1gv07w")!
        
		let session = URLSession(configuration: URLSessionConfiguration.default)
		let task = session.dataTask(with: url) { (data, response, error) in
			 if error != nil {
				  print(error!.localizedDescription)
			 } else {
				guard let stateList = try? JSONDecoder().decode([State].self, from: data ?? Data()) else { 
					print("Error 0x01: Couldn't decode")
					return
				}
					
					
				self.stateList = stateList
				self.tableView.reloadData()
				self.loadingActInd.stopAnimating()
				self.loadingView.isHidden = true
			 }
		}
		task.resume()

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)

		let state = self.stateList[indexPath.row]

		cell.textLabel!.text = state.name
		
		cell.imageView!.kf.setImage(
			with: state.flag,
			options: [
				.scaleFactor(UIScreen.main.scale),
				.cacheOriginalImage
			]){	result in
			switch result {
				case .success(_):
					print(state.name + " flag downloaded")
					let itemSize = CGSize.init(width: 90, height: 60)
					UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
					let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
					cell.imageView!.image!.draw(in: imageRect)
					cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()!
					UIGraphicsEndImageContext()
					cell.imageView!.setNeedsDisplay()
				case .failure(let error):
					print("Error 0x02: \(state.name) flag download Failed - \(error)")
			}
		}
		

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! UniversityTableViewController
        
        let cell = sender as! UITableViewCell
        
        dvc.selectedState = stateList[self.tableView.indexPath(for: cell)!.row].code
    }

}
