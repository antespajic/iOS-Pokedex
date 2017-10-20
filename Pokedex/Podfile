# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
# ignore all warnings from all pods
inhibit_all_warnings!

# TODO: Remove this after all pods are converted to swift 4
def swift4_overrides
    pod 'RxSwift', git: 'https://github.com/ReactiveX/RxSwift.git', branch:'swift4.0'
    pod 'RxCocoa', git: 'https://github.com/ReactiveX/RxSwift.git', branch:'swift4.0'
    pod 'Alamofire', git: 'https://github.com/Alamofire/Alamofire.git', branch: 'swift4'
    pod 'PKHUD', git: 'https://github.com/pkluz/PKHUD.git', branch: 'release/swift4'
    pod 'Kingfisher', git: 'https://github.com/onevcat/Kingfisher.git', branch:'swift4'
end

target 'Pokedex' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Pokedex
  swift4_overrides
  pod 'CodableAlamofire', :git => 'https://github.com/Otbivnoe/CodableAlamofire.git'
  
  target 'PokedexTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PokedexUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
