#
# Be sure to run `pod lib lint SACollectionViewVerticalScalingFlowLayout.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SACollectionViewVerticalScalingFlowLayout"
  s.version          = "3.0.0"
  s.summary          = "SACollectionViewVerticalScalingFlowLayout applies scaling up or down effect to appearing or disappearing cells."
  s.homepage         = "https://github.com/marty-suzuki/SACollectionViewVerticalScalingFlowLayout"
  s.license          = 'MIT'
  s.author           = { "Taiki Suzuki" => "s1180183@gmail.com" }
  s.source           = { :git => "https://github.com/marty-suzuki/SACollectionViewVerticalScalingFlowLayout.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/marty_suzuki'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SACollectionViewVerticalScalingFlowLayout/*.swift'
end
