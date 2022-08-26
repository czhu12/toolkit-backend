module Rolified
  extend ActiveSupport::Concern

  included do
    # Cast roles to/from booleans
    self::ROLES.each do |role|
      scope role, -> { where("roles @> ?", {role => true}.to_json) }

      define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
      define_method(:"#{role}?") { send(role) }
    end

    # Store the roles in the roles json column and cast to booleans
    store_accessor :roles, *self::ROLES

    # You can use Postgres' jsonb operators to query the roles jsonb column
    # https://www.postgresql.org/docs/current/functions-json.html
    #
    # Query where roles contains:
    # scope :managers, -> { where("roles @> ?", {manager: true}.to_json) }
  end

  def active_roles
    self.class::ROLES.select { |role| send(:"#{role}?") }.compact
  end
end
