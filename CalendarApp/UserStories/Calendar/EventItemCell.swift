//
//  EventItemCell.swift
//  CalendarApp
//
//  Created by Sanzhar Burumbay on 17.07.2023.
//

import UIKit

final class EventItemCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(from event: EventItem) {
        titleLabel.text = event.title
        timeLabel.text = event.time
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { view in
            view.leading.top.bottom.equalToSuperview().inset(16)
        }
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { view in
            view.trailing.top.bottom.equalToSuperview().inset(16)
            view.leading.equalTo(titleLabel.snp.trailing).offset(10)
        }
    }
}
