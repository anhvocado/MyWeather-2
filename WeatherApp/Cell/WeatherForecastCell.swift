//
//  WeatherForecastCell.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 21/09/2022.
//

import UIKit
import GradientProgressBar

class WeatherForecastCell: UITableViewCell {
    @IBOutlet weak var lbDay: UILabel!
    
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lbProbOfRain: UILabel!
    @IBOutlet weak var tempBar: GradientProgressBar!
    @IBOutlet weak var lbMinTemp: UILabel!
    @IBOutlet weak var lbMaxTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTempBar()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupTempBar() {
        tempBar.progress = 1
        
        tempBar.layer.masksToBounds = true
        tempBar.layer.cornerRadius = 2
    }
}
