import Foundation
import PathKit
import xcodeproj

// first arg is the executable name `swift xcconfig-gen foo.xcodeproj`
guard CommandLine.argc == 2 else {
	print("Expected xcodeproj as argument")
	exit(1)
}

var projectPath = Path(CommandLine.arguments[1])
if !projectPath.exists {
	projectPath = Path.current + projectPath
}

guard projectPath.exists else {
	print("No project found at \(projectPath)")
	exit(2)
}

let projectFolder = projectPath.parent()
let xcconfigFolder = projectFolder + Path("xcconfigs")

if !xcconfigFolder.exists {
	try! xcconfigFolder.mkdir()
}

let project = try! XcodeProj(path: projectPath)
let projectXCConfigPath = xcconfigFolder + Path("Project.xcconfig")
if let projectBuildConfigurations = project.pbxproj.projects.first!.buildConfigurationList {
	ConfigWriter(configPath: projectXCConfigPath, configurations: projectBuildConfigurations).write()
}

let targets = project.pbxproj.nativeTargets
targets.forEach { target in
	guard let configurations = target.buildConfigurationList else { return }
	let configPath = xcconfigFolder + Path("\(target.name).xcconfig")
	ConfigWriter(configPath: configPath, configurations: configurations).write()
}
