class Acesso
	attr_reader :ip_origem, :url_destino, :status, :timestamp

	def initialize(ip_origem, url_destino, status, timestamp)
		@ip_origem = ip_origem
		@url_destino = url_destino
		@status = status
		@timestamp = timestamp
	end

	def dia
		timestamp.day
	end

	def mes
		timestamp.month
	end

	def ano
		timestamp.year
	end

	def hora
		timestamp.hour
	end

	def minuto
		timestamp.minute
	end

	def segundo
		timestamp.second
	end

	def date
		"#{ano}/#{mes}/#{dia}"
	end

	def time
		"#{hora}:#{minuto}:#{segundo}"
	end

	def datetime
		"#{date} #{time}"
	end

	def weekday
		timestamp.strftime('%a')
	end

	def week
		timestamp.strftime('%U').to_i
	end

	def chave
		"#{datetime} #{ip_origem} #{url_destino} #{status}"
	end

	def to_s
		chave
	end

	def hash
		chave.hash
	end

	def eql?(obj)
		self.to_s == obj.to_s
	end

end
