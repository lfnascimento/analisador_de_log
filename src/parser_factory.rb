#!/bin/env ruby
# encoding: utf-8

require_relative 'log_parser_pit'
require_relative 'log_parser_pco'


class ParserFactory

	PARSERS = [LogParserPIT.new, LogParserPCO.new]

	def initialize(logger)
	    @logger = logger
	end

	def deduzirParserPelaLinha(linha, regex_urls = nil)
	    PARSERS.each { |parser|
	      unless parser.match(linha).nil?
	          @logger.info "= Utilizando parser [#{parser.class.name}]"
						novo_parser = parser.class.new regex_urls
	          return novo_parser
	      end
	    }
	    raise "Não é possível deduzir o parser da seguinte linha:\n#{linha}"
	end
end
