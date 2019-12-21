module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def icon(name, options={})
    assets = Rails.application.assets
    file = assets.find_asset("icons/#{name}").source.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    classes = ["zondicon"]
    classes.push(options[:class]) if options[:class].present?
    svg["class"] = classes.join(" ")
    raw doc
  end
end
