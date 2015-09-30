#!/bin/env ruby
# encoding: utf-8

class Cronometro
	attr_reader :inicio

	def initialize
		reset
	end

	def reset
		@inicio = Time.now.to_f
	end

	def tempo_decorrido
		Time.now.to_f - @inicio.to_f
	end

end
