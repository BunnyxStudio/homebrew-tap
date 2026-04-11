class Adc < Formula
  desc "App Store Connect Data CLI for official Apple reporting data"
  homepage "https://github.com/BunnyxStudio/app-store-connect-data-cli"
  url "https://github.com/BunnyxStudio/app-store-connect-data-cli/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "3d50a2cb27c2e2f33ff1da69969ac2837146566c827b49d49d5b5ee48a90b31d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/BunnyxStudio/homebrew-tap/releases/download/adc-0.1.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ab1177d20cd68de5f28a31abc701340840c578a0b208aa75ef27536da5df7ff4"
    sha256 cellar: :any_skip_relocation, sequoia:     "6404892abaa359a413f8d2d7f8dbe6c1a3a077b52f5f10be189ec90198f1a4b9"
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
