module JSON
  module API
    module Errors
      class Error < RuntimeError; end

      class InvalidResource < Error
        attr_accessor :resource
        def initialize(resource)
          @resource = resource
        end
      end

      class InvalidArgument < Error
        attr_accessor :argument
        def initialize(argument)
          @argument = argument
        end
      end

      class RecordNotFound < Error
        attr_accessor :id
        def initialize(id)
          @id = id
        end
      end

      class FilterNotAllowed < Error
        attr_accessor :filter
        def initialize(filter)
          @filter = filter
        end
      end

      class InvalidFieldValue < Error
        attr_accessor :field, :value
        def initialize(field, value)
          @field = field
          @value = value
        end
      end

      class InvalidField < Error
        attr_accessor :field, :type
        def initialize(type, field)
          @field = field
          @type = type
        end
      end

      class InvalidFieldFormat < Error; end

      class ParamNotAllowed < Error
        attr_accessor :params
        def initialize(params)
          @params = params
        end
      end

    end
  end
end