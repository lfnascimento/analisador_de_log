require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')
require 'minitest/autorun'
require_relative 'test_helper'

class TestParserLogPit < MiniTest::Test
  attr_accessor :parser, :linha, :match_data

  def initialize(name)
    @parser = LogParserPIT.new
    super(name)
  end



  def test_deve_interpretar_uma_linha
    dado_que tenho_uma_linha_de_log
    quando interpreto_a_mesma
    entao ele_gera_um_acesso_com_as_informacoes_esperadas
  end

  def test_deve_interpretar_outra_linha
    dado_que tenho_outra_linha_de_log
    quando interpreto_a_mesma
    entao ele_gera_um_acesso_com_outras_informacoes
  end

  def test_deve_interpretar_uma_terceira_linha
    dado_que tenho_uma_terceira_linha_de_log
    quando interpreto_a_mesma
    entao ele_gera_um_acesso_com_informacoes_da_terceira_linha
  end

  def test_deve_avisar_sobre_linhas_que_nao_sabe_parsear
    dado_que tenho_uma_linha_invalida
    entao recebo_uma_excecao_ao_interpretar_a_linha
  end

  def test_deve_fazer_match
    dado_que tenho_uma_linha_de_log
    quando faco_match
    entao recebo_match_data
  end

  def faco_match
    @match_data = @parser.match @linha
  end

  def recebo_match_data
    assert_not_nil @match_data
  end

  def tenho_uma_linha_de_log
    @linha = "2015-03-20 00:00:00 192.168.198.109 GET /SiteBNDES/bndes/bndes_pt/Institucional/Publicacoes/Consulta_Expressa/Tipo/Revista_do_BNDES/200812_5.html - 80 - 189.58.227.117 HTTP/1.1 Googlebot+(Enterprise;+T2-HWW9XGSZWQSAB;+appliance@e-storageonline.com.br) - 200 40059 327"
  end

  def tenho_outra_linha_de_log
    @linha = "2015-03-20 00:02:38 192.168.198.109 GET /SiteBNDES/bndes/bndes_pt/externo.html origem=https://www.google.com.br/ 80 - 177.144.141.149 HTTP/1.1 Mozilla/5.0+(Windows+NT+6.1)+AppleWebKit/537.36+(KHTML,+like+Gecko)+Chrome/41.0.2272.89+Safari/537.36+OPR/28.0.1750.48 http://www.bndes.gov.br/ 200 457 15"
  end

  def tenho_uma_terceira_linha_de_log
    @linha = "2015-03-20 00:04:52 192.168.198.109 GET /SiteBNDES/export/sites/default/bndes_pt/Galerias/Arquivos/produtos/download/patrocinio/LogoBNDES_300dpi.jpg - 80 - 192.168.32.142,+200.182.77.50 HTTP/1.1 Mozilla/5.0+(Windows+NT+6.3;+WOW64;+rv:36.0)+Gecko/20100101+Firefox/36.0 - 200 122348 1124"
  end

  def tenho_uma_linha_invalida
    @linha = "linha invalida que não dá para parsear"
    @exception_message = "Não é possível parsear a seguinte linha:\n#{@linha}"
  end

  def interpreto_a_mesma
    @acesso = @parser.parse(@linha)
  end


  def recebo_uma_excecao_ao_interpretar_a_linha
    assert_raises_with_message RuntimeError, @exception_message do
      @parser.parse(@linha)
    end
  end


  def ele_gera_um_acesso_com_as_informacoes_esperadas
    refute_nil @acesso

    assert_equal '2015/3/20 0:0:0', @acesso.datetime
    assert_equal '189.58.227.117', @acesso.ip_origem
    assert_equal '/SiteBNDES/bndes/bndes_pt/Institucional/Publicacoes/Consulta_Expressa/Tipo/Revista_do_BNDES/200812_5.html', @acesso.url_destino
    assert_equal "200", @acesso.status
  end

  def ele_gera_um_acesso_com_outras_informacoes
    refute_nil @acesso

    assert_equal '2015/3/20 0:2:38', @acesso.datetime
    assert_equal '177.144.141.149', @acesso.ip_origem
    assert_equal '/SiteBNDES/bndes/bndes_pt/externo.html', @acesso.url_destino
    assert_equal "200", @acesso.status
  end

  def ele_gera_um_acesso_com_informacoes_da_terceira_linha
    refute_nil @acesso

    assert_equal '2015/3/20 0:4:52', @acesso.datetime
    assert_equal '192.168.32.142,+200.182.77.50', @acesso.ip_origem
    assert_equal '/SiteBNDES/export/sites/default/bndes_pt/Galerias/Arquivos/produtos/download/patrocinio/LogoBNDES_300dpi.jpg', @acesso.url_destino
    assert_equal "200", @acesso.status
  end

  def test_deve_descartar_urls_do_cartao_bndes

    dado_que tenho_um_paser_pit
    e tenho_uma_url_de_uma_pagina_do_cartao_bndes

    verifico_se_ela_deve_ser_descartada

    ela_deve_ser_descartada

  end

  def test_deve_descartar_urls_nao_espaco_bndes
    # dado que
    tenho_o_parser_pit_com_url_Espaco_BNDES
    tenho_uma_url_de_uma_pagina_nao_eh_espaco_bndes

    # quando
    verifico_se_ela_deve_ser_descartada

    # entao
    ela_deve_ser_descartada
  end

  def test_deve_nao_descartar_url_reserva
    # dado que
    tenho_o_parser_pit_com_url_reserva
    tenho_uma_url_de_uma_pagina_reserva

    # quando
    verifico_se_ela_deve_ser_descartada

    # entao
    ela_nao_deve_ser_descartada
  end

  def tenho_um_paser_pit
    @parser = LogParserPIT.new
  end

  def tenho_o_parser_pit_com_url_reserva
    @parser = LogParserPIT.new "reserva.html"
  end

  def tenho_uma_url_de_uma_pagina_reserva
    @url = "/SiteBNDES/bndes/bndes_pt/Areas_de_Atuacao/Cultura/Galeria/2003_patrimonio_mundial_brasileiro_4/reserva.html"
  end

  def ela_nao_deve_ser_descartada
    assert_false @url_descartada
  end

  def tenho_o_parser_pit_com_url_Espaco_BNDES
    @parser = LogParserPIT.new "Espaco_BNDES"
  end

  def tenho_uma_url_de_uma_pagina_nao_eh_espaco_bndes
    @url = "/SiteBNDES/bndes/bndes_pt/Areas_de_Atuacao/Cultura/Galeria/2003_patrimonio_mundial_brasileiro_4.html"
  end

  def tenho_uma_url_de_uma_imagem_do_cartao_bndes
    @url = "/cartaobndes/Images/Bandeiras/Elo/img_logo_Bandeira.gif"
  end

  def tenho_uma_url_de_uma_imagem
    @url = "/cartaobndes/Images/Bandeiras/Elo/img_logo_Bandeira.gif"
  end

  def tenho_uma_url_de_uma_pagina_do_cartao_bndes
    @url = "/cartaobndes/index.asp"
  end

  def tenho_uma_url_de_uma_pagina_do_portal_externo
    @url = "/cartaobndes/Images/Bandeiras/Elo/img_logo_Bandeira"
  end

  def tenho_uma_url_de_uma_pagina_absoluta_do_cartao_bndes
    @url = "/cartaobndes/Images/Bandeiras/Elo/img_logo_Bandeira.gif"
  end


  def verifico_se_ela_deve_ser_descartada
    @url_descartada = @parser.descarta_url? @url
  end

  def ela_deve_ser_descartada
    assert @url_descartada, "Url deveria ser descartada [#{@url}]"
  end


end
