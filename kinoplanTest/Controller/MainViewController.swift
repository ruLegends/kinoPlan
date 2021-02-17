//
//  MainViewController.swift
//  kinoplanTest
//
//  Created by A on 16.02.2021.
//  Copyright © 2021 test. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var spaceInfo = [SpaceX]()
    private var missionImgs = [UIImage]()
    private let reuseIdentifier = "spacexCell"
    private var selectedMissionInfo: SpaceX? = nil
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        getData()
    }
    
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SpacexTableViewCell", bundle: nil),
                           forCellReuseIdentifier: reuseIdentifier)
    }
    
    private func getData() {
        let urlString = "https://api.spacexdata.com/v3/launches"
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) -> Void in
            if (error != nil) {
                print(error.debugDescription )
            }
            guard let data = data else { return }
            guard let json = try? JSONDecoder().decode([SpaceX].self,
                                                       from: data) else { return }
            
            
            self?.spaceInfo = json
            self?.spaceInfo.sort(by: <)
            
            self?.reloadData()

        })
        dataTask.resume()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table View
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        spaceInfo.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "SpaceX Missons"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath) as! SpacexTableViewCell
        
        let urlString = spaceInfo[indexPath.row].links.mission_patch
        cell.tag = indexPath.row
        
        cell.missionImage.image = nil
        getImage(string: urlString, returnCompletion: { img in
                DispatchQueue.main.async {
                    if cell.tag == indexPath.row {
                        cell.missionImage.image = img
                    }
                }
        })

        cell.missionNameLabel.text = spaceInfo[indexPath.row].mission_name
        cell.rocketName.text = spaceInfo[indexPath.row].rocket.rocket_name
        cell.launchDate.text = spaceInfo[indexPath.row].launch_date_utc
        
        return cell
    }
    
// MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedMissionInfo = spaceInfo[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController
        {
            let vc = segue.destination as? DetailViewController
            vc?.selectedMissionInfo = selectedMissionInfo
            
            getImage(string: selectedMissionInfo?.links.mission_patch,
                     returnCompletion: { img in
                        vc?.downloadedMainImage = img
            })
        }
    }
}

// MARK: - Work with images
extension MainViewController {
    private func getImage(string: String?, returnCompletion: @escaping (UIImage) -> ()) {
        guard let urlString = string else { returnCompletion (UIImage(named: "rocket")!)
            return }
        
        guard let url = URL(string: urlString) else { returnCompletion (UIImage(named: "rocket")!)
            return }
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
              returnCompletion(cachedImage)
        } else {
            loadImage(url: url, returnCompletion: { [weak self] (img: UIImage)  in
                self?.imageCache.setObject(img, forKey: NSString(string: urlString))
                returnCompletion(img)
            })
        }
    }
    
    private func loadImage(url: URL, returnCompletion: @escaping (UIImage) -> () ){
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    returnCompletion(image)
                }
            }
        }
    }
}
