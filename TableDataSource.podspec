Pod::Spec.new do |spec|
  spec.name = 'TableDataSource'
  spec.version = '1.0.0'
  spec.license = 'MIT'
  
  spec.summary = 'Working with UITableView with flexible and easy way. (Auto animation supported)'

  spec.author = {'Aleksey Garbarev' => 'alex.garbarev@gmail.com'}
  spec.source = {:git => 'https://github.com/alexgarbarev/TableDataSource.git', :tag => spec.version.to_s}

  spec.ios.deployment_target = '5.0'

  spec.source_files = 'Sources/**/*.{h,m}'
 
  spec.requires_arc = true

  spec.homepage = 'https://github.com/alexgarbarev/TableDataSource'
end 
