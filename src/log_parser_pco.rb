#!/bin/env ruby
# encoding: utf-8

require 'date'
require_relative 'log_parser'
require_relative 'acesso'

class LogParserPCO < LogParser

	LOG_REGEX_PCO = /^([\d.]+).*\[(\d+\/.+\/\d+:\d+:\d+:\d+).*\] ".* (\/.*) HTTP.*" (\d+).*$/

	def initialize(regex_url_consideradas = nil)
		super(regex_url_consideradas)
		@log_regex = LOG_REGEX_PCO
	end

	def parse(line)
		match_data = match(line)
		if match_data == nil
			raise "Não é possível parsear a seguinte linha:\n#{line}"
		end
		ip_origem = match_data[1].strip
		url_destino = match_data[3].strip
		status = match_data[4].strip

		datahora = match_data[2].strip

		timestamp = DateTime.strptime datahora, "%d/%b/%Y:%H:%M:%S"

		acesso = Acesso.new ip_origem, url_destino, status, timestamp

		return acesso
	end

end
