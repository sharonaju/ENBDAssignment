//
//  PhotoDetailViewController.swift
//  ENBDAssignment
//
//  Created by Sharon on 22/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewModel: PhotoDetailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prepareUI()
    }
    
    func prepareUI() {
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        imageView.sd_setImage(with: viewModel?.imageURL) { [weak self] (image, error, cache, url) in
            self?.activityIndicator.stopAnimating()
        }
        likesLabel.text = viewModel?.likes
        commentsLabel.text = viewModel?.comments
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
