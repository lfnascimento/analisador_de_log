#!/bin/env ruby
# encoding: utf-8

class Validador

	EXIBIR_DESCARTADOS_NA_TELA = true
	IP_TESTE_DE_PERFORMANCE = '10.90.102.50'

	def initialize(parser, logger)
		@parser = parser
		@logger = logger
		@urls_rejeitadas = []
		@ips_rejeitados = []

	end


	def acesso_valido?(acesso)
		valido = valida_url_destino?(acesso) && valida_ip_origem?(acesso)
    valido
	end

	def valida_url_destino?(acesso)
    descartar =  @parser.descarta_url? acesso.url_destino
    if descartar
			unless @urls_rejeitadas.include? acesso.url_destino
				@urls_rejeitadas << acesso.url_destino
				@logger.info "AVISO: url #{acesso.url_destino} descartada" if EXIBIR_DESCARTADOS_NA_TELA
			end
		end
		!descartar
	end

	def valida_ip_origem?(acesso)
		valido = (IP_TESTE_DE_PERFORMANCE != acesso.ip_origem)
    if !valido
			unless @ips_rejeitados.include?(acesso.ip_origem)
				@ips_rejeitados << acesso.ip_origem
				@logger.info "AVISO: ip #{acesso.ip_origem} descartado" if ((!valido) && EXIBIR_DESCARTADOS_NA_TELA)
			end
		end
		valido
	end
end
