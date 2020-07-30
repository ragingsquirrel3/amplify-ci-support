require 'spec_helper'
require 'helper/key_value'

SPEC_CONTENT_PRE = <<~EOS
  # Version definitions
  $AMPLIFY_VERSION = '1.0.4'
  $AMPLIFY_RELEASE_TAG = "v#{$AMPLIFY_VERSION}"
EOS

SPEC_CONTENT_POST = <<~EOS
  # Version definitions
  $AMPLIFY_VERSION = '2.0.0'
  $AMPLIFY_RELEASE_TAG = "v#{$AMPLIFY_VERSION}"
EOS

SWIFT_CONTENT_PRE = <<~EOS
  override public class func baseUserAgent() -> String! {
    //TODO: Retrieve this version from a centralized location:
    let version = "1.0.4"
    let sdkName = "amplify-iOS"
    return "\(sdkName)/\(version)"
  }
EOS

SWIFT_CONTENT_POST = <<~EOS
  override public class func baseUserAgent() -> String! {
    //TODO: Retrieve this version from a centralized location:
    let version = "2.0.0"
    let sdkName = "amplify-iOS"
    return "\(sdkName)/\(version)"
  }
EOS

GRADLE_CONTENT_PRE = <<~EOS
# gradle.properties file format
org.gradle.parallel=true

GROUP=com.amplifyframework
VERSION_NAME=main
VERSION_CODE=1

OTHER_SETTING=9999
EOS

GRADLE_CONTENT_POST = <<~EOS
# gradle.properties file format
org.gradle.parallel=true

GROUP=com.amplifyframework
VERSION_NAME=2.0.0
VERSION_CODE=1

OTHER_SETTING=9999
EOS

describe KeyValue do
  let(:spec_key_value) { KeyValue.new('AMPLIFY_VERSION') }
  let(:swift_key_value) { KeyValue.new('version') }
  let(:wrong_key_value) { KeyValue.new('HOLY_GRAIL') }
  let(:android_key_value) { KeyValue.new('VERSION_NAME') }

  describe '.match()' do
    example do
      result = spec_key_value.match(SPEC_CONTENT_PRE).to_s
      expect(result).to eq('1.0.4')
    end

    example do
      result = swift_key_value.match(SWIFT_CONTENT_PRE).to_s
      expect(result).to eq('1.0.4')
    end

    example do
      result = wrong_key_value.match(SPEC_CONTENT_PRE).to_s
      expect(result).to eq('')
    end

    example do
      result = android_key_value.match(GRADLE_CONTENT_PRE).to_s
      expect(result).to eq('main')
    end
  end

  describe '.replace()' do
    example do
      result = spec_key_value.replace(file_contents: SPEC_CONTENT_PRE, value: '2.0.0').to_s
      expect(result).to eq(SPEC_CONTENT_POST)
    end

    example do
      result = swift_key_value.replace(file_contents: SWIFT_CONTENT_PRE, value: '2.0.0').to_s
      expect(result).to eq(SWIFT_CONTENT_POST)
    end

    example do
      result = android_key_value.replace(file_contents: GRADLE_CONTENT_PRE, value: '2.0.0').to_s
      expect(result).to eq(GRADLE_CONTENT_POST)
    end
  end
end
