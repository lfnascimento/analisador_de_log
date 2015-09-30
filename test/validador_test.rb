#!/bin/env ruby
# encoding: utf-8

require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'minitest/autorun'
require_relative 'test_helper'

class TestValidador < MiniTest::Test
	def setup
		@logger_mock = MiniTest::Mock.new
	end

	def test_deve_identificar_acesso_valido
		dado_que tenho_um_acesso_valido
		e tenho_um_validador
		quando verifico_se_o_acesso_eh_valido
		entao descubro_que_sim
	end

	def test_deve_identificar_acesso_invalido
		dado_que tenho_um_acesso_invalido
		e tenho_um_validador
		quando verifico_se_o_acesso_eh_valido
		entao descubro_que_nao
	end

	def tenho_um_acesso_valido
		ip_origem = "189.58.227.117",
		url_destino = "/SiteBNDES/bndes/bndes_pt/Espaco_BNDES/Revista_do_BNDES/200812_5",
		status = "200",
		timestamp = '2015/3/20 0:0:0'
		@acesso = Acesso.new ip_origem, url_destino, status, timestamp
		@logger_mock.expect(:info, nil, [nil])
	end


	def tenho_um_acesso_invalido
		ip_origem = "189.58.227.117",
		url_destino = "/SiteBNDES/logo.jpg",
		status = "200",
		timestamp = '2015/3/20 0:0:0'

		@acesso = Acesso.new ip_origem, url_destino, status, timestamp
		@logger_mock.expect(:info, nil, ["AVISO: url /SiteBNDES/logo.jpg descartada"])
	end


	def tenho_um_validador
		parser = LogParserPIT.new
		@validador = Validador.new parser, @logger_mock

	end

	def verifico_se_o_acesso_eh_valido
		@valido = @validador.acesso_valido? @acesso

	end

	def descubro_que_sim
		assert_equal true, @valido
	end

	def descubro_que_nao
		@logger_mock.verify
		assert_equal false, @valido
	end
end
