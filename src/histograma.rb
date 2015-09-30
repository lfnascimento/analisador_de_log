#!/bin/env ruby
# encoding: utf-8

class Histograma
  attr_accessor :ocorrencias

  def initialize
    @ocorrencias = {}
  end

  def adicionar_acessos_agrupados(acessos_agrupados)
    acessos_agrupados.each { |timestamp, acessos|
      adicionar_acessos acessos
    }
  end

  def adicionar_acessos(acessos)
    adicionar acessos.count
  end

  def adicionar acessos_por_segundo
    unless acessos_por_segundo == 0
      @ocorrencias[acessos_por_segundo] = (@ocorrencias[acessos_por_segundo] || 0 ) + 1
    end
  end

end
