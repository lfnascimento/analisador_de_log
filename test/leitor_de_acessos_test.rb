require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'minitest/autorun'
require_relative 'test_helper'


require 'date'

require_relative '../src/acesso'
require_relative '../src/log_parser_pit'
require 'logger'

class TestLeitorDeAcessos < MiniTest::Test

	def setup

		@logger_mock = MiniTest::Mock.new

	end

	def test_deve_reclamar_se_o_arquivo_nao_existe
		dado_que tenho_o_caminho_para_um_arquivo_inexistente
		quando leio_o_arquivo
		entao	vejo_que_o_arquivo_nao_foi_encontrado
	end

	def tenho_o_caminho_para_um_arquivo_inexistente
		@uri = 'arquivo_inexistente.abc'
	end

	def vejo_que_o_arquivo_nao_foi_encontrado
		assert_raises Errno::ENOENT do
			raise @exception
		end
	end

	def test_deve_lancar_excecao_de_acesso_nulo
		dado_que tenho_um_parser_que_sempre_retorna_nulo
		entao recebo_uma_excecao_quando_faco_o_parse_do_acesso
	end

	def test_deve_retornar_parser_com_filtro_do_regex
		dado_que tenho_um_regex
		e tenho_uma_linha_do_pit
		e tenho_um_leitor_de_acessos
		quando obtenho_o_parser
		entao tenho_o_parser_pit_com_o_filtro
	end

	def test_deve_ler_acessos_no_mesmo_segundo_com_filtro
		dado_que tenho_uma_uri_reserva
		e tenho_um_regex
		quando leio_acessos_no_mesmo_segundo
		entao tenho_um_bloco_de_acessos_no_mesmo_segundo
	end

	def test_deve_descartar_acessos_nao_compativel_com_filtro
		dado_que tenho_uma_uri_reserva
		e tenho_um_regex_qualquer
		quando leio_acessos_no_mesmo_segundo
		entao tenho_um_bloco_de_acessos_vazio
	end

	def tenho_um_regex_qualquer
		@regex_url = "qualquer"
	end

	def tenho_um_bloco_de_acessos_vazio
		assert_equal [], @acessos_no_mesmo_segundo
	end

	def tenho_uma_uri_reserva
		@uri = "Z:/Portal/performance/acesso/analisador_de_acessos/logs/access_log_pit_mini_reserva.log"

		@acessos_esperados = []

		@acessos_esperados << (criar_acesso({
			:ip_origem => "189.58.227.117",
			:url_destino => "/SiteBNDES/bndes/Tipo/Revista_do_BNDES/reserva.html",
			:status => "200",
			:timestamp => '2015/3/20 0:0:0'
			}))

		@acessos_esperados << (criar_acesso({
			:ip_origem => "189.63.227.220",
			:url_destino => "/SiteBNDES/bndes/Energia/reserva.html",
			:status => "200",
			:timestamp => '2015/3/20 0:0:0'
			}))

	end

	def tenho_um_leitor_de_acessos_com_filtro
		@leitor = LeitorDeAcessos.new @logger_mock, uri
	end

	def obtenho_acessos_no_mesmo_segundo_filtrados
		@acessos_agrupados
	end

	def tenho_um_regex
		@regex_url = "reserva.html"
	end

	def tenho_uma_linha_do_pit
		@linha = '2015-03-20 00:00:01 192.168.198.109 GET /SiteBNDES/bndes/bndes_pt/Areas_de_Atuacao/Infraestrutura/Energia/ - 80 - 189.58.227.117 HTTP/1.1 Googlebot+(Enterprise;+T2-HWW9XGSZWQSAB;+appliance@e-storageonline.com.br) - 200 28630 421'
		@logger_mock.expect(:info, nil, ['= Utilizando parser [LogParserPIT]'])
	end

	def tenho_um_leitor_de_acessos
		uri = File.join(File.dirname(__FILE__), '..', 'logs', 'access_log_pit_mini.log')
		@leitor = LeitorDeAcessos.new @logger_mock, uri
	end

	def obtenho_o_parser
		@parser = @leitor.obterParser @linha, @regex_url
	end

	def tenho_o_parser_pit_com_o_filtro
		assert_equal ["reserva.html"], @parser.regex_url_consideradas
	end


	class ParserQueSempreRetornaNulo
		def parse
			nil
		end
	end

	def tenho_um_parser_que_sempre_retorna_nulo
		@parser = ParserQueSempreRetornaNulo.new
	end

	def recebo_uma_excecao_quando_faco_o_parse_do_acesso
		@parser.parse
	end


	def tenho_o_caminho_para_um_arquivo
		@uri = File.join(File.dirname(__FILE__), '..', 'logs', 'access_log_pit_mini.log')

		@acessos_esperados = []
		@acessos_esperados << (criar_acesso({
			:ip_origem => "189.58.227.117",
			:url_destino => "/SiteBNDES/bndes/bndes_pt/Institucional/Espaco_BNDES/Consulta_Expressa/Tipo/Revista_do_BNDES/200812_5.html",
			:status => "200",
			:timestamp => '2015/3/20 0:0:0'
			}))
		@acessos_esperados << (criar_acesso({
			:ip_origem => "189.114.74.99",
			:url_destino => "/SiteBNDES/bndes/bndes_pt/Institucional/Espaco_BNDES/Sala_de_Imprensa/Noticias/2012/saneamento/20120119_cab.html",
			:status => "200",
			:timestamp => '2015/3/20 0:0:0'
			}))
		@acessos_esperados << (criar_acesso({
			:ip_origem => "189.63.227.220",
			:url_destino => "/SiteBNDES/bndes/bndes_pt/Areas_de_Atuacao/Espaco_BNDES/Infraestrutura/Energia/",
			:status => "200",
			:timestamp => '2015/3/20 0:0:0'
			}))

	end

	def leio_o_arquivo
		begin
			 @leitor = LeitorDeAcessos.new @logger_mock, @uri
		rescue Exception => boom
			@exception = boom
		end
	end

	def ele_tem_poucas_linhas
		assert_equal 8, @texto.size
		assert @logger_mock.verify
	end

	def test_deve_ler_acessos_no_mesmo_segundo
		dado_que tenho_o_caminho_para_um_arquivo
		quando leio_acessos_no_mesmo_segundo
		entao tenho_um_bloco_de_acessos_no_mesmo_segundo
	end

	def criar_acesso atributos
     acesso = Acesso.new atributos[:ip_origem], atributos[:url_destino], atributos[:status], DateTime.parse(atributos[:timestamp])
  end

	def leio_acessos_no_mesmo_segundo
		#@logger_mock.expect(:info, nil, ["= Utilizando parser [LogParserPIT]"])
		@logger = logger = Logger.new STDOUT
    @logger.progname = __FILE__
		@leitor = LeitorDeAcessos.new @logger, @uri
		@parser = nil
		@acessos_no_mesmo_segundo = @leitor.ler_acessos_no_mesmo_segundo @regex_url
		@logger_mock.verify
	end

	def tenho_um_bloco_de_acessos_no_mesmo_segundo

		chaves_esperadas = @acessos_esperados.map { |acesso| acesso.chave  }.sort
		chaves_no_mesmo_segundo = @acessos_no_mesmo_segundo.map { |acesso| acesso.chave  }.sort

		assert_equal chaves_esperadas, chaves_no_mesmo_segundo
	end

end
