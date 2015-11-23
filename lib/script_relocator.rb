require "script_relocator/version"
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
      doc = Nokogiri::HTML(response_body)
      scripts = doc.css('script')
      return status, headers, response if scripts.empty?
      scripts.each do |s|
        s['data-turbolinks-eval'] = 'false' if s.parent.name == 'head'
        s.remove
        doc.at('body') << s
      end
      transformed_body = doc.to_html
      if headers.key?('Content-Length') &&
          headers['Content-Length'].to_i != transformed_body.length
        headers['Content-Length'] = transformed_body.length.to_s
      end
      return status, headers, [transformed_body]
    end
  end
end

if defined? Rails
  Rails.application.config.middleware.use ScriptRelocator::Rack
end
