//
//  MainViewModel.swift
//  ATurkcellApi1
//
//  Created by Sefa Aycicek on 2.10.2024.
//

import UIKit

class MainViewModel: BaseViewModel {
    let apiService : ApiServiceProtocol
        
    var needReloadUITableData : (()->())? = nil
    var needShowProgress : ((Bool)->())? = nil
    
    private var orignalPostList : [Post]? = nil
    private var postList : [[PostListUIModel]]? = nil
    
    init(apiService : ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    //func fetchData(onCompleted : @escaping ()->()) {
    func fetchData() {
        self.needShowProgress?(true)
        Task {
            do {
                try? await Task.sleep(nanoseconds: 3000000000) // dummy
                self.orignalPostList = try await apiService.fetchPosts()
                self.postList = orignalPostList?.map { PostListUIModel(post: $0) }.chunked(into: 13)
                
                await MainActor.run {
                    self.needReloadUITableData?()
                    self.needShowProgress?(false)
                }
                
            } catch {
                await MainActor.run {
                    self.needReloadUITableData?()
                    self.needShowProgress?(false)
                }
            }
        }
    }
    
    var sectionCount : Int {
        return postList?.count ?? 0
    }
    
    func itemCount(section : Int) -> Int {
        return postList?[section].count ?? 0
    }
    
    func getItem(section : Int, index : Int) -> PostListUIModel {
        return postList![section][index]
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
