#
# Be sure to run `pod lib lint LinKingGameChSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LinKingGameChSDK'
  s.version          = '0.1.7'
  s.summary          = 'A short description of LinKingGameChSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/linkinggame/LinKingGameChSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'leon' => 'dml630@163.com' }
  s.source           = { :git => 'https://github.com/linkinggame/LinKingGameChSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  
  s.static_framework = true

  s.source_files = 'LinKingGameChSDK/Classes/**/*.*'
  s.resources = "LinKingGameChSDK/Assets/*.*"

  s.dependency 'SDWebImage', '~> 5.0.0'
  s.dependency 'IQKeyboardManager', '~> 6.5.5'
  s.dependency 'TPKeyboardAvoiding', '~> 1.3.4'
  s.dependency 'TZImagePickerController', '~> 3.5.1'
  s.dependency 'Toast', '~> 4.0.0'
  s.dependency 'Beta-AppsFlyerFramework', '~> 6.0.2.174'
  s.dependency 'MQTTClient2', '~> 0.15.6'
  s.dependency 'AFNetworking', '~> 4.0.1'
  
#  s.dependency  'TPNiOS','6.4.12'
#  s.dependency  'TPNTTSDKAdapter','6.4.12'
#  s.dependency  'TPNMintegralSDKAdapter','6.4.12'
#  s.dependency  'TPNGDTSDKAdapter','6.4.12'
#  # 穿山甲
#  s.dependency 'Ads-CN','6.4.2.7' #  pod 'Ads-CN', '~> 6.4.3.7'
#  # MintegralAdSDK
#  s.dependency 'MintegralAdSDK' ,'7.7.3' # 7.7.3
#  # 优良汇
#  s.dependency 'GDTMobSDK', '4.15.10' # 4.15.10

#  s.dependency 'MintegralAdSDK/RewardVideoAd','7.7.3'
#  s.dependency 'MintegralAdSDK/BidRewardVideoAd','7.7.3'
#  s.dependency 'MintegralAdSDK/BidInterstitialVideoAd','7.7.3'
#  s.dependency 'MintegralAdSDK/InterstitialVideoAd','7.7.3'
#  s.dependency 'MintegralAdSDK/NewInterstitialAd','7.7.3'
#  s.dependency 'MintegralAdSDK/BannerAd' ,'7.7.3'
#  s.dependency 'MintegralAdSDK/BidBannerAd','7.7.3'
#  s.dependency 'MintegralAdSDK/SplashAd','7.7.3'
#  s.dependency 'MintegralAdSDK/NativeAdvancedAd','7.7.3'

     #Tapon引入
     s.dependency 'AnyThinkiOS','6.4.91'
     s.dependency 'AnyThinkTTSDKAdapter','6.4.91.2'
    #  s.dependency 'AnyThinkMintegralSDKAdapter','6.4.91.2'
     s.dependency 'AnyThinkGDTSDKAdapter','6.4.91.1'

     # 穿山甲
     s.dependency 'Ads-CN-Beta','7.1.0.1' #  pod 'Ads-CN', '~> 6.4.3.7'
     # MintegralAdSDK
     s.dependency 'MintegralAdSDK' ,'7.7.9' # 7.7.9
     # 优良汇 腾讯广告
     s.dependency 'GDTMobSDK', '4.15.50' # 4.15.10

     # 引力引擎
     s.dependency 'GravityEngineSDK','5.0.11'

    #  s.dependency 'MintegralAdSDK/RewardVideoAd','7.7.9'
    #  s.dependency 'MintegralAdSDK/BidRewardVideoAd','7.7.9'
    #  s.dependency 'MintegralAdSDK/BidInterstitialVideoAd','7.7.9'
    #  s.dependency 'MintegralAdSDK/InterstitialVideoAd','7.7.9'
    #  s.dependency 'MintegralAdSDK/NewInterstitialAd','7.7.9'
    #  s.dependency 'MintegralAdSDK/BannerAd' ,'7.7.9'
    #  s.dependency 'MintegralAdSDK/BidBannerAd','7.7.9'
    #  s.dependency 'MintegralAdSDK/SplashAd','7.7.9'
    #  s.dependency 'MintegralAdSDK/NativeAdvancedAd','7.7.9'

  

end
