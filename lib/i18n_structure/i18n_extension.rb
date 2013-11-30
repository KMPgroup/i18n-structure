I18n.extend( Module.new{
  [:labels, :tooltips, :attributes].each do |kind|
    define_method("translate_#{kind.to_s.singularize}") do |*args|
      translate_element(kind, *args)
    end
    alias_method "t#{kind.to_s[0]}", "translate_#{kind.to_s.singularize}"

    define_method("translate_#{kind.to_s.singularize}_exist?") do |*args|
      translate_element_exist?(kind, *args)
    end
    alias_method "t#{kind.to_s[0]}?", "translate_#{kind.to_s.singularize}_exist?"
  end

  # collections are handled different than other elements
  def translate_collection(key, model=nil, options={})
    if model
      translate_attribute(key.to_s+"_collection", model, options)
    else
      I18n.t(key, :scope => [:collections])
    end
  end
  alias_method :tc, :translate_collection

  private
    # change passed object to key used in localization
    def to_mode_name(model)
      if model.kind_of?(ActiveRecord)
        model.class.model_name.singular
      elsif model.kind_of?(Draper::Decorator)
        model.source.class.model_name.singular
      elsif model.is_a?(Class)
        model.model_name.singular
      else
        model
      end
    end
     
    #transleates element of specyfic kind (label, attribute)
    def translate_element(element_kind, key, model=nil, options={})
      if model
        translate(key, {:scope => [:activerecord, element_kind, to_mode_name(model)]}.merge(options))
      else
        translate(key, {:scope => [element_kind]}.merge(options))
      end  
    end

    def translate_element_exist?(element_kind, key, model=nil, options={})
      if model
        return translate(key, :scope => [:activerecord, element_kind, to_mode_name(model)], :default => "").present?
      else
        return translate(key, :scope => [element_kind], :default => "").present?
      end  
    end
})