require "test_helper"

class ApplicationClientTest < ActiveSupport::TestCase
  setup do
    @client = ApplicationClient.new(token: "test")
  end

  test "authorization header" do
    stub_request(:get, "https://example.org/").with(headers: {"Authorization" => "Bearer test"})
    @client.send(:get, "/")
  end

  test "get" do
    stub_request(:get, "https://example.org/test")
    @client.send(:get, "/test")
  end

  test "get with query params" do
    stub_request(:get, "https://example.org/test").with(query: {"foo" => "bar"})
    @client.send(:get, "/test", query: {foo: "bar"})
  end

  test "post" do
    stub_request(:post, "https://example.org/test").with(body: {"foo" => {"bar" => "baz"}}.to_json)
    @client.send(:post, "/test", body: {foo: {bar: "baz"}})
  end

  test "post with string body" do
    stub_request(:post, "https://example.org/test").with(body: "foo")
    @client.send(:post, "/test", body: "foo")
  end

  test "post with custom content-type" do
    headers = {"Content-Type" => "application/x-www-form-urlencoded"}
    stub_request(:post, "https://example.org/test").with(body: {"foo" => "bar"}.to_json, headers: headers)
    @client.send(:post, "/test", body: {foo: "bar"}, headers: headers)
  end

  test "patch" do
    stub_request(:patch, "https://example.org/test").with(body: {"foo" => "bar"}.to_json)
    @client.send(:patch, "/test", body: {foo: "bar"})
  end

  test "put" do
    stub_request(:put, "https://example.org/test").with(body: {"foo" => "bar"}.to_json)
    @client.send(:put, "/test", body: {foo: "bar"})
  end

  test "delete" do
    stub_request(:delete, "https://example.org/test")
    @client.send(:delete, "/test")
  end

  test "parse body" do
    stub_request(:get, "https://example.org/test").to_return(body: {"foo" => "bar"}.to_json)
    result = @client.send(:get, "/test")
    assert_equal "bar", result.foo
  end

  test "unauthorized" do
    stub_request(:get, "https://example.org/test").to_return(status: 401)
    assert_raises ApplicationClient::Unauthorized do
      @client.send(:get, "/test")
    end
  end

  test "forbidden" do
    stub_request(:get, "https://example.org/test").to_return(status: 403)
    assert_raises ApplicationClient::Forbidden do
      @client.send(:get, "/test")
    end
  end

  test "not found" do
    stub_request(:get, "https://example.org/test").to_return(status: 404)
    assert_raises ApplicationClient::NotFound do
      @client.send(:get, "/test")
    end
  end

  test "rate limit" do
    stub_request(:get, "https://example.org/test").to_return(status: 429)
    assert_raises ApplicationClient::RateLimit do
      @client.send(:get, "/test")
    end
  end

  test "internal error" do
    stub_request(:get, "https://example.org/test").to_return(status: 500)
    assert_raises ApplicationClient::InternalError do
      @client.send(:get, "/test")
    end
  end

  test "other error" do
    stub_request(:get, "https://example.org/test").to_return(status: 418)
    assert_raises ApplicationClient::Error do
      @client.send(:get, "/test")
    end
  end

  class CustomClientTest < ActiveSupport::TestCase
    class TestApiClient < ApplicationClient
      BASE_URI = "https://test.example.org"

      def root
        get "/"
      end

      def content_type
        "application/xml"
      end
    end

    test "get" do
      stub_request(:get, "https://test.example.org/")
      TestApiClient.new(token: "test").root
    end

    test "content type" do
      stub_request(:get, "https://test.example.org/").with(headers: {"Accept" => "application/xml"})
      TestApiClient.new(token: "test").root
    end

    test "other error" do
      stub_request(:get, "https://test.example.org/").to_return(status: 418)
      assert_raises TestApiClient::Error do
        TestApiClient.new(token: "test").root
      end
    end
  end
end
