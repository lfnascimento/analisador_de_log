#!/bin/env ruby
# encoding: utf-8
#require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'date'
require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../src/acesso'
require_relative '../src/motor_de_parsing'
require 'logger'

class TestMotorDeParsing < MiniTest::Test

	def setup
		@logger_mock = MiniTest::Mock.new
		@logger_mock_motor = MiniTest::Mock.new
		@logger_mock_leitor = MiniTest::Mock.new
		@logger = logger = Logger.new STDOUT
    @logger.progname = __FILE__
	end

	def test_deve_agrupar_acessos_iguais
		dado_que tenho_diversos_acessos_no_mesmo_segundo
		e tenho_um_motor
		quando agrupo_os_acessos
		entao obtenho_os_grupos_esperados
	end


	def test_deve_processar_arquivo_com_filtro
		dado_que tenho_um_log_pit_com_urls_reserva
		e tenho_um_motor_com_uri_do_pit_reserva
		e tenho_uma_regex_url
		quando processo_o_arquivo
		entao obtenho_um_csv_com_os_acessos_filtrados_pela_url
		entao obtenho_um_histograma_com_acessos_no_mesmo_segundo_filtrados_pela_url
	end

	def tenho_diversos_acessos_reserva_no_mesmo_segundo
		@acessos = [
			criar_acesso({
				:ip_origem => "189.58.227.117",
				:url_destino => "/SiteBNDES/bndes/bndes_pt/Institucional/Publicacoes/Consulta_Expressa/Tipo/Revista_do_BNDES/reserva.html",
				:status => "200",
				:timestamp => '2015/3/20 0:0:0'
				}),
			criar_acesso({
				:ip_origem => "192.168.0.1",
				:url_destino => "/SiteBNDES/bndes/bndes_pt/",
				:status => "200",
				:timestamp => '2015/3/20 0:0:0'
				}),
			criar_acesso({
				:ip_origem => "189.58.227.117",
				:url_destino => "/SiteBNDES/bndes/bndes_pt/Institucional/Publicacoes/Consulta_Expressa/Tipo/Revista_do_BNDES/reserva.html",
				:status => "200",
				:timestamp => '2015/3/20 0:0:0'
				}),
			criar_acesso({
				:ip_origem => "200.154.18.72",
				:url_destino => "/SiteBNDES/bndes/bndes_pt/Institucional/Publicacoes/reserva.html",
				:status => "200",
				:timestamp => '2015/3/20 0:0:2'
				})]

				@grupos_esperados = {
					'2015/3/20 0:0:0' => 2,
					'2015/3/20 0:0:2' => 1,
				}
	end

	def tenho_uma_regex_url
		@regex_url = '/reserva.html'
	end

	def tenho_um_motor
		@motor = MotorDeParsing.new @logger_mock, "url qualquer"
	end

	def tenho_um_motor_com_uri_do_pit_reserva
		arg_1 = "= Processando arquivo [Z:/Portal/performance/acesso/analisador_de_acessos/logs/access_log_pit_mini_reserva.log]"

		#@motor = MotorDeParsing.new @logger_mock, @uri_log
		@motor = MotorDeParsing.new @logger, @uri_log
		#@logger_mock.expect(:info, nil, [arg_1])

	end

	def processo_o_arquivo
		arg_2 = "= Utilizando parser[LogParserPIT]"
		@motor.processar_arquivo @regex_url
		#@logger_mock.verify
	end

	def tenho_um_log_pit_com_urls_reserva
    @uri_log = 'logs\access_log_pit_mini_reserva.log'
    @uri_csv_esperado = 'esperados\access_log_pit_mini_reserva.csv'
    @uri_csv_obtido = 'processados\access_log_pit_mini_reserva.csv'
    @uri_csv_histograma_esperado = 'esperados\access_log_pit_mini_reserva.histograma.csv'
    @uri_csv_histograma_obtido = 'processados\access_log_pit_mini_reserva.histograma.csv'
  end

	def obtenho_um_csv_com_os_acessos_filtrados_pela_url
    csv_esperado = File.read @uri_csv_esperado
    csv_obtido = File.read @uri_csv_obtido
    assert_equal csv_esperado, csv_obtido
  end

  def obtenho_um_histograma_com_acessos_no_mesmo_segundo_filtrados_pela_url
    csv_histograma_esperado = File.read @uri_csv_histograma_esperado
    csv_histograma_obtido = File.read @uri_csv_histograma_obtido
    assert_equal csv_histograma_esperado, csv_histograma_obtido
  end

	def tenho_diversos_acessos_no_mesmo_segundo
		@acessos = [
			criar_acesso({
				:ip_origem => "189.58.227.117",
				:url_destino => "/SiteBNDES/bndes/bndes_pt/Institucional/Publicacoes/Consulta_Expressa/Tipo/Revista_do_BNDES/200812_5.html",
				:status => "200",
				:timestamp => '2015/3/20 0:0:0'
				}),
			criar_acesso({
				:ip_origem => "192.168.0.1",
				:url_destino => "/SiteBNDES/bndes/bndes_pt/",
				:status => "200",
				:timestamp => '2015/3/20 0:0:0'
				}),
			criar_acesso({
				:ip_origem => "189.58.227.117",
				:url_destino => "/SiteBNDES/bndes/bndes_pt/Institucional/Publicacoes/Consulta_Expressa/Tipo/Revista_do_BNDES/200812_5.html",
				:status => "200",
				:timestamp => '2015/3/20 0:0:0'
				}),
			criar_acesso({
				:ip_origem => "200.154.18.72",
				:url_destino => "/SiteBNDES/bndes/bndes_pt/Institucional/Publicacoes",
				:status => "200",
				:timestamp => '2015/3/20 0:0:2'
				}),
			criar_acesso({
				:ip_origem => "192.168.0.1",
				:url_destino => "/SiteBNDES/bndes/bndes_pt/",
				:status => "200",
				:timestamp => '2015/3/20 0:0:2'
				}),
		]

		@grupos_esperados = {
			'2015/3/20 0:0:0' => 3,
			'2015/3/20 0:0:2' => 2,
		}

	end

	def agrupo_os_acessos
		@acessos_agrupados = @motor.agrupar_acessos @acessos
	end

	def obtenho_os_grupos_esperados

		hash_acessos_agrupados = Hash[@acessos_agrupados.map { |k, v|
			[k, v.length]
		}]
		assert_equal @grupos_esperados, hash_acessos_agrupados

	end

	def criar_acesso atributos
		acesso = Acesso.new atributos[:ip_origem], atributos[:url_destino], atributos[:status], DateTime.parse(atributos[:timestamp])
	end

end
