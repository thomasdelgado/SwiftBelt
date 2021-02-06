//
//
//  
//
//  Created by Thomas Delgado on 04/02/21.
//

import StoreKit

/**
 based on best practices by apple
 link: https://developer.apple.com/documentation/storekit/skstorereviewcontroller/requesting_app_store_reviews
 */
@available(iOS 10.3, *)
public class StoreReviewManager {
    public static let shared = StoreReviewManager()
    var multipleTaskCount = 5

    private var taskCount: Int {
        return UserDefaults.standard.integer(forKey: UserDefaultsKeys.processCompletedCountKey)
    }

    private var currentVersion: String? {
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
        else {
            debugPrint("Expected to find a bundle version in the info dictionary")
            return nil
        }
        return currentVersion
    }

    private var lastVersionPromptedForReview: String {
        let lastVersion = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
        return lastVersion ?? ""
    }

    private func incrementTaskCount() {
        let count = taskCount + 1
        UserDefaults.standard.set(count, forKey: UserDefaultsKeys.processCompletedCountKey)
    }

    private func setVersionPromptedForReview(_ version: String) {
        UserDefaults.standard.set(version, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
    }

    /**
     these functions should be called every time the user finishes a main process.
     the class should handle when is the best time to prompt the review, since it can be called only 3 times per year
    */
    public func finishTask() {
        incrementTaskCount()
        if shouldShowReview() {
            showStoreReview()
        }
    }

    /**
     Method variant for UIKit
     */
    public func finishTask(_ viewController: UIViewController) {
        incrementTaskCount()
        debugPrint("Process completed \(taskCount) time(s)")

        if shouldShowReview() {
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {[weak self] in
                if UINavigationController.topViewController() == viewController {
                    self?.showStoreReview()
                }
            }
        }
    }

    // Has the process been completed several times and the user has not already been prompted for this version?
    private func shouldShowReview() -> Bool {
        guard let currentVersion = currentVersion else { return false }
        return taskCount % multipleTaskCount == 0 && currentVersion != lastVersionPromptedForReview
    }

    private func showStoreReview() {
        guard let currentVersion = currentVersion else { return }
        SKStoreReviewController.requestReview()
        setVersionPromptedForReview(currentVersion)
    }
}

private struct UserDefaultsKeys {
    static let processCompletedCountKey = "processCompletedCountKey"
    static let lastVersionPromptedForReviewKey = "lastVersionPromptedForReviewKey"
}
