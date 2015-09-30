#!/bin/env ruby
# encoding: utf-8

require 'action_view'

include ActionView::Helpers::NumberHelper


class Formatar
	def self.como_tempo(segundos)
		Time.at(segundos).utc.strftime("%H:%M:%S")
	end

	def self.como_percentual(percentual)
		number_to_percentage percentual * 100, :precision => 0, :delimiter => '.'
	end

	def self.como_numero(numero)
		number_with_precision numero, :precision => 0, :delimiter => '.'
	end
end
