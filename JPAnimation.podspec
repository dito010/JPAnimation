Pod::Spec.new do |s|
  s.name         = "JPAnimation"
  s.version      = "0.1"
  s.summary      = "模仿 Airbnb 首页过渡动画"
  s.homepage     = "https://github.com/Chris-Pan/JPAnimation"
  s.license      = "MIT"
  s.author       = { "NewPan" => "13246884282@163.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => 'https://github.com/Chris-Pan/JPAnimation.git', :tag => s.version }
  s.source_files = 'JPAnimationDemo/JPAnimationDemo/JPAnimationTool.{h,m}'

  s.dependency 'JPNavigationController', '2.0'
end
