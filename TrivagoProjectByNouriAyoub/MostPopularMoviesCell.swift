//
//  MostpopularCell.swift
//  TrivagoProjectByNouriAyoub
//
//  Created by mac on 08/08/16.
//  Copyright © 2016 AYOUB NOURI. All rights reserved.
//

import UIKit
import MarqueeLabel
class MostPopularMoviesCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: MarqueeLabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var overview: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
