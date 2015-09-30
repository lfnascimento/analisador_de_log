require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'minitest/autorun'

class TestCronometro < MiniTest::Test
	def test_deve_marcar_o_tempo_decorrido
		# dado_que
		tenho_um_cronometro

		# quando
		aguardo_1_segundo
		verifico_o_tempo_decorrido

		# entao
		o_tempo_passou
	end


	def test_deve_reiniciar_o_cronometro
		# dado que
		tenho_um_cronometro
		o_cronometro_foi_iniciado

		# quando
		aguardo_1_segundo
		reinicio_o_cronometro

		# entao
		o_inicio_do_cronometro_foi_alterado
	end


	def tenho_um_cronometro
		@cronometro = Cronometro.new
	end


	def o_cronometro_foi_iniciado
		@inicio = @cronometro.inicio
	end


	def	aguardo_1_segundo
		sleep 1
	end


	def verifico_o_tempo_decorrido
		@tempo_decorrido = @cronometro.tempo_decorrido
	end


	def reinicio_o_cronometro
		@cronometro.reset
	end


	def o_tempo_passou
		assert @tempo_decorrido > 0, "não houve tempo decorrido (#{@tempo_decorrido})"
	end


	def o_inicio_do_cronometro_foi_alterado
		assert @inicio < @cronometro.inicio, "Esperava que #{@inicio} fosse menor que #{@cronometro.inicio}"
	end
end
