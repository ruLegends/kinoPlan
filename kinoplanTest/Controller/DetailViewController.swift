//
//  DetailViewController.swift
//  kinoplanTest
//
//  Created by A on 16.02.2021.
//  Copyright © 2021 test. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var missionName: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var rocketName: UILabel!
    @IBOutlet weak var launchSiteName: UILabel!
    @IBOutlet weak var activityBar: UIActivityIndicatorView!
    @IBOutlet weak var redditButton: UIButton!
    @IBOutlet weak var wikiButton: UIButton!
    @IBOutlet weak var articleButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var selectedMissionInfo: SpaceX!
    var downloadedMainImage: UIImage!
    var downloadedDetailImages:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onRedditButtonTap(_ sender: Any) {
        if let urlString = selectedMissionInfo.links.reddit_media {
            openSite(urlString: urlString)
        }
    }
    
    @IBAction func onWikiButtonTap(_ sender: Any) {
        if let urlString = selectedMissionInfo.links.wikipedia {
            openSite(urlString: urlString)
        }
    }
    
    @IBAction func onArticleTap(_ sender: Any) {
        if let urlString = selectedMissionInfo.links.article_link {
            openSite(urlString: urlString)
        }
    }
    
    @IBAction func onYoutubeButtonTap(_ sender: Any) {
        if let urlString = selectedMissionInfo.links.video_link {
            openSite(urlString: urlString)
        }
    }
    
    @IBAction func onAlbumButtonTap(_ sender: Any) {
        startLoading()
        
        prepareImages(returnCompletion: { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.stopLoading()
            }
            self?.showDetail()
        })
    }

// MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ImagesViewController
        {
            let vc = segue.destination as? ImagesViewController
            vc?.downloadedDetailImages = downloadedDetailImages
        }
    }
    
    private func prepareImages(returnCompletion: @escaping () -> ()) {
        let flickrImages = selectedMissionInfo.links.flickr_images
        
        DispatchQueue.global().async { [weak self] in
            
            for link in 0..<flickrImages.count {
                let urlString = flickrImages[link]
                guard let url = URL(string: urlString) else { continue }
                
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                        self?.downloadedDetailImages.append(image)
                        
                        if self?.downloadedDetailImages.count == flickrImages.count {
                            returnCompletion()
                        }
                    }
                }
            }
        }
    }
    
    private func prepareView() {
        missionName.text = selectedMissionInfo.mission_name
        mainImage.image = downloadedMainImage
        rocketName.text = selectedMissionInfo.rocket.rocket_name
        launchSiteName.text = selectedMissionInfo.launch_site.site_name_long
        
        if selectedMissionInfo.links.flickr_images.isEmpty {
            self.albumLabel.text = "Album is empty"
            self.albumButton.isHidden = true
        }
    }
    
    private func openSite(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func showDetail() {
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: "showDetail", sender: nil)
        }
    }
    
    private func startLoading() {
        activityBar.isHidden = false
        activityBar.startAnimating()
        
        backButton.isEnabled = false
        albumButton.isEnabled = false
        redditButton.isEnabled = false
        wikiButton.isEnabled = false
        articleButton.isEnabled = false
        youtubeButton.isEnabled = false
    }
    
    private func stopLoading() {
        activityBar.stopAnimating()
        
        backButton.isEnabled = true
        albumButton.isEnabled = true
        redditButton.isEnabled = true
        wikiButton.isEnabled = true
        articleButton.isEnabled = true
        youtubeButton.isEnabled = true
    }
    
}
