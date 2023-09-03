//
//  APIModel.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/13.
//

import Foundation
import UIKit


//TEMPORARY TOKEN
struct TemporaryTokenResponse: Decodable {
    let temporaryToken: String
}

//SIGN IN && SIGN UP
struct LoginRequest: Encodable {
    let provider: String
    let oauthId: String
    let temporaryToken: String
}

struct LoginResponse: Codable {
    let grantType: String
    let accessToken: String
    let refreshToken: String
}

struct SignUpRequest: Encodable {
    let nickname: String
    let provider: String
    let oauthId: String
    let temporaryToken: String
    let profileImageUrl: String?
}

//GET USER INFO
struct UserInfoResponse: Decodable {
    let id: Int
    let nickname: String
    let profileImageURL: String
    let oAuthProvider: String
    let followerNumber: Int
    let followingNumber: Int
    let recipeNumber: Int
}

//UPLOAD USER INFO
struct UpdateUserInfoRequestBody: Encodable {
    let nickname: String
    let profileImageURL: String
}

//GET TOKEN AGAIN AGAIN AGAIN AGAIN AGAIN
struct getTokenRequest: Encodable {
    let refreshToken: String
}

//IMAGE
struct ImageURLResponse: Encodable, Decodable{
    let imageUrl: String
}

//FEED
struct AuthorFeed: Decodable {
    let id: Int
    let nickname: String
    let profileImageURL: String?
    let following: Bool
    let myself: Bool
}

struct FeedInfo: Decodable {
    let id: Int
    let title: String
    let thumbnailURL: String?
    let author: AuthorFeed
    let totalBookmarkCount: Int
    let totalCookTimeInSeconds: Int
    let cookwares: [String]
    let difficulty: String
    let averageRating: Double?
    let bookmarked: Bool
}

struct FeedResponse: Decodable {
    let feed: [FeedInfo]
    let hasNext: Bool
}

//ADD RECIPE
struct RecipeDetails: Encodable, Decodable {
    let content: String
    let imageURL: String?
    let cookTimeInSeconds: Int
    let cookwares: [String]
}

struct RecipeRequest: Encodable, Decodable {
    let title: String
    let introduction: String
    let ingredients: [String]
    let difficulty: String
    let thumbnailURL: String
    let recipeDetails: [RecipeDetails]
}

struct RecipeDetailsModel {
    let content: String
    let imageURL: UIImage?
    let cookTimeInSeconds: Int
    let cookwares: [String]
}

struct addRecipeResponse: Decodable {
    let id: Int
}

//FOLLOWER AND FOLLOWERS
struct UserResponse: Encodable, Decodable{
    let UserProfiles: [UserProfile]
}

struct UserProfile: Encodable, Decodable {
    let profileImageURL: String
    let nickname: String
    let userId: Int
}

struct UserWithFollowStatus: Codable {
    let userId: Int
    let nickname: String
    let profileImageURL: String
    let isFollowed: Bool
}



// DETAIL VIEW
struct SummaryDetail: Decodable {
    let id: Int
    let title: String
    let thumbnailURL: String?
    let author: AuthorFeed
    let totalBookmarkCount: Int
    let totalCookTimeInSeconds: Int
    let cookwares: [String]
    let difficulty: String
    let averageRating: Double?
    let bookmarked: Bool
}

struct RecipeDetailSummary: Decodable {
    let id: Int
    let content: String
    let imageURL: String?
    let cookTimeInSeconds: Int
    let cookwares: [String]
    let step: Int
}

struct DetailResponse: Decodable {
    let id: Int
    let summary: SummaryDetail
    let introduction: String
    let ingredients: [String]
    let recipeDetails: [RecipeDetailSummary]
    let myRate: Int
}


//RATING
struct RecipeRating: Codable {
    let recipeId: Int
    let score: Int
}

//FILTER
struct RecipeSearchQuery: Codable {
    let query: String?
    let filterType: String?
    let difficulty: String?
    let maxTotalCookTime: Int?
    let minRating: Int?
    let cookwares: [String]?
}
