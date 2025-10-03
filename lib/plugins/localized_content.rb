module Plugins
  module LocalizedContent
    extend ActiveSupport::Concern

    included do
      class_attribute :localized_attributes, default: []
    end

    class_methods do
      def localizes(*attrs)
        self.localized_attributes = (localized_attributes + attrs).uniq

        attrs.each do |attribute|
          define_method(attribute) do |locale = I18n.locale|
            read_attribute("#{attribute}_#{locale}")
          end
        end
      end
    end

    def localized_hash(locale = I18n.locale)
      self.class.localized_attributes.index_with do |attribute|
        send(attribute, locale)
      end
    end
  end
end
