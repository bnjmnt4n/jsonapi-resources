require 'active_support/callbacks'

module JSONAPI
  module Coercion
    def self.prepended(base)
      class << base
        prepend(ClassMethods)
      end
    end

    module ClassMethods

      def verify_filter(filter, raw, context = nil)
        verified_filter = super
        filter_type = _allowed_filters.fetch(filter, Hash.new)[:type]
        filter_name = verified_filter[0]
        if filter_type
          wrapped_filters = if verified_filter[1].empty? # nil or empty array
                              [nil]
                            else
                              Array.wrap(verified_filter[1])
                            end
          coerced_values = wrapped_filters.map do |val|
            begin
              if val.nil?
                if _allowed_filters.fetch(filter, Hash.new).fetch(:allow_nil, false)
                  nil
                else
                  raise TypeError
                end
              else
                coerce(val, filter_type)
              end
            rescue TypeError => _e
              raise JSONAPI::Exceptions::InvalidFilterValue.new(filter_name, val)
            end
          end
          [filter_name, coerced_values]
        else
          verified_filter
        end
      end

      private

      def coerce(val, type)
        begin
          return Integer(val) if type == :integer
          return Float(val) if type == :float
          return String(val) if type == :string
          return Date.parse(val) if type == :date
          return Time.parse(val) if type == :time
          return DateTime.parse(val) if type == :date_time
          return (/^(false|f|no|n|0)$/i === val.to_s ? false : (/^(true|t|yes|y|1)$/i === val.to_s ? true : (raise ArgumentError))) if type == :boolean
          return ArgumentError
        rescue ArgumentError => _e
          raise TypeError
        end
      end
    end
  end
end
