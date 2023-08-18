//
//  NewsTableViewCell.swift
//  NewsScreen
//
//  Created by Ваня Сокол on 16.08.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"

    // MARK: - Properties
    private lazy var newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarcy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupHierarcy() {
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            newsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellConstants.paddingConstant),
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellConstants.paddingConstant),
            newsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CellConstants.paddingConstant),
            newsTitleLabel.heightAnchor.constraint(equalToConstant: CellConstants.newsTitleLabelHeight),

            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellConstants.paddingConstant),
            subtitleLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: CellConstants.paddingConstant),
            subtitleLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width / 2 + CellConstants.subtitleLabelWidthPadding),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CellConstants.paddingConstant),

            newsImageView.leadingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor, constant: CellConstants.paddingConstant),
            newsImageView.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: CellConstants.paddingConstant),
            newsImageView.heightAnchor.constraint(equalToConstant:
                                                    TableViewConstants.rowHeight  - (3 * CellConstants.paddingConstant + CellConstants.newsTitleLabelHeight)),
            newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 1.65),
        ])
    }

    // MARK: - Configure
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle

        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let  url = viewModel.imageURL {

            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else { return }

                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
}

// MARK: - Enums
enum CellConstants {
    static let newsTitleLabelHeight: CGFloat = 20
    static let paddingConstant: CGFloat = 10
    static let subtitleLabelWidthPadding: CGFloat = 40
}
