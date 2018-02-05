#
# Be sure to run `pod lib lint ALCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name         =  'ALCalendar'
s.version      =  '1.0'
s.license      =  { :type => 'Apache 2.0', :file => 'LICENSE' }
s.homepage     =  'https://github.com/Applandeo/Calendar-View/'
s.authors      =  { 'Sebastian' => 'sebastian.grabinski@applandeo.com' }
s.source       =  { :git => 'https://github.com/Applandeo/Calendar-View.git', :tag => 1.0 }
s.source_files = 'Source/*.swift'

s.ios.deployment_target  = '10.0'

s.summary      =  'Just a simple podspec, no working code.'
s.description  =  'Just a simple podspec for 2 files of Objective-C.'


end









