require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'minitest/autorun'

class TestAcesso < MiniTest::Test
	def test_acesso_tem_atributos_basicos
		# dado que
		tenho_um_acesso

		# entao
		tem_ip_origem
		tem_url_destino
		tem_status
		tem_timestamp
	end

	def test_acesso_tem_partes_do_timestamp
		# dado que
		tenho_um_acesso

		# entao
		tem_dia
		tem_mes
		tem_ano
		tem_hora
		tem_minuto
		tem_segundo
		tem_semana
		tem_dia_da_semana
		tem_data
		tem_tempo
		tem_data_e_tempo
	end

	def test_acesso_tem_chave
		# dado que
		tenho_um_acesso

		# entao
		tem_chave
	end

	def test_converte_para_string_como_chave
		# dado que
		tenho_um_acesso

		# entao
		converte_para_string_como_chave
	end

	def test_o_hash_eh_o_hash_da_chave
		# dado que
		tenho_um_acesso

		# entao
		o_hash_eh_o_hash_da_chave
	end

	def test_detecta_acessos_iguais
		# dado que
		tenho_um_acesso
		tenho_outro_acesso_com_as_mesmas_informacoes

		#entao
		as_chaves_sao_iguais
		eles_sao_iguais
	end


	IP_ORIGEM = '192.168.0.1'
	URL_DESTINO = '/index.htm'
	STATUS = '300'
	TIMESTAMP = DateTime.new 2015, 5, 14, 6, 12, 56

	def tenho_um_acesso
		@acesso = Acesso.new IP_ORIGEM, URL_DESTINO, STATUS, TIMESTAMP
	end

	def tenho_outro_acesso_com_as_mesmas_informacoes
		@outro_acesso = Acesso.new IP_ORIGEM, URL_DESTINO, STATUS, TIMESTAMP
	end

	def tem_ip_origem
		assert_equal IP_ORIGEM, @acesso.ip_origem
	end

	def tem_url_destino
		assert_equal URL_DESTINO, @acesso.url_destino
	end

	def tem_status
		assert_equal STATUS, @acesso.status
	end

	def tem_timestamp
		assert_equal TIMESTAMP, @acesso.timestamp
	end

	def tem_dia
		assert_equal 14, @acesso.dia
	end

	def tem_mes
		assert_equal 5, @acesso.mes
	end

	def tem_ano
		assert_equal 2015, @acesso.ano
	end

	def tem_hora
		assert_equal 6, @acesso.hora
	end

	def tem_minuto
		assert_equal 12, @acesso.minuto
	end

	def tem_segundo
		assert_equal 56, @acesso.segundo
	end

	def tem_semana
		assert_equal 19, @acesso.week
	end

	def tem_dia_da_semana
		assert_equal "Thu", @acesso.weekday
	end

	def tem_data
		assert_equal '2015/5/14', @acesso.date
	end

	def tem_tempo
		assert_equal '6:12:56', @acesso.time
	end

	def tem_data_e_tempo
		assert_equal '2015/5/14 6:12:56', @acesso.datetime
	end

	def tem_chave
		assert_equal '2015/5/14 6:12:56 192.168.0.1 /index.htm 300', @acesso.chave
	end

	def converte_para_string_como_chave
		assert_equal @acesso.chave, @acesso.to_s
	end

	def o_hash_eh_o_hash_da_chave
		assert_equal @acesso.chave.hash, @acesso.hash
	end

	def as_chaves_sao_iguais
		assert_equal @acesso.chave, @outro_acesso.chave
	end

	def eles_sao_iguais
		assert @acesso.eql? @outro_acesso
	end
end
