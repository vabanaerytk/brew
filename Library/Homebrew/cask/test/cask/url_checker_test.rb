require "test_helper"

describe Hbc::UrlChecker do
  describe "request processing" do
    it "adds an error if response is empty" do
      cask = Hbc.load("basic-cask")
      Hbc::FakeFetcher.fake_response_for(cask.url, "")
      checker = Hbc::UrlChecker.new(cask, Hbc::FakeFetcher)
      checker.run
      checker.errors.must_include "timeout while requesting #{cask.url}"
    end

    it "properly populates the response code and headers from an http response" do
      cask = Hbc.load("basic-cask")

      Hbc::FakeFetcher.fake_response_for(cask.url, <<-EOS.undent)
        HTTP/1.1 200 OK
        Content-Type: application/x-apple-diskimage
        ETag: "b4208f3e84967be4b078ecaa03fba941"
        Content-Length: 23726161
        Last-Modified: Sun, 12 Aug 2012 21:17:21 GMT
      EOS

      checker = Hbc::UrlChecker.new(cask, Hbc::FakeFetcher)
      checker.run
      checker.response_status.must_equal "HTTP/1.1 200 OK"
      checker.headers.must_equal("Content-Type"   => "application/x-apple-diskimage",
                                 "ETag"           => '"b4208f3e84967be4b078ecaa03fba941"',
                                 "Content-Length" => "23726161",
                                 "Last-Modified"  => "Sun, 12 Aug 2012 21:17:21 GMT")
    end
  end
end
