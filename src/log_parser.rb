class LogParser
  attr :regex_descartadas

  def initialize(regex_url_consideradas = nil)
    #@regex_url_consideradas = []
    #@regex_url_consideradas << regex_url_consideradas
    @regex_url_consideradas = regex_url_consideradas.split(", ") unless regex_url_consideradas.nil?

    @regex_descartadas = []
    @log_regex = nil
  end

  def match (line)
    @log_regex.match(line)
  end

  def descarta_url?(url)

		if !(@regex_descartadas.eql? []) then
      @regex_descartadas.each { |ud|
				if url.downcase =~ ud then
          return true
          break
        end
			}
    end

    if !(@regex_url_consideradas.eql? nil) then

			@regex_url_consideradas.each { |uc|

				if url.include?(uc) then
          return false
          break
        end
			}
      return true
    end
  end
end
