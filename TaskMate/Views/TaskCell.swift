//
//  TaskCell.swift
//  TaskMate
//
//  Created by Shivanand Koli on 06/02/26.
//

import UIKit

final class TaskCell: UITableViewCell {

    static let identifier = "TaskCell"

    private let titleLabel = UILabel()
    private let statusImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with task: Task) {
        titleLabel.text = task.title
        statusImageView.image = task.isCompleted
            ? UIImage(systemName: "checkmark.circle.fill")
            : UIImage(systemName: "circle")
    }
    
    func setupUI() {
            titleLabel.font = .systemFont(ofSize: 16)
            statusImageView.tintColor = .systemBlue

            [statusImageView, titleLabel].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview($0)
            }

            NSLayoutConstraint.activate([
                statusImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                statusImageView.widthAnchor.constraint(equalToConstant: 24),
                statusImageView.heightAnchor.constraint(equalToConstant: 24),

                titleLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
}
