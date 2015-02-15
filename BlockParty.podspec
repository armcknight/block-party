Pod::Spec.new do |s|
  s.name         = "BlockParty"
  s.version      = "1.0.0"
  s.summary      = "Lego of the delegate pattern. Blocks FTW!."
  s.description  = <<-DESC
			Tie together the logic for an operation and associated callback(s). Want to keep the logic of a navigation controller push and what should happen before and/or after together in the same spot, instead of spread across methods? Now you can!
                   DESC
  s.homepage     = "https://github.com/sixstringtheory/block-party"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Andrew McKnight" => "amcknight2718@gmail.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/sixstringtheory/block-party.git", :tag => "1.0.0" }
  s.source_files = "BlockParty/**/*.{h,m}"
  s.requires_arc = true
end
