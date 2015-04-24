module PrettyJSON

  # http://stackoverflow.com/a/23018176
  ActionController::Renderers.add :json do |json, options|
    unless json.kind_of?(String)
      json = json.as_json(options) if json.respond_to?(:as_json)
      if params[:pretty]
        json = JSON.pretty_generate(json, options)
      end
    end

    if params[:callback].present?
      self.content_type ||= Mime::JS
      "#{params[:callback]}(#{json})"
    else
      self.content_type ||= Mime::JSON
      json
    end
  end

end
