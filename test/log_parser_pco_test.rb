require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'minitest/autorun'
require 'minitest/spec'

require_relative 'test_helper'


class TestParserLogPco < MiniTest::Test
  def initialize(name)
    @parser = LogParserPCO.new
    super(name)
  end

  def test_deve_interpretar_uma_linha
    dado_que tenho_uma_linha_de_log
    quando interpreto_a_mesma
    entao ele_gera_um_acesso_com_as_informacoes_esperadas
  end

  def test_deve_fazer_match
    dado_que tenho_uma_linha_de_log
    quando faco_match
    entao recebo_match_data
  end

  def test_deve_avisar_sobre_linhas_que_nao_sabe_parsear
    dado_que tenho_uma_linha_invalida
    entao recebo_uma_excecao_ao_interpretar_a_linha
  end

  def tenho_uma_linha_invalida
    @linha = "linha invalida que não dá para parsear"
    @exception_message = "Não é possível parsear a seguinte linha:\n#{@linha}"
  end

  def recebo_uma_excecao_ao_interpretar_a_linha
    assert_raises_with_message RuntimeError, @exception_message do
      @parser.parse @linha
    end
  end

  def faco_match
    @match_data = @parser.match @linha
  end

  def recebo_match_data
    assert_not_nil @match_data
  end

  def tenho_uma_linha_de_log
    @linha = '10.100.110.86 - - [17/Mar/2015:11:21:36 -0300] "GET /clipping/factory/html_templates/blue_buttons.css HTTP/1.1" 304 -'
  end

  def interpreto_a_mesma
    @acesso = @parser.parse(@linha)
  end

  def ele_gera_um_acesso_com_as_informacoes_esperadas
    refute_nil @acesso

    assert_equal '2015/3/17 11:21:36', @acesso.datetime
    assert_equal '10.100.110.86', @acesso.ip_origem
    assert_equal '/clipping/factory/html_templates/blue_buttons.css', @acesso.url_destino
    assert_equal "304", @acesso.status
  end

end
