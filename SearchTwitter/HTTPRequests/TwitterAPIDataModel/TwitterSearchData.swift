//
//  TwitterSearchData.swift
//  SearchTwitter
//
//  Created by Isha Dua on 30/09/21.
//

import Foundation


// MARK: - TwitterData
struct TwitterSearchData: Codable {
    let data: [TweetData]
    let includes: Includes
    let meta: Meta
}

// MARK: - Tweets
struct TweetData: Codable {
    let id, createdAt, authorID: String
    let publicMetrics: PublicMetrics
    let text: String
    let attachments: Attachments?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case authorID = "author_id"
        case publicMetrics = "public_metrics"
        case text, attachments
    }
}

// MARK: - Attachments
struct Attachments: Codable {
    let mediaKeys: [String]?

    enum CodingKeys: String, CodingKey {
        case mediaKeys = "media_keys"
    }
}

// MARK: - PublicMetrics
struct PublicMetrics: Codable {
    let retweetCount, replyCount, likeCount, quoteCount: Int

    enum CodingKeys: String, CodingKey {
        case retweetCount = "retweet_count"
        case replyCount = "reply_count"
        case likeCount = "like_count"
        case quoteCount = "quote_count"
    }
}

// MARK: - Includes
struct Includes: Codable {
    let users: [User]
    let media: [Media]?
    
    enum CodingKeys: String, CodingKey {
        case users, media
    }
}

// MARK: - Media
struct Media: Codable {
    let type: String
    let width, height: Int
    let mediaKey: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case type, width, height
        case mediaKey = "media_key"
        case url
    }
}

// MARK: - User
struct User: Codable {
    let name, username: String
    let profileImageURL: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name, username
        case profileImageURL = "profile_image_url"
        case id
    }
}

// MARK: - Meta
struct Meta: Codable {
    let newestID, oldestID: String
    let resultCount: Int
    let nextToken: String

    enum CodingKeys: String, CodingKey {
        case newestID = "newest_id"
        case oldestID = "oldest_id"
        case resultCount = "result_count"
        case nextToken = "next_token"
    }
}


extension TweetData: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(createdAt)
        hasher.combine(authorID)
        hasher.combine(text)
        hasher.combine(publicMetrics)
        hasher.combine(attachments)
    }
}

extension PublicMetrics: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(retweetCount)
        hasher.combine(replyCount)
        hasher.combine(likeCount)
        hasher.combine(quoteCount)
    }
}

extension Attachments: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(mediaKeys)
    }
}


