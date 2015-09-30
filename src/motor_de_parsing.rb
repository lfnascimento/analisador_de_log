#!/bin/env ruby
# encoding: utf-8

require_relative 'leitor_de_acessos'
require_relative 'histograma'
require_relative 'gravador'
require_relative 'monitor_thread'

class MotorDeParsing
  LIMITE_DE_REGISTROS = nil # 100000
  QUANTIDADE_DE_SEGUNDOS_PARA_AVISO = 1

  attr :parser, :logger, :uri_log
  attr :mutex, :acessos, :urls_rejeitadas, :ips_rejeitados, :contagem
  attr :gravador

	def initialize(logger, uri_log)
    @uri_log = uri_log
    @logger = logger
    @mutex = Mutex.new
		@acessos = {}
		@contagem = 0
    @gravador = Gravador.new uri_log
    @histograma = Histograma.new
  end

	def contagem
		@contagem
	end

  def processar_arquivo regex_urls
		@logger.info "= Processando arquivo [#{File.absolute_path @uri_log}]"

    @leitor = LeitorDeAcessos.new self.logger, self.uri_log
    calcula_posicao_atual = lambda { return contagem * 330 }
    monitor = MonitorThread.new( @leitor.size, calcula_posicao_atual )

    fila_de_blocos = Queue.new

    until @leitor.eof
			  (1..4).each {
          acessos = @leitor.ler_acessos_no_mesmo_segundo(regex_urls)
          fila_de_blocos.push acessos unless acessos.eql? []
          break if @leitor.eof
        }

        workers = (1..4).map do
          Thread.new do
            begin
              while bloco_acessos = fila_de_blocos.pop(true)

                acessos_agrupados = agrupar_acessos bloco_acessos

                @mutex.synchronize {
                  @gravador.gravar_acessos acessos_agrupados
                }

                @histograma.adicionar_acessos_agrupados acessos_agrupados
                @contagem += bloco_acessos.length
              end
            rescue ThreadError
            end
          end
        end; "ok"
        workers.map(&:join); "ok"
    end

    gravador.gravar_histograma @histograma

    monitor.exit

  end


  def agrupar_acessos(acessos)
    acessos.group_by { |acesso| acesso.datetime }
  end

	def parse(linha)
		@acesso = @parser.parse linha
	end
end
