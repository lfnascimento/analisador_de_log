require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'minitest/autorun'
require_relative 'test_helper'

require_relative '../src/acesso'

class TestParserFactory < MiniTest::Test

	def setup
		@logger_mock = MiniTest::Mock.new
		@factory = ParserFactory.new @logger_mock
	end

	def test_deve_retornar_parser_com_um_filtro_do_regex
		dado_que tenho_um_regex
		e tenho_uma_linha_do_pit
		quando deduzo_qual_parser_utilizar_pela_linha
		entao o_parser_recomendado_tem_filtro_de_regex
	end

	def test_deve_retornar_parser_com_dois_filtros_do_regex
		dado_que tenho_um_regex_com_duas_urls_filtro
		e tenho_uma_linha_do_pit
		quando deduzo_qual_parser_utilizar_pela_linha
		entao o_parser_recomendado_tem_dois_filtros_de_regex
	end

	def test_deduzir_parser_pela_linha_pco
		dado_que tenho_uma_linha_do_pco
		quando deduzo_qual_parser_utilizar_pela_linha
		entao ele_recomenda_o LogParserPCO
	end

	def test_deduzir_parser_pela_linha_pit
		dado_que tenho_uma_linha_do_pit
		quando deduzo_qual_parser_utilizar_pela_linha
		entao ele_recomenda_o LogParserPIT
	end

	def tenho_um_regex_com_duas_urls_filtro
		@regex_url = "Espaco_BNDES, reserva.html"
	end

	def tenho_um_regex
		@regex_url = "reserva.html"
	end

	def o_parser_recomendado_tem_dois_filtros_de_regex
		assert_equal ["Espaco_BNDES", "reserva.html"], @parser.regex_url_consideradas
	end

	def o_parser_recomendado_tem_filtro_de_regex
		assert_equal ["reserva.html"], @parser.regex_url_consideradas
	end


	def tenho_uma_linha_do_pco
		@linha = '10.100.110.86 - - [17/Mar/2015:11:21:36 -0300] "GET /wps/myportal/bndesnet/!ut/p/b1/hc3LDoIwEAXQLzIzlYJ1WQRfPCJKRLohlTRILDRBxd-3uldnd5Nz74CAkhA6d4jrIZxA9HJsG3lvTS_1OwuvCrKc-z7hiDTxcZP6--WC584qJRaUFuCX4_ivvwXRaHO2rwoQH_xjK12bTllYilnFwyikyHjEnUOAnB6TmNLFFJkLxaBu5jHUCrJa1hcVq1HpnWwUdEKz64Q9X7_bb9o!/ HTTP/1.1" 200 80'
		@logger_mock.expect(:info, nil, ['= Utilizando parser [LogParserPCO]'])
	end

	def tenho_uma_linha_do_pit
		@linha = '2015-03-20 00:00:01 192.168.198.109 GET /SiteBNDES/bndes/bndes_pt/Areas_de_Atuacao/Infraestrutura/Energia/ - 80 - 189.58.227.117 HTTP/1.1 Googlebot+(Enterprise;+T2-HWW9XGSZWQSAB;+appliance@e-storageonline.com.br) - 200 28630 421'
		@logger_mock.expect(:info, nil, ['= Utilizando parser [LogParserPIT]'])
	end

	def deduzo_qual_parser_utilizar_pela_linha
		@parser = @factory.deduzirParserPelaLinha @linha, @regex_url
	end

	def test_reclama_se_nao_conseguir_deduzir_parser_pela_linha
		dado_que tenho_uma_linha_invalida
    	entao recebo_uma_excecao_quando_deduzo_qual_parser_utilizar_pela_linha
	end

	def tenho_uma_linha_invalida
    	@linha = "linha invalida que não dá para parsear"
	end

	def recebo_uma_excecao_quando_deduzo_qual_parser_utilizar_pela_linha
		mensagem = "Não é possível deduzir o parser da seguinte linha:\n#{@linha}"
		assert_raises_with_message RuntimeError, mensagem do
			@factory.deduzirParserPelaLinha @linha
		end
	end

	def tenho_um_arquivo_de_log_pit
		@uri_log = './logs/access_log_pit_mini.log'
		@logger_mock.expect(:info, nil, ['= Utilizando parser [LogParserPIT]'])
	end

	def ele_recomenda_o parser_recomendado
		assert_equal parser_recomendado, @parser.class
		assert @logger_mock.verify
	end

end
