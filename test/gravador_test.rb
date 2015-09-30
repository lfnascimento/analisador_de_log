require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'minitest/autorun'

require 'date'

require_relative '../src/acesso'
require_relative '../src/histograma'

class TestGravador < MiniTest::Test

  URI_HISTOGRAMA_ESPERADO = "./esperados/access_log_pit_test.histograma.csv"
  URI_ACESSOS_ESPERADOS = "./esperados/access_log_pit_test.csv"

  def test_deve_calcular_uri_dos_csvs
    # dado que
    tenho_uma_uri

    #quando
    instancio_um_gravador

    #entao
    obtenho_a_uri_do_csv
    obtenho_a_uri_do_histograma
  end

  def tenho_uma_uri
    @uri_log = 'logs\access_log_pit_mini.log'

    @uri_csv_esperado = './processados/access_log_pit_mini.csv'
    @uri_histograma_esperado = './processados/access_log_pit_mini.histograma.csv'
  end

  def instancio_um_gravador
    @gravador = Gravador.new @uri_log
  end
  alias :tenho_um_gravador :instancio_um_gravador

  def obtenho_a_uri_do_csv
    assert_equal @uri_csv_esperado, @gravador.uri_csv
  end

  def obtenho_a_uri_do_histograma
    assert_equal @uri_histograma_esperado, @gravador.uri_histograma
  end

  def test_deve_gravar_um_acesso
    # dado que
    tenho_uma_uri_de_um_acesso
    tenho_um_gravador
    tenho_um_acesso_agrupado_por_timestamp

    #quando
    gravo_o_acesso

    #entao
    obtenho_o_csv_esperado
  end

  def test_deve_gravar_o_histograma_de_um_acesso
    # dado que
    tenho_uma_uri_de_um_acesso
    tenho_um_gravador
    tenho_um_histograma

    #quando
    gravo_o_histograma

    #entao
    obtenho_o_histograma_esperado
  end

  def tenho_uma_uri_de_um_acesso
    @uri_log = 'logs\unico_acesso.log'
  end

  def tenho_um_acesso_agrupado_por_timestamp
    ip_origem = 'origem_mock'
    url_destino = 'destino_mock'
    status = 300
    timestamp = DateTime.new 1993, 2, 13, 6, 5, 17
    acesso = Acesso.new ip_origem, url_destino, status, timestamp
    @acessos_agrupados_por_timestamp = {acesso.timestamp => [acesso]}
  end

  def tenho_um_histograma
    @histograma = Histograma.new
    @histograma.ocorrencias = {
      4 => 2,
      3 => 1
    }
  end


  def gravo_o_acesso
    @gravador.gravar_acessos @acessos_agrupados_por_timestamp
  end

  def gravo_o_histograma
    @gravador.gravar_histograma @histograma
  end


  def obtenho_o_csv_esperado
    uri_csv_unico_acesso = "./processados/unico_acesso.csv"
    csv_obtido = File.read(uri_csv_unico_acesso)
    csv_esperado = "datetime,date,time,ano,mes,dia,weekday,week,hora,minuto,segundo,contagem\n1993/2/13 6:5:17,1993/2/13,6:5:17,1993,2,13,Sat,6,6,5,17,1\n"

    assert_equal csv_esperado, csv_obtido
  end

  def obtenho_o_histograma_esperado
    uri_histograma_unico_acesso = "./processados/unico_acesso.histograma.csv"
    histograma_obtido = File.read(uri_histograma_unico_acesso)
    histograma_esperado = "acessos_por_segundo,ocorrencias\n3,1\n4,2\n"

    assert_equal histograma_esperado, histograma_obtido
  end
end
