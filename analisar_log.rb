Dir[File.join(File.dirname(__FILE__),'src','*.rb')].each {|file| require file }
require 'optparse'

PASTA_LOG = "./logs"
PASTA_CSV = "./processados"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: analisar_log.rb [options]"

  opts.on('-r', '--regexurls regex_urls', 'Regex de Url(s) a ser(em) consideradas(s)') { |v| options[:regex_urls] = v}

end.parse!

uri_log = ARGV[0] || File.join(PASTA_LOG,'access_log_pit_mini.log')
# base_uri = File.basename(uri, File.extname(uri))
# uri_log = File.join(PASTA_LOG, base_uri + '.log')

analisador = AnalisadorDeLog.new
analisador.analisar uri_log, options[:regex_urls]
