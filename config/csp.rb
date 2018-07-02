#
# Content Security Policy Headers handled within Rails
# See: https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
# for an explanation of possible values
#
module HDSkinsServer
  class Csp
    def self.parse(hash)
      hash = hash.map do |key, value|
        "#{key.to_s.gsub('_','-')} #{value.join(' ').gsub(/(self|unsafe-inline|none)/, '\'\1\'')};"
      end
      hash.join('')
    end
    
    def self.headers
      HEADERS
    end
    
    HEADERS = {
      default: Csp.parse({
        default_src: [ 'self' ],
        form_action: [ 'self' ],
        worker_src: [ 'self' ],
        child_src: [ 'self' ],
        frame_src: [ 'self' ],
        media_src: [ 'self' ],
        img_src: [ 'self' ],
        script_src: [ 'self' ],
        style_src: [ 'self' ]
      })
    }
  end
end
