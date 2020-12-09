# frozen_string_literal: true

module PuppetfileResolver
  module SpecSearchers
    class ForgeConfiguration
      DEFAULT_FORGE_URI ||= 'https://forgeapi.puppet.com'

      def forge_api
        @forge_api || DEFAULT_FORGE_URI
      end

      attr_writer :forge_api
    end
  end
end
