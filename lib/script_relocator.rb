require 'nokogiri'

module ScriptRelocator
  class Rack
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      if headers['Content-Type'] !~ %r{^text/html}
        return status, headers, response
      end
      response_body = ''
      response.each { |part| response_body << part }
      return status, headers, response unless response_body =~ /\A<!DOCTYPE/
      doc = Nokogiri::HTML(response_body)
      target = doc.at('body')
      scripts = doc.css('script')
      return status, headers, response if scripts.empty?
      scripts.each do |s|
        next if s['async'] == 'async' || s['defer'] == 'defer'
        s['data-turbolinks-eval'] = 'false' if s.parent.name == 'head'
        s.remove
        target << s
      end
      transformed_body = doc.to_html(save_with: Nokogiri::XML::Node::SaveOptions::NO_DECLARATION | Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS | Nokogiri::XML::Node::SaveOptions::AS_HTML)
      if headers.key?('Content-Length') &&
          headers['Content-Length'].to_i != transformed_body.length
        headers['Content-Length'] = transformed_body.length.to_s
      end
      return status, headers, [transformed_body]
    end
  end
end

require 'script_relocator/railtie' if defined?(Rails)
