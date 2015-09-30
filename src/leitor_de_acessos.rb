#!/bin/env ruby
# encoding: utf-8

require 'logger'
require_relative 'validador'
require_relative 'parser_factory'

class LeitorDeAcessos
		attr :proximo_acesso, :file

		def initialize(logger, uri_log)
			@filename = uri_log
			@file = File.open @filename
			@logger = logger
			@parserFactory = ParserFactory.new logger
		end

		def size
			@file.size
		end

		def obterParser(linha, regex_urls = nil)
			@parser ||= @parserFactory.deduzirParserPelaLinha(linha, regex_urls)
			#@parser
		end

		def acesso_valido?(acesso)
			@validador ||= Validador.new @parser, @logger
			@validador.acesso_valido?(acesso)
		end

		def ler_acessos_no_mesmo_segundo (regex_urls = nil)

			if @proximo_acesso.nil?
				acessos_no_mesmo_segundo = []
				segundo_atual = nil
			else
				acessos_no_mesmo_segundo = []
				acessos_no_mesmo_segundo << @proximo_acesso if acesso_valido?(@proximo_acesso)
				segundo_atual = @proximo_acesso.datetime
			end

			@file.each_line do |line|

				next if line.start_with?('#')

				obterParser line, regex_urls

				acesso = @parser.parse line

				segundo_atual = acesso.datetime if segundo_atual == nil

				if acesso.datetime == segundo_atual
				 acessos_no_mesmo_segundo << acesso if acesso_valido?(acesso)
				 next
				end

				@proximo_acesso = acesso
				return acessos_no_mesmo_segundo
			end

			@proximo_acesso = nil
			acessos_no_mesmo_segundo
		end

		def eof()
			@file.eof && @proximo_acesso.nil?
		end

end
