//
//  ActivityIndicatorCell.swift
//  SearchTwitter
//
//  Created by Isha Dua on 08/10/21.
//

import UIKit

class ActivityIndicatorCell: UITableViewCell {
    
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: nil)
        createViews()
    }
    
    private func createViews() {
        contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            activityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20)
        ])
    }
    
    func configure(_ isAnimating: Bool) {
        
        if isAnimating {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

