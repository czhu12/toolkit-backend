# API Clients

This directory is for API clients.

Jumpstart Pro includes an API client for working with JSON APIs. It handles several things for you:

* The Authorization header with API token
* Content-Type JSON header
* JSON response bodies parsed automatically
* Raises errors on 4XX or 5XX responses

Why would you need this?
Often times Rubygems for APIs fall out of date or go unmaintained. Managing your own integration allows you to only implement the endpoints you need and easily maintain your integration.

### Usage

Use the generator to create a new API client:

```bash
rails g api_client Sendfox
```

This will generate `app/clients/sendfox_client.rb`

Edit the API client file to add the base URI and define your API endpoints

Here are some example API endpoints for the Sendfox API implemented with the API client:

```ruby
class SendfoxClient < ApplicationClient
  BASE_URI = "https://api.sendfox.com"

  def me
    get("/me")
  end

  def lists
    get("/lists")
  end

  def list(id)
    get("/lists/#{id}")
  end

  def create_list(name:)
    post("/lists", name: name)
  end

  def remove_contact(list_id:, contact_id:)
    delete("/lists/#{list_id}/contacts/#{contact_id}")
  end
end
```

### ApplicationClient

`ApplicationClient` is the base class and defines helpers for making HTTP requests and handles authorization headers and parsing JSON responses.

#### HTTP methods

There are helper methods for the standard HTTP request types for APIs:

`get`
`post`
`patch`
`put`
`delete`

#### Overrides

You can override the methods to match the APIs you're integrating with.

For example, you can override the default headers, query params, and how responses are parsed. This example could be used to connect to an XML API that uses a query parameter to authenticate.

```ruby
class XmlExampleClient < ApplicationClient
  def default_headers
    {
      "Content-Type" => "application/xml"
    }
  end

  def default_query_params
    {
      token: token
    }
  end

  def parse_response(response)
    Nokogiri::XML(response.body)
  end
end
```
