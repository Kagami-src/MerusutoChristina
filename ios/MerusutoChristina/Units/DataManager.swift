import UIKit
import SwiftyJSON
import Reachability
import SystemConfiguration

class DataManager {

	static var switchToReserve = false

	class func loadJSONWithSuccess(key: NSString, success: ((data: JSON!) -> Void)) {
		checkVersionWithSuccess("\(key).json", success: { (needUpdate) -> Void in
			if needUpdate {
				self.loadGithubDataWithSuccess("\(key).json", success: { (data) -> Void in
					success(data: JSON(data: data))
				})
			} else {
				self.loadDataWithSuccess("\(key).json", success: { (data) -> Void in
					success(data: JSON(data: data))
				})
			}
		})
	}

	class func loadImageWithSuccess(key: NSString, success: ((data: UIImage!) -> Void)) {
		loadDataWithSuccess("\(key).png", success: { (data) -> Void in
			success(data: UIImage(data: data))
		})
	}

	class func checkVersionWithSuccess(key: NSString, success: ((needUpdate: Bool) -> Void)) {
		if Reachability.reachabilityForLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi {
			success(needUpdate: false)
			return
		}

		let localFileUrl = self.getLocalFileURL("\(key).version")
		loadDataFromURL(localFileUrl, completion: { (data, readError) -> Void in
			if let localData = data {
				self.loadGithubDataWithSuccess("\(key).version", success: { (data) -> Void in
					if localData.isEqualToData(data) {
						success(needUpdate: false)
					} else {
						success(needUpdate: true)
					}
				})
			} else {

				self.loadGithubDataWithSuccess("\(key).version", success: { (data) -> Void in })
				success(needUpdate: true)
			}
		})
	}

	class func loadDataWithSuccess(key: NSString, success: ((data: NSData!) -> Void)) {
		let localFileUrl = self.getLocalFileURL(key)
		loadDataFromURL(localFileUrl, completion: { (data, readError) -> Void in
			if let localData = data {
				print("Read file from Local System: \(localFileUrl)")
				success(data: localData)
			} else {
				self.loadGithubDataWithSuccess(key, success: success)
			}
		})
	}

	class func loadGithubDataWithSuccess(key: NSString, success: ((data: NSData!) -> Void)) {
		let localFileUrl = self.getLocalFileURL(key)
		var githubUrl = self.getGithubURL(key)
		loadDataFromURL(githubUrl, completion: { (data, responseError) -> Void in
			if let remoteData = data {
				print("Read file from Github: \(githubUrl)")
				success(data: remoteData)

				do {
					try NSFileManager.defaultManager().createDirectoryAtURL(localFileUrl.URLByDeletingLastPathComponent!, withIntermediateDirectories: true, attributes: nil)
				}
				catch {
					print(error)
				}
				remoteData.writeToURL(localFileUrl, atomically: true)
			} else {

                //如果加载失败，切换到备用服务器再尝试加载
				switchToReserve = true
                githubUrl = self.getGithubURL(key)
                print("Switch to reserve")
                
				loadDataFromURL(githubUrl, completion: { (data, error) -> Void in
					if let remoteData = data {
						print("Read file from Reserve: \(githubUrl)")
						success(data: remoteData)

						do {
							try NSFileManager.defaultManager().createDirectoryAtURL(localFileUrl.URLByDeletingLastPathComponent!, withIntermediateDirectories: true, attributes: nil)
						}
						catch {
							print(error)
						}
						remoteData.writeToURL(localFileUrl, atomically: true)
					} else {
                        //如果还是失败，尝试读取本地文件
						self.loadDataFromURL(localFileUrl, completion: { (data, error) -> Void in
							if let localData = data {
								print("Github unavailable, read file from Local System: \(localFileUrl)")
								success(data: localData)
							} else {
								print("Github and Local System unavailable, Game over!")
							}
						})
					}
				})
			}
		})
	}

	class func getLocalFileURL(key: NSString) -> NSURL {
		let baseURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
		return baseURL.URLByAppendingPathComponent(key as String)
	}

	class func getGithubURL(key: NSString) -> NSURL {
		let baseURL: NSURL!

//		if (switchToReserve)
//		{
			baseURL = NSURL(string: "http://bbtfr.github.io/MerusutoChristina/data/")!
//		}
//		else
//		{
//			baseURL = NSURL(string: "http://merusuto.coding.me/data/")!
//		}
//		let baseURL = NSURL(string: "http://bbtfr.github.io/MerusutoChristina/data/")!
//        let baseURL = NSURL(string: "http://merusuto.coding.me/data/")!
		return baseURL.URLByAppendingPathComponent(key as String)
	}

	class func loadDataFromURL(url: NSURL, completion: (data: NSData?, error: NSError?) -> Void) {
		let session = NSURLSession.sharedSession()

		// Use NSURLSession to get data from an NSURL
		let loadDataTask = session.dataTaskWithURL(url, completionHandler:
				{ (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
					if let responseError = error {
						completion(data: nil, error: responseError)
					} else if let httpResponse = response as? NSHTTPURLResponse {
						if httpResponse.statusCode != 200 {
							let statusError = NSError(domain: "com.bbtfr", code: httpResponse.statusCode,
								userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value."])
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
