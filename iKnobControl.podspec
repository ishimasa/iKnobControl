

Pod::Spec.new do |s|

  s.name         = "iKnobControl"
  s.version      = "1.0.0"
  s.summary      = "A knob control like the UISlider, but in a circular form."


  s.description  = "The knob control is a completely customizable widget that can be used in any iOS app. It also plays a little victory fanfare."

  s.homepage     = "http://raywenderlich.com"

  s.license      = "MIT"

  s.author             = { "M.Ishimoto" => "ishitra777@gmail.com" }

  s.platform     = :ios, "11.0"

  s.source       = { :git => "https://github.com/ishimasa/iKnobControl", :tag => "1.0.0" }

  s.source_files = "iKnobControl"

  s.swift_version = "4.1"

end
