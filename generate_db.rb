require 'net/http'
require 'uri'
require 'json'

module Unicode
  VERSION = '7.0.0'
end

UCD_DIR = "http://www.unicode.org/Public/#{Unicode::VERSION}/ucd/"

def ucd
  -> path { -> pattern { -> {
    response = Net::HTTP.get(URI.parse("#{UCD_DIR}#{path}"))
    break unless response
    response.scan(pattern).each_with_object({ i: {}, r: {} }) {|(*cp, c), db|
      cp.last ?
      db[:r].store(cp.first.to_i(16)..cp.last.to_i(16), c.to_sym) :
      db[:i].store(cp.first.to_i(16), c.to_sym)
    }
  }}}
end

def dump_dbs(dbs)
  dbs.each do |file, db|
    JSON.dump(db[], File.open("#{file.to_s}.json", 'w+:utf-8'))
  end
end

dump_dbs(
  ucd_linebreak:
    ucd['LineBreak.txt'][/^([0-9A-F]+)(?:\.\.([0-9A-F]+))?;([A-Z][A-Z0-9])/],
  ucd_east_asian_width:
    ucd['EastAsianWidth.txt'][/^([0-9A-F]+)(?:\.\.([0-9A-F]+))?;([AFHNW]|Na)/]
)
