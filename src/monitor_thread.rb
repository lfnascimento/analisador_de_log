#!/bin/env ruby
# encoding: utf-8

require_relative 'cronometro'

class MonitorThread
	attr :thread

	def initialize(total_de_linhas, calcula_posicao_atual)
		@espera_em_segundos = 1
		@calcula_posicao_atual = calcula_posicao_atual
		@total_de_linhas = total_de_linhas
		@cronometro = Cronometro.new

		@thread = run
	end

	def run
		Thread.new do
			begin
				avisar
				sleep(@espera_em_segundos)
			end while @calcula_posicao_atual.call < @total_de_linhas - 1
		end
	end

	def exit
		@thread.exit
	end

	def avisar
		tempo_decorrido = @cronometro.tempo_decorrido.to_f
		posicao_atual = @calcula_posicao_atual.call

		if tempo_decorrido == 0
			velocidade = 0
		else
			velocidade = posicao_atual.to_f / tempo_decorrido.to_f
		end

		case
		when tempo_decorrido > 60
			@espera_em_segundos = 10
		when tempo_decorrido > 20
			@espera_em_segundos = 5
		end

		registros_faltantes = @total_de_linhas - posicao_atual

		if velocidade != 0
			tempo_faltante = registros_faltantes / velocidade
		else
			tempo_faltante = 0
		end
		percentual_processado = posicao_atual.to_f / @total_de_linhas
		puts "#{Formatar.como_numero(posicao_atual)} - #{Formatar.como_percentual(percentual_processado)} - passaram #{Formatar.como_tempo(tempo_decorrido.to_f)}s, faltam #{Formatar.como_tempo(tempo_faltante.to_f)}s"
	end

end
