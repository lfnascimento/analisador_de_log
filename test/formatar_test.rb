require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'minitest/autorun'


class TestFormatar < MiniTest::Test
	def test_formata_como_tempo
		#dado que
		tenho_uma_quantidade_de_segundos

		#quando
		formato_como_tempo

		#entao
		recebo_a_hora_adequada
	end

	def test_formata_como_percentual
		#dado que
		tenho_uma_fracao

		#quando
		formato_como_percentual

		#entao
		recebo_o_percentual_adequado
	end

	def test_formata_como_numero
		#dado que
		tenho_um_numero_com_mais_de_3_casas

		#quando
		formato_como_numero

		#entao
		recebo_o_numero_adequado
	end



	def tenho_uma_quantidade_de_segundos
		@valor = 3754
	end

	def tenho_uma_fracao
		@valor = 1/3.to_f
	end

	def tenho_um_numero_com_mais_de_3_casas
		@valor = 3000 + 1/3.to_f
	end

	def formato_como_tempo
		@valor_formatado = Formatar.como_tempo @valor
	end

	def formato_como_percentual
		@valor_formatado = Formatar.como_percentual @valor
	end

	def formato_como_numero
		@valor_formatado = Formatar.como_numero @valor
	end

	def recebo_o_percentual_adequado
		assert_equal '33%', @valor_formatado
	end

	def recebo_a_hora_adequada
		assert_equal '01:02:34', @valor_formatado
	end

	def recebo_o_numero_adequado
		assert_equal '3.000', @valor_formatado
	end
end
