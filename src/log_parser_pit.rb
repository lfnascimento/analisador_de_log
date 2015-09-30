#!/bin/env ruby
# encoding: utf-8

require 'date'
require_relative 'acesso'
require_relative 'log_parser'

class LogParserPIT < LogParser
	attr :regex_url_consideradas

	LOG_REGEX_PIT = /(\d+-\d+-\d+) (\d+:\d+:\d+) (\d+.\d+.\d+.\d+) \w+ (.*) .* (\d+) .* (.*) .* (.*) (.*) (\d+) (\d+) (\d+)/

	REGEX_FORMATOS_NAO_CONSIDERADOS = /^.*(\.jpg|\.png|\.js|\.JS|\.gif|\.css|\.pdf|\.doc)$/
	REGEX_CARTAO_BNDES = /\/cartaobndes\//

	def initialize(regex_url_consideradas = nil)
		super(regex_url_consideradas)
		@log_regex = LOG_REGEX_PIT
		@regex_descartadas << REGEX_FORMATOS_NAO_CONSIDERADOS
		@regex_descartadas << REGEX_CARTAO_BNDES
	end

	def parse(line)
		match_data = match(line)
		if match_data == nil
			raise "Não é possível parsear a seguinte linha:\n#{line}"
		end
		data = match_data[1].strip
		hora = match_data[2].strip
		url_destino = match_data[4].strip
    ip_origem = match_data[6].strip
		status = match_data[9].strip

		data_formatada= data.gsub(/-/, '/')

		datahora = data_formatada + ":" + hora

    timestamp = DateTime.strptime datahora, "%Y/%m/%d:%H:%M:%S"

		acesso = Acesso.new ip_origem, url_destino, status, timestamp

		return acesso
	end

end
