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
    private var postList : [[PostListUIModel]] = []
    
    var pageIndex = 0
    var endOfList : Bool = false
    
    init(apiService : ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    //func fetchData(onCompleted : @escaping ()->()) {
    func fetchData(isRefreshList : Bool = false) {
        self.needShowProgress?(true)
       
        if isRefreshList {
            postList.removeAll()
        }
        
        Task {
            do {
                try? await Task.sleep(nanoseconds: 3000000000) // dummy
                self.orignalPostList = try await apiService.fetchPosts()
                if let items = orignalPostList?.map({ PostListUIModel(post: $0) }).chunked(into: 13), !items.isEmpty {
                    postList.append(contentsOf: items)
                } else {
                    endOfList = true
                }
                
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
        return postList.count
    }
    
    func itemCount(section : Int) -> Int {
        return postList[section].count
    }
    
    func getItem(section : Int, index : Int) -> PostListUIModel {
        return postList[section][index]
    }
    
    func willDisplayData(indexPath : IndexPath) {
        if endOfList { return }
        
        if indexPath.section == (sectionCount - 1) &&
            indexPath.row == itemCount(section: indexPath.section) - 1 {
            fetchData()
        }
    }
    
    func deleteItem(indexPath : IndexPath) {
        self.postList[indexPath.section].remove(at: indexPath.row)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
