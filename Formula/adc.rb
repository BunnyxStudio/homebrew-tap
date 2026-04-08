class Adc < Formula
  desc "App Store Connect Data CLI for official Apple reporting data"
  homepage "https://github.com/BunnyxStudio/app-store-connect-data-cli"
  url "https://github.com/BunnyxStudio/app-store-connect-data-cli/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "9355368c55782529476d63db1c0d6c913f8f47f81739d2d80a2f6d3babaf13a6"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://github.com/BunnyxStudio/homebrew-tap/releases/download/adc-0.1.6_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "6dd2e01821d0c9a6e4e27827dbd7b32844a58ac28cab05327fe507b1a37c5af9"
    sha256 cellar: :any_skip_relocation, sequoia:     "acef493d22f98e8cd6ab0181fb9948a7fa86e795562a8303bf7f8d1b4f4b00c2"
  end
  depends_on :macos

  resource "swift-argument-parser" do
    url "https://github.com/apple/swift-argument-parser/archive/refs/tags/1.5.0.tar.gz"
    sha256 "946a4cf7bdd2e4f0f8b82864c56332238ba3f0a929c6d1a15f55affdb10634e6"
  end

  def install
    resource("swift-argument-parser").stage buildpath/"vendor/swift-argument-parser"

    inreplace "Package.swift",
      '.package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0")',
      '.package(path: "vendor/swift-argument-parser")'

    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "adc"
    bin.install ".build/release/adc"
  end

  test do
    (testpath/".app-connect-data-cli").mkpath
    output = shell_output("#{bin}/adc capabilities list --output json")
    assert_match "\"sales\"", output
    assert_match "\"analytics\"", output
  end
end
