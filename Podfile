# Uncomment the next line to define a global platform for your project
 platform :ios, '11.4'

target 'Book of my own adventure' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Book of my own adventure
    	
    pod'SwiftReorder', '~> 3.0'
    pod 'RealmSwift', '3.7.4'
    pod 'MCSwipeTableViewCell','2.1.4'
    pod 'BubbleTransition'
    pod 'LTMorphingLabel' 

post_install do |installer|
    installer.pods_project.targets.each do |target|
target.build_configurations.each do |configuration|
    configuration.build_settings['SWIFT_VERSION'] = "4.0"

end

end

end

end

