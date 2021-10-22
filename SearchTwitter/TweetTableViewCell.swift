//
//  TweetTableViewCell.swift
//  SearchTwitter
//
//  Created by Isha Dua on 05/10/21.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    private lazy var userNameLabel = UILabel()
    private lazy var tweetHandleLable = UILabel()
    private lazy var durationLabel = UILabel()
    private lazy var tweetBodyTextLabel = UILabel()
    private lazy var profileImageView = UIImageView()
    private let dateFormatter = DateFormatter()
    private let componentFormatter = DateComponentsFormatter()
    var onReuse: () -> Void = {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        createViews()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        componentFormatter.unitsStyle = .abbreviated
        componentFormatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        componentFormatter.maximumUnitCount = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
    }
    
    private func createViews() {
        contentView.addSubview(userNameLabel)
        contentView.addSubview(tweetHandleLable)
        contentView.addSubview(durationLabel)
        contentView.addSubview(tweetBodyTextLabel)
        contentView.addSubview(profileImageView)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        tweetHandleLable.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        tweetBodyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        userNameLabel.numberOfLines = 1
        tweetHandleLable.numberOfLines = 1
        durationLabel.numberOfLines = 1
        tweetBodyTextLabel.numberOfLines = 0

        tweetHandleLable.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tweetHandleLable.setContentHuggingPriority(.required, for: .horizontal)
        userNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        profileImageView.layer.borderWidth = 1
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            profileImageView.bottomAnchor.constraint(equalTo: tweetBodyTextLabel.topAnchor, constant: -10),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),

            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            userNameLabel.bottomAnchor.constraint(equalTo: tweetBodyTextLabel.topAnchor, constant: -10),
            
            tweetHandleLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            tweetHandleLable.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 8),
            tweetHandleLable.bottomAnchor.constraint(equalTo: tweetBodyTextLabel.topAnchor, constant: -10),
            
            durationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            durationLabel.leadingAnchor.constraint(equalTo: tweetHandleLable.trailingAnchor, constant: 8),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            durationLabel.bottomAnchor.constraint(equalTo: tweetBodyTextLabel.topAnchor, constant: -10),
            
            tweetBodyTextLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            tweetBodyTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            tweetBodyTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)

        ])
    }
    
    func setData(userData: User, tweet: TweetData) {
        userNameLabel.text = userData.name
        tweetHandleLable.text = userData.username
        tweetBodyTextLabel.text = tweet.text
        if let date = dateFormatter.date(from: tweet.createdAt) {
            durationLabel.text = componentFormatter.string(from: date, to: Date())
        }
        
        if let unwrappedURL = URL(string: userData.profileImageURL) {
            loadProfileImage(from: unwrappedURL)
        } else {
            DispatchQueue.main.async {
                self.profileImageView.image = self.getDefaultImage()
            }
        }
    }
    
    func loadProfileImage(from url: URL) {
        let token = ImageLoader.sharedLoader.loadImage(url) { result in
            var imageToDisplay = self.getDefaultImage()
            switch result {
            case .success(let image):
                imageToDisplay = image
            case .failure(let error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.profileImageView.image = imageToDisplay
            }
        }
        
        onReuse = {
            if let token = token {
                ImageLoader.sharedLoader.cancelImageLoadRequest(token)
             }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    private func getDefaultImage() -> UIImage {
        let symbolConfig = UIImage.SymbolConfiguration(weight: .light)
        let defaultImage = UIImage(systemName: "person.circle.fill", withConfiguration: symbolConfig)
        return defaultImage!
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
