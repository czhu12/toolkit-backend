class ApiClientGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :attributes, type: :array, default: [], banner: "method[:type] method[:type]"

  class_option :url, type: :string, default: "https://api.example.com", desc: "API Base URL"

  class ApiMethod
    METHOD_TYPES = [
      :index,
      :show,
      :create,
      :update,
      :destroy
      # :resources TODO! (gen all 5 the resources)
    ]
    METHOD_TO_VERB = {
      index: :get,
      show: :get,
      create: :post,
      update: :put,
      destroy: :delete
    }

    def self.parse(attr)
      return attr if attr.is_a?(ApiMethod)

      name, type = attr.split(":")
      if type.nil?
        type = :index
      end

      type = type&.to_sym

      if !valid_type?(type)
        raise "Invalid API method type: #{type}"
      end

      new(name, type)
    end

    def self.valid_type?(type)
      METHOD_TYPES.include?(type)
    end

    attr_accessor :name, :type

    def initialize(name, type)
      @name = name
      @type = type
    end

    def method_name
      prefix = {
        index: "list",
        show: "get",
        create: "create",
        update: "update",
        destroy: "delete"
      }[type]

      "#{prefix}_#{name.underscore}".to_sym
    end

    def verb
      METHOD_TO_VERB[type]
    end

    METHOD_TYPES.each do |method_type|
      define_method("#{method_type}?") do
        type == method_type
      end
    end
  end

  def copy_templates
    template "client.rb", "app/clients/#{file_path}_client.rb"
    template "client_test.rb", "test/clients/#{file_path}_client_test.rb"
  end

  # Note: This overrides the built-in parse_attributes! method from Rails::Generators::NamedBase
  # Instead of retruning instances of GeneratedAttributes (which makes sense for models)
  # we want to return instances of ApiMethod.
  def parse_attributes!
    self.attributes = (attributes || []).map do |attr|
      ApiMethod.parse(attr)
    end
  end

  def url
    options[:url]
  end
end
