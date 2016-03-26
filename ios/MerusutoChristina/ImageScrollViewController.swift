//
//  ImageScrollViewController.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/27.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController {
  var item: UnitItem!
  
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var loadingView: UIView!
  var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    DataManager.loadImageWithSuccess("units/original/\(item.id)", success: { (image) -> Void in
      self.imageView = UIImageView(image: image)
      self.imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
      self.scrollView.addSubview(self.imageView)
      self.scrollView.contentSize = image.size
      
      UIView.animateWithDuration(0.25, animations: {
        self.loadingView.alpha = 0
        }, completion: { finished in
          self.loadingView.hidden = true
      })
      
      self.imageView.alpha = 0
      UIView.animateWithDuration(0.25, animations: {
        self.imageView.alpha = 1
      })
      
      let scrollViewFrameSize = self.scrollView.frame.size
      let scrollViewContentSize = self.scrollView.contentSize
      let scaleWidth = scrollViewFrameSize.width / scrollViewContentSize.width
      let scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height
      let minScale = min(scaleWidth, scaleHeight)
      
      self.scrollView.minimumZoomScale = minScale
      self.scrollView.zoomScale = minScale
      
      self.centerScrollViewContents()
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  @IBAction func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
    let pointInView = recognizer.locationInView(self.imageView)
    
    var newZoomScale = scrollView.zoomScale * 1.5
    newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
    
    let scrollViewSize = scrollView.bounds.size
    let w = scrollViewSize.width / newZoomScale
    let h = scrollViewSize.height / newZoomScale
    let x = pointInView.x - (w / 2.0)
    let y = pointInView.y - (h / 2.0)
    
    let rectToZoomTo = CGRectMake(x, y, w, h)
    println(newZoomScale)
    println(rectToZoomTo)
    
    scrollView.zoomToRect(rectToZoomTo, animated: true)
  }
  
  func centerScrollViewContents() {
    let boundsSize = scrollView.bounds.size
    var contentsFrame = imageView.frame
    
    if contentsFrame.size.width < boundsSize.width {
      contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
    } else {
      contentsFrame.origin.x = 0.0
    }
    
    if contentsFrame.size.height < boundsSize.height {
      contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
    } else {
      contentsFrame.origin.y = 0.0
    }
    
    imageView.frame = contentsFrame
  }
  
  func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
    return imageView
  }
  
  func scrollViewDidZoom(scrollView: UIScrollView!) {
    centerScrollViewContents()
  }
}
