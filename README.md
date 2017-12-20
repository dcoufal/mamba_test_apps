# mamba Carthage and Cocoapods Test Apps

This is a set of apps I use to test new releases of [mamba](https://github.com/Comcast/mamba) using [Carthage](https://github.com/Carthage/Carthage) and [Cocoapods](http://cocoapods.org) on both iOS and tvOS.

## Carthage

For each project:

Set the Cartfile version to the version you with to test:

```
github "Comcast/mamba.git" == 1.0.0
```

OR

```
github "Comcast/mamba.git" "<branch_name>"
```

if testing a branch.

From a command line in the project dir:

```
carthage update
```

You should be able to open the .xcodeproj at this point, and build and run the project. If you get a green `TESTS: PASSED` label, everything was good.

## Cocoapods

For each project:

Set the PodFile to the version you want to test:

```
use_frameworks!

target 'mamba_ios_cocoapod_test' do
  pod 'mamba', '1.0.0'
end

target 'mamba_ios_cocoapod_testTests' do  
  pod 'mamba', '1.0.0'
end
```

OR

```
use_frameworks!

target 'mamba_ios_cocoapod_test' do
  pod 'mamba', :git => 'https://github.com/Comcast/mamba.git', :branch => '<branch_name>'
end

target 'mamba_ios_cocoapod_testTests' do  
  pod 'mamba', :git => 'https://github.com/Comcast/mamba.git', :branch => '<branch_name>'
end
```

if testing a branch.

From a command line in the project dir:

```
pod install
```

You should be able to open the newly created .xcworkspace at this point, and build and run the project. If you get a green `TESTS: PASSED` label, everything was good.
