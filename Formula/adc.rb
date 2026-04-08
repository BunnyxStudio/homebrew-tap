class Adc < Formula
  desc "App Store Connect Data CLI for official Apple reporting data"
  homepage "https://github.com/BunnyxStudio/app-store-connect-data-cli"
  url "https://github.com/BunnyxStudio/app-store-connect-data-cli/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "b2808cbe597fec4849dc32e19ae15093e805c1dcc5f1b9a0dbef051d7dafc7eb"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://github.com/BunnyxStudio/homebrew-tap/releases/download/adc-0.1.8_1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "a5e38d9f4a6d65926a189b07ca2047eb1fbddbc9488f31455b980fdb844aa98b"
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
