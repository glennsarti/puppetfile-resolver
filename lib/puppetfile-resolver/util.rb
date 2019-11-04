# frozen_string_literal: true

module PuppetfileResolver
  module Util
    def self.symbolise_object(object)
      case # rubocop:disable Style/EmptyCaseCondition Ignore
      when object.is_a?(Hash)
        object.inject({}) do |memo, (k, v)| # rubocop:disable Style/EachWithObject Ignore
          memo[k.to_sym] = symbolise_object(v)
          memo
        end
      when object.is_a?(Array)
        object.map { |i| symbolise_object(i) }
      else
        object
      end
    end
  end
end
