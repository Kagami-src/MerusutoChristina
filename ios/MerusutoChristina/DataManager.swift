import UIKit
import SystemConfiguration

class DataManager {

  class func loadJSONWithSuccess(key: NSString, success: ((data: JSON!) -> Void)) {
    checkVersionWithSuccess("\(key).json", success: {(needUpdate) -> Void in
      if needUpdate {
        self.loadGithubDataWithSuccess("\(key).json", success: {(data) -> Void in
          success(data: JSON(data: data))
        })
      } else {
        self.loadDataWithSuccess("\(key).json", success: {(data) -> Void in
          success(data: JSON(data: data))
        })
      }
    })
  }

  class func loadImageWithSuccess(key: NSString, success: ((data: UIImage!) -> Void)) {
    loadDataWithSuccess("\(key).png", success: {(data) -> Void in
      success(data: UIImage(data: data))
    })
  }

  class func checkVersionWithSuccess(key: NSString, success: ((needUpdate: Bool) -> Void)) {
    if Reachability.isConnectedToNetworkOfType() != ReachabilityType.WiFi {
      success(needUpdate: false)
      return
    }

    let localFileUrl = self.getLocalFileURL("\(key).version")
    loadDataFromURL(localFileUrl, completion: {(data, readError) -> Void in
      if let localData = data {
        self.loadGithubDataWithSuccess("\(key).version", success: {(data) -> Void in
          if localData.isEqualToData(data) {
            success(needUpdate: false)
          } else {
            success(needUpdate: true)
          }
        })
      } else {
        self.loadGithubDataWithSuccess("\(key).version", success: {(data) -> Void in })
        success(needUpdate: true)
      }
    })
  }

  class func loadDataWithSuccess(key: NSString, success: ((data: NSData!) -> Void)) {
    let localFileUrl = self.getLocalFileURL(key)
    loadDataFromURL(localFileUrl, completion: {(data, readError) -> Void in
      if let localData = data {
        println("Read file from Local System: \(localFileUrl)")
        success(data: localData)
      } else {
        self.loadGithubDataWithSuccess(key, success: success)
      }
    })
  }

  class func loadGithubDataWithSuccess(key: NSString, success: ((data: NSData!) -> Void)) {
    let localFileUrl = self.getLocalFileURL(key)
    let githubUrl = self.getGithubURL(key)
    loadDataFromURL(githubUrl, completion: {(data, responseError) -> Void in
      if let remoteData = data {
        println("Read file from Github: \(githubUrl)")
        success(data: remoteData)
        NSFileManager.defaultManager().createDirectoryAtURL(localFileUrl.URLByDeletingLastPathComponent!,
        withIntermediateDirectories: true, attributes: nil, error: nil)
        remoteData.writeToURL(localFileUrl, atomically: true)
      } else {
        self.loadDataFromURL(localFileUrl, completion: { (data, error) -> Void in
          if let localData = data {
            println("Github unavailable, read file from Local System: \(localFileUrl)")
            success(data: localData)
          } else {
            println("Github and Local System unavailable, Game over!")
          }
        })
      }
    })
  }

  class func getLocalFileURL(key: NSString) -> NSURL {
    let baseURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
      inDomains: .UserDomainMask).first! as! NSURL
    return baseURL.URLByAppendingPathComponent(key as String)
  }

  class func getGithubURL(key: NSString) -> NSURL {
    let baseURL = NSURL(string: "http://bbtfr.github.io/MerusutoChristina/data/")!
    return baseURL.URLByAppendingPathComponent(key as String)
  }

  class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
    var session = NSURLSession.sharedSession()

    // Use NSURLSession to get data from an NSURL
    let loadDataTask = session.dataTaskWithURL(url, completionHandler:
      { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
      if let responseError = error {
        completion(data: nil, error: responseError)
      } else if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode != 200 {
          var statusError = NSError(domain: "com.bbtfr", code: httpResponse.statusCode,
            userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
          completion(data: nil, error: statusError)
        } else {
          completion(data: data, error: nil)
        }
      } else {
        completion(data: data, error: nil)
      }
    })

    loadDataTask.resume()
  }
}
