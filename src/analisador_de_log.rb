#!/bin/env ruby
# encoding: utf-8

require 'date'
require 'thread'
require 'logger'
require_relative 'motor_de_parsing'

class AnalisadorDeLog

  def analisar(uri_log, regex_urls = nil)
    logger = Logger.new STDOUT
    logger.progname = __FILE__

    motor = MotorDeParsing.new(logger, uri_log)
    motor.processar_arquivo regex_urls
  end

end
