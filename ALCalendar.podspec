#
# Be sure to run `pod lib lint ALCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ALCalendar'
  s.version          = '1.0'
  s.summary          = 'Simple customizable calendar writen in Swift'
  s.description      = 'Simple visual calendar writen in Swift(4.0). '

  s.homepage         = 'https://github.com/Applandeo/Calendar-View/'
  s.screenshots     = 'https://user-images.githubusercontent.com/32479017/34562328-2b72e0bc-f14e-11e7-9aab-7f929f6906b0.png',
    'https://user-images.githubusercontent.com/32479017/34562273-dcc0d686-f14d-11e7-9040-27263897320c.png'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
s.author           = { 'Sebastian Grabinski' => 'sebastian.grabinski@applandeo.com'}
  s.source           = { :git => 'https://github.com/Applandeo/Calendar-View.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.facebook.com/applandeo/'
  s.ios.deployment_target = '10.0'
    s.source_files = 'ALCalendar/*'


#  Be sure to run `pod spec lint ALCalendar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

end
