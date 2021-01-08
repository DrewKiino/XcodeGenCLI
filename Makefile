build:
	@swift build -c release
	@cp -f .build/release/XcodeGenCLI /usr/local/bin/xcgen

generate:
	@swift package generate-xcodeproj