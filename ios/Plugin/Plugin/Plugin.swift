import Foundation
import Capacitor
import GoogleMobileAds

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(AdMob)
public class AdMob: CAPPlugin {

    var bannerView: GADBannerView!

    @objc func initialize(_ call: CAPPluginCall) {
        let appId = call.getString("appId") ?? "ca-app-pub-6564742920318187~7217030993"
        call.success([
            "value": appId
            ])
    }

    @objc func showBanner(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let adId = call.getString("adId") ?? "ca-app-pub-3940256099942544/6300978111"
            let adSize = call.getString("adSize") ?? "SMART_BANNER"
            let adPosition = call.getString("position") ?? "BOTTOM_CENTER"
            let adMargin = call.getString("margin") ?? "0"
            var bannerSize = kGADAdSizeBanner

            switch (adSize) {
            case "BANNER":
                bannerSize = kGADAdSizeBanner
                break;
            case "FLUID":
                bannerSize = kGADAdSizeSmartBannerPortrait
                break;
            case "FULL_BANNER":
                bannerSize = kGADAdSizeFullBanner
                break;
            case "LARGE_BANNER":
                bannerSize = kGADAdSizeLargeBanner
                break;
            case "LEADERBOARD":
                bannerSize = kGADAdSizeLeaderboard
                break;
            case "MEDIUM_RECTANGLE":
                bannerSize = kGADAdSizeMediumRectangle
                break;
            default:
                bannerSize = kGADAdSizeBanner
                break;
            }

            self.bannerView = GADBannerView(adSize: bannerSize)
            self.addBannerViewToView(self.bannerView, adPosition, adMargin)
            self.bannerView.translatesAutoresizingMaskIntoConstraints = false
            self.bannerView.adUnitID = adId
            self.bannerView.rootViewController = UIApplication.shared.keyWindow?.rootViewController
            self.bannerView.load(GADRequest())

            call.success([
                "value": true
                ])
        }
    }

    @objc func hideBanner(_ call: CAPPluginCall) {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            if let subView = rootViewController.view.viewWithTag(2743243288699) {
                NSLog("AdMob: find subView")
                subView.isHidden = true;
            }
        }
    }

    @objc func resumeBanner(_ call: CAPPluginCall) {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            if let subView = rootViewController.view.viewWithTag(2743243288699) {
                NSLog("AdMob: find subView")
                subView.isHidden = false;
            }
        }
    }

    @objc func removeBanner(_ call: CAPPluginCall) {
        removeBannerViewToView()
    }

    private func addBannerViewToView(_ bannerView: GADBannerView, _ adPosition: String, _ Margin: String) {
        removeBannerViewToView()
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            NSLog("AdMob: rendering rootView")
            var toItem = rootViewController.bottomLayoutGuide
            var adMargin = Int(Margin)!

            switch (adPosition) {
            case "TOP_CENTER":
                toItem = rootViewController.topLayoutGuide
                break;
            case "CENTER":
                // todo: position center
                toItem = rootViewController.bottomLayoutGuide
                adMargin = adMargin * -1
                break;
            default:
                toItem = rootViewController.bottomLayoutGuide
                adMargin = adMargin * -1
                break;
            }
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            bannerView.tag = 2743243288699 // rand
            rootViewController.view.addSubview(bannerView)
            rootViewController.view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: toItem,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: CGFloat(adMargin)),
                 NSLayoutConstraint(item: bannerView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: rootViewController.view,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
                ])
        }
    }

    private func removeBannerViewToView() {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            if let subView = rootViewController.view.viewWithTag(2743243288699) {
                NSLog("AdMob: find subView")
                subView.removeFromSuperview()
            }
        }
    }
}
