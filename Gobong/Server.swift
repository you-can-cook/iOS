//
//  Server.swift
//  Gobong
//
//  Created by Ebbyy on 2023/08/13.
//

import Foundation
import Alamofire

class Server {
    static let shared = Server()
    
    let url = "http://43.202.126.165:8080"
    
    func fetchTemporaryToken(completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "\(url)/api/users/temporary-token"
        
        AF.request(urlString, method: .post).responseDecodable(of: TemporaryTokenResponse.self) { response in
            switch response.result {
            case .success(let token):
                completion(.success(token.temporaryToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func login(provider: String, oauthId: String, temporaryToken: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let urlString = "\(url)/api/users/login"
        
        let request = LoginRequest(provider: provider, oauthId: oauthId, temporaryToken: temporaryToken)
        
        AF.request(urlString, method: .post, parameters: request, encoder: JSONParameterEncoder.default).responseDecodable(of: LoginResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let loginResponse):
                completion(.success(loginResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signUp(nickName: String, provider: String, oauthId: String, temporaryToken: String, profileImageUrl: String?, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let urlString = "\(url)/api/users/signup"
        
        let request: SignUpRequest!
        if profileImageUrl != nil {
            request = SignUpRequest(nickname: nickName, provider: provider, oauthId: oauthId, temporaryToken: temporaryToken, profileImageUrl: profileImageUrl)
        } else {
            request = SignUpRequest(nickname: nickName, provider: provider, oauthId: oauthId, temporaryToken: temporaryToken, profileImageUrl: nil)
        }
        
        AF.request(urlString, method: .post, parameters: request, encoder: JSONParameterEncoder.default).responseDecodable(of: LoginResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let loginResponse):
                completion(.success(loginResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAccessTokenAgain(completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let urlString = "\(url)/api/auth/reissue"
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        
        let requestBody = getTokenRequest(refreshToken: refreshToken ?? "")
        
        AF.request(urlString, method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default).responseDecodable(of: LoginResponse.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let loginResponse):
                // Handle successful response
                print("Login response:", loginResponse)
                completion(.success(loginResponse))
            case .failure(let error):
                // Handle error
                print("Login error:", error)
                completion(.failure(error))
            }
        }
    }
    
    //GET FEED
    func getRecipeFeed(completion: @escaping(Result<FeedResponse, Error>) -> Void ){
        let urlString = "\(url)/api/feed/all"
        let parameters: [String: Any] = ["count": 10]
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .get, parameters: parameters, headers: headers).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                print("Raw JSON Data:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(FeedResponse.self, from: data)
                    completion(.success(recipes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //PROFILEEEE FEEEDDDDD
    func getMyFeed(completion: @escaping(Result<FeedResponse, Error>) -> Void ){
        let urlString = "\(url)/api/feed/my"
        let parameters: [String: Any] = ["count": 10]
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .get, parameters: parameters, headers: headers).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                print("Raw JSON Data:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(FeedResponse.self, from: data)
                    completion(.success(recipes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //GET BOOKMARK DATAA
    func getRecipeBookMark(completion: @escaping(Result<FeedResponse, Error>) -> Void ){
        let urlString = "\(url)/api/feed/bookmarked"
        let parameters: [String: Any] = ["count": 10]
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .get, parameters: parameters, headers: headers).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                print("Raw JSON Data:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(FeedResponse.self, from: data)
                    completion(.success(recipes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //GET FOLLOWING FEEEEDDDDDDDDD
    func getMainRecipeList(completion: @escaping(Result<FeedResponse, Error>) -> Void ){
        let urlString = "\(url)/api/feed/following"
        let parameters: [String: Any] = ["count": 10]
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .get, parameters: parameters, headers: headers).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                print("Raw JSON Data:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(FeedResponse.self, from: data)
                    completion(.success(recipes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //POST DETAIL VIEW
    func getPostDetail(recipeId: Int, completion: @escaping(Result<DetailResponse, Error>) -> Void ){
        let urlString = "\(url)/api/recipes/\(recipeId)"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print("Raw JSON Data:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(DetailResponse.self, from: data)
                    completion(.success(recipes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getFriendsFeed(recipeId: Int, completion: @escaping(Result<FeedResponse, Error>) -> Void ){
        let urlString = "\(url)/api/feed/\(recipeId)"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print("Raw JSON Data:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(FeedResponse.self, from: data)
                    completion(.success(recipes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //FILTER
    func filter(query: String?, filterType: String?, difficulty: String?, maxTotalCookTime: Int?, minRating: Int?, cookwares: [String]?, completion: @escaping(Result<FeedResponse, Error>) -> Void ){
        let urlString = "\(url)/api/feed/filter?page=\(0)&count=\(10)"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        var requestBody = RecipeSearchQuery(query: query, filterType: filterType, difficulty: difficulty, maxTotalCookTime: maxTotalCookTime, minRating: minRating, cookwares: cookwares)
        
        AF.request(urlString, method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                print("Raw JSON Data:", String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(FeedResponse.self, from: data)
                    completion(.success(recipes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //ADD RECIPE
    func addRecipe(title: String, introduction: String, ingredients: [String], difficulty: String, thumbnailURL: String, recipeDetails: [RecipeDetails], completion: @escaping (Result<addRecipeResponse, Error>) -> Void) {
        let urlString = "\(url)/api/recipes" // Update with the actual URL
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        let requestBody = RecipeRequest(title: title, introduction: introduction, ingredients: ingredients, difficulty: difficulty, thumbnailURL: thumbnailURL, recipeDetails: recipeDetails)
        
        AF.request(urlString, method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print("Raw JSON Data:", String(data: data, encoding: .utf8) ?? "")
            case .failure(let error):
                completion(.failure(error))
                print("Add recipe error:", error)
            }
        }
    }
    
    //DELETE POST
    func deletePost(id: Int, completion: @escaping () -> Void ) {
        let urlString = "\(url)/api/recipes/\(id)"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .delete, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                print("Raw JSON Data:", String(data: data, encoding: .utf8) ?? "")
                completion()
            case .failure(let error):
                completion()
                print("Add recipe error:", error)
            }
        }
    }

    
    //FOLLOWER AND FOLLOWING
    //GET FOLLOWING
    func getFollowing(completion: @escaping (Result<[UserProfile], Error>) -> Void) {
        let urlString = "\(url)/api/following"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        AF.request(urlString, method: .get, headers: headers).responseDecodable(of: [UserProfile].self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let userProfileArray):
                completion(.success(userProfileArray.self))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getFollowers(completion: @escaping (Result<[UserWithFollowStatus], Error>) -> Void) {
        let urlString = "\(url)/api/follower"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .get, headers: headers).responseDecodable(of: [UserWithFollowStatus].self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let userProfileArray):
                completion(.success(userProfileArray.self))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func followUser(id: Int, completion: @escaping () -> Void) {
        let urlString = "\(url)/api/follow/\(id)"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .post, headers: headers).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success( _):
                completion()
            case .failure( _):
                completion()
            }
        }
    }
    
    func unfollowUser(id: Int, completion: @escaping () -> Void) {
        let urlString = "\(url)/api/unfollow/\(id)"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .post, headers: headers).responseData { response in
            debugPrint(response)
            switch response.result {
            case .success( _):
                completion()
            case .failure( _):
                completion()
            }
        }
    }
    
    func bookMark(id: Int, completion: @escaping () -> Void) {
        let urlString = "\(url)/api/bookmarks/\(id)"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .post, headers: headers).responseData { response in
            print(response)
            switch response.result {
            case .success( _):
                completion()
            case .failure( _):
                completion()
            }
        }
    }
    
    func cancelBookMark(id: Int, completion: @escaping () -> Void) {
        let urlString = "\(url)/api/bookmarks/\(id)"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .delete, headers: headers).responseData { response in
            print(response)
            switch response.result {
            case .success( _):
                completion()
            case .failure( _):
                completion()
            }
        }
    }
    
    //RATING
    func sendRating(id: Int, score: Int, completion: @escaping () -> Void) {
        let urlString = "\(url)/api/ratings"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        let requestBody = RecipeRating(recipeId: id, score: score)
        
        AF.request(urlString, method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            print("REsponSSEEEE",  response)
            switch response.result {
            case .success( _):
                completion()
            case .failure( _):
                completion()
            }
        }
    }
    
    func editRating(id: Int, score: Int, completion: @escaping () -> Void) {
        let urlString = "\(url)/api/ratings"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        let requestBody = RecipeRating(recipeId: id, score: score)
        
        AF.request(urlString, method: .put, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            print("REsponSSEEEE",  response)
            switch response.result {
            case .success( _):
                completion()
            case .failure( _):
                completion()
            }
        }
    }
    
    
    
    //GET USER INFORMATION
    func getUserInfo(completion: @escaping (Result<UserInfoResponse, Error>) -> Void) {
        let urlString = "\(url)/api/users"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        AF.request(urlString, method: .get, headers: headers).responseDecodable(of: UserInfoResponse.self) { response in
            switch response.result {
            case .success(let userResponse):
                completion(.success(userResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //USER INFO EDIT
    func changeUserInfo(nickName: String, profileURL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "\(url)/api/users"
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken ?? "")"
        ]
        
        let requestBody = UpdateUserInfoRequestBody(nickname: nickName, profileImageURL: profileURL)
        
        AF.request(urlString, method: .patch, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    //UPLOAD IMAGE
    func uploadImage(image: UIImage, nickname: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "\(url)/api/images/upload"
        
        let imageData = image.jpegData(compressionQuality: 0.1) // Convert UIImage to Data
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                multipartFormData.append(Data(nickname.utf8), withName: "nickname")
            },
            to: urlString,
            method: .post
        )
        .responseDecodable(of: ImageURLResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.imageUrl))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
