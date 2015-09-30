#!/bin/env ruby
# encoding: utf-8

class Gravador

  attr :uri_csv, :uri_histograma

  PASTA_PROCESSADOS = "./processados"
  @@CONTAGEM_MINIMA = 0

  @contador
  @csv_header = false
  @histograma_header = false

  def initialize(uri)
    base_uri = File.basename(uri, ".log")
    @uri_csv = File.join(PASTA_PROCESSADOS, base_uri + ".csv")
    @uri_histograma = File.join(PASTA_PROCESSADOS, base_uri +'.histograma.csv')

    File.new(@uri_csv, "w")
    File.new(@uri_histograma, "w+")

  end

  def gravar_acessos (acessos_agrupados_por_timestamp)
      acessos_agrupados_por_timestamp.select! { |timestamp, acessos|
        acessos.size > @@CONTAGEM_MINIMA
      }

      File.open(@uri_csv, "a") { |csv|
        unless @csv_header
          csv.write "datetime,date,time,ano,mes,dia,weekday,week,hora,minuto,segundo,contagem\n"
          @csv_header = true
        end

        acessos_agrupados_por_timestamp.each { |timestamp, acessos|
          acesso = acessos[0]
          contagem = acessos.size
          csv.write "#{acesso.datetime},#{acesso.date},#{acesso.time},#{acesso.ano},#{acesso.mes},#{acesso.dia},#{acesso.weekday},#{acesso.week},#{acesso.hora},#{acesso.minuto},#{acesso.segundo},#{contagem}\n"
        }
      }

  end

  def gravar_histograma (histograma)
      histograma_ordenado = histograma.ocorrencias.sort_by{|acessos_por_segundo, ocorrencias| acessos_por_segundo}

      File.open(@uri_histograma, "w") { |file|

          file.write "acessos_por_segundo,ocorrencias\n"

          histograma_ordenado.each do |elemento|
            linha_suja = elemento.to_s
            linha_limpa = linha_suja.gsub(/[\[\]]/,"").delete(' ')
            file.write "#{linha_limpa}\n"
          end
      }
   end
end
