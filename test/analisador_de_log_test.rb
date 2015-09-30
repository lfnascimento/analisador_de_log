require_relative __FILE__.gsub('/test/','/src/').gsub('_test', '')

require 'minitest/autorun'
require_relative 'test_helper'

class TestAnalisadorDeLog < MiniTest::Test

  def setup
		@logger_mock = MiniTest::Mock.new
    @path = 'Z:\Portal\performance\acesso\analisador_de_acessos'
	end

  def test_deve_analisar_log

      dado_que tenho_um_analisador_de_log
      dado_que tenho_um_log_mini

      quando analiso_o_log

      entao obtenho_um_csv_com_os_acessos
      entao obtenho_um_histograma_com_acessos_no_mesmo_segundo
  end

  def test_deve_analisar_log_com_filtro
    dado_que tenho_um_analisador_de_log
    e tenho_um_log_pit_com_urls_reserva
    e tenho_uma_regex_url

    quando analiso_o_log_com_filtro

    entao obtenho_um_csv_com_os_acessos
    entao obtenho_um_histograma_com_acessos_no_mesmo_segundo
  end

  def tenho_um_analisador_de_log
    @analisador = AnalisadorDeLog.new
  end

  def tenho_um_log_pit_com_urls_reserva

    @uri_log = @path + '\logs\access_log_pit_mini_reserva.log'
    @uri_csv_esperado = @path + '\esperados\access_log_pit_mini_reserva.csv'
    @uri_csv_obtido = @path + '\processados\access_log_pit_mini_reserva.csv'
    @uri_csv_histograma_esperado = @path + '\esperados\access_log_pit_mini_reserva.histograma.csv'
    @uri_csv_histograma_obtido = @path + '\processados\access_log_pit_mini_reserva.histograma.csv'
  end

  def tenho_uma_regex_url
    @regex_url = "reserva.html"
  end

  def tenho_um_log_mini

    @uri_log = @path + '\logs\access_log_pit_mini.log'
    @uri_csv_esperado = @path + '\esperados\access_log_pit_mini.csv'
    @uri_csv_obtido = @path + '\processados\access_log_pit_mini.csv'
    @uri_csv_histograma_esperado = @path + '\esperados\access_log_pit_mini.csv'
    @uri_csv_histograma_obtido = @path + '\processados\access_log_pit_mini.csv'
  end

  def analiso_o_log
    @analisador.analisar @uri_log
  end

  def analiso_o_log_com_filtro
    @analisador.analisar @uri_log, @regex_url
  end

  def obtenho_um_csv_com_os_acessos
    csv_esperado = File.read(@uri_csv_esperado)
    csv_obtido = File.read(@uri_csv_obtido)
    assert_equal csv_esperado, csv_obtido
  end

  def obtenho_um_histograma_com_acessos_no_mesmo_segundo
    csv_histograma_esperado = File.read(@uri_csv_histograma_esperado)
    csv_histograma_obtido = File.read(@uri_csv_histograma_obtido)
    assert_equal csv_histograma_esperado, csv_histograma_obtido
  end

end
