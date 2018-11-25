import Foundation
import PathKit
import xcodeproj

struct ConfigWriter {
	let configPath: Path
	let configurations: XCConfigurationList
	
	func write() {
		var settings: [String: BuildSetting] = [:]
		
		configurations.buildConfigurations.forEach { buildConfiguration in
			let configName = buildConfiguration.name
			buildConfiguration.buildSettings.forEach { settingName, settingValue in
				var setting = settings[settingName] ?? BuildSetting(name: settingName)
				setting.addValue(configuration: configName, value: settingValue)
				settings[settingName] = setting
			}
		}
		
		let buildSettings = settings.reduce([:]) { (result, nextValue) -> [String: Any] in
			let (_, setting) = nextValue as (String, BuildSetting)
			let xcconfigSettings = setting.xcconfigs()
			var nextResult = result
			xcconfigSettings.forEach { nextResult[$0.key] = $0.value }
			return nextResult
		}
		
		print("build settings: \(buildSettings.count)")
		
		let xcconfig = XCConfig(includes: [], buildSettings: buildSettings)
		try! xcconfig.write(path: configPath, override: true)
	}
}

private struct BuildSetting {
	private let prefix = "$("
	private let suffix = "_$(CONFIGURATION))"

	let name: String
	var values: [String: Any]
	
	init(name: String, values: [String: Any] = [:]) {
		self.name = name
		self.values = values
	}
	
	mutating func addValue(configuration: String, value: Any) {
		values[configuration] = value
	}
	
	func xcconfigs() -> [String: Any] {
		switch values.count {
		case 0:
			return [:]
		case 1:
			return [name: values.first!.value]
		default:
			if singleValue() {
				return [name: values.first!.value]
			}
			
			var result: [String: Any] = [name: "\(prefix)\(name)\(suffix)"]
			values.forEach { configName, value in
				result["\(name)_\(configName)"] = value
			}
			return result
		}
	}
	
	private func singleValue() -> Bool {
		let stringValues = values.values.compactMap { "\($0)" }
		return Set(stringValues).count == 1
	}
}

