require "i18n_structure/version"
require "i18n_structure/i18n_extension"

ActionView::Base.send :include, I18nStructure::LocaleHelper

module I18nStructure
  
end
