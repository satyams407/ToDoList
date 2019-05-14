//
//  ToDoTableViewCell.swift
//  TodoList
//
//  Created by Satyam Sehgal on 17/04/19.
//  Copyright © 2019 Satyam Sehgal. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateCell(with data: ToDo) {
        titleLabel.text = data.title
        descriptionLabel.text = data.detailDescription
    }
    
    class var cellIdentifier: String  {
       return String(describing: self)
    }
}
