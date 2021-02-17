//
//  SpacexModel.swift
//  kinoplanTest
//
//  Created by A on 16.02.2021.
//  Copyright © 2021 test. All rights reserved.
//

import Foundation

struct SpaceX: Decodable, Comparable {
    let mission_name: String
    let launch_date_utc: String
    let links: Links
    let rocket: Rocket
    let launch_site: Launch
}

struct Links: Decodable {
    let mission_patch: String?
    let reddit_media: String?
    let video_link: String?
    let wikipedia: String?
    let article_link: String?
    let flickr_images: [String]
}

struct Rocket: Decodable {
    let rocket_name: String
}

struct Launch: Decodable {
    let site_name_long: String
}

func < (lhs: SpaceX, rhs: SpaceX) -> Bool {
    lhs.launch_date_utc > rhs.launch_date_utc
}

func == (lhs: SpaceX, rhs: SpaceX) -> Bool {
    lhs == rhs
}
