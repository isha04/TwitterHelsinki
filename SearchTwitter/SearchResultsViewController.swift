//
//  SearchResultsViewController.swift
//  SearchTwitter
//
//  Created by Isha Dua on 30/09/21.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    private let searchAPIEndPoint = "2/tweets/search/recent"
    private var searchTerm = "helsinki"
    private var tweets: [TweetData] = []
    private var userDictionary: [String: User] = [:]

    
    // MARK: Network setup variables
    
    private var nextToken = ""
    private var isFetchInProgress = false
    var twitterHandler: TwitterAPIHandler
    
    // MARK: Setting up views
    
    var tableView = UITableView()
    var queryParams: [String:String] = [
        "max_results": "20",
        "expansions": "attachments.media_keys,author_id",
        "media.fields": "duration_ms,height,media_key,preview_image_url,public_metrics,type,url,width",
        "tweet.fields" : "attachments,author_id,created_at,public_metrics",
        "user.fields" : "id,name,username,profile_image_url"
    ]
        
    init(apiHander: TwitterAPIHandler) {
        self.twitterHandler = apiHander
        super.init(nibName: nil, bundle: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        getSearchData()
    }
    
    private func createViews() {
        self.title = searchTerm
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: "TweetTableViewCell")
        tableView.register(ActivityIndicatorCell.self, forCellReuseIdentifier: "ActivityIndicatorCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getSearchData() {
        guard !isFetchInProgress else {
          return
        }

        queryParams["query"] = searchTerm
        isFetchInProgress = true
        twitterHandler.getData(withAPIEndpoint: searchAPIEndPoint, queryParams: queryParams) { [weak self] result in
            
            switch result {
            case .success(let data):
                self?.isFetchInProgress = false
                do {
                    let parsedData = try JSONDecoder().decode(TwitterSearchData.self, from: data)
                    DispatchQueue.main.async {
                        self?.tweets.append(contentsOf: parsedData.data)
                        parsedData.data.forEach { tweet in
                                let user = parsedData.includes.users.first { user in
                                user.id == tweet.authorID }
                            
                            self?.userDictionary[tweet.authorID] = user
                            }
                        
                        if self?.nextToken == "" {
                            self?.tableView.isHidden = false
                            self?.tableView.reloadData()
                        } else {
                            if let newIndexPathsToReload = self?.calculateIndexPathsToReload(from: parsedData.data), let visibleIndexPathsToReload = self?.visibleIndexPathsToReload(intersecting: newIndexPathsToReload) {
                                self?.tableView.insertRows(at: newIndexPathsToReload, with: .automatic)
                                self?.tableView.reloadRows(at: visibleIndexPathsToReload, with: .automatic)
                            }
                            
                            self?.twitterHandler.removeDataLoadRequest(self?.nextToken ?? "")
                        }
                        
                        self?.nextToken = parsedData.meta.nextToken
                        
                    }

                } catch {
                    print(error)
                }
                
                            
            case .failure(let error):
                self?.isFetchInProgress = false
                print(error)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultsViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoadingCell(for: indexPath) {
            let activityIndicatorCell = tableView.dequeueReusableCell(withIdentifier: "ActivityIndicatorCell") as! ActivityIndicatorCell
            activityIndicatorCell.configure(true)
            return activityIndicatorCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as! TweetTableViewCell
            let tweet = tweets[indexPath.row]
            if let user = self.userDictionary[tweet.authorID] {
                cell.setData(userData: user, tweet: tweet)
            }
            return cell

        }
    }
}

extension SearchResultsViewController: UITableViewDelegate {}

extension SearchResultsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            queryParams["next_token"] = nextToken
            getSearchData()
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        if !indexPaths.contains(where: isLoadingCell) {
            twitterHandler.removeDataLoadRequest(nextToken)
        }
    }
}

private extension SearchResultsViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= tweets.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
      let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
      return Array(indexPathsIntersection)
    }
    
    private func calculateIndexPathsToReload(from newTweets: [TweetData]) -> [IndexPath] {
      let startIndex = tweets.count - newTweets.count
      let endIndex = startIndex + newTweets.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

}
