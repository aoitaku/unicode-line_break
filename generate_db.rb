require 'net/http'
require 'uri'
require 'json'
require 'json/add/core'

module Unicode
  VERSION = '7.0.0'
end

UCD_DIR = "http://www.unicode.org/Public/#{Unicode::VERSION}/ucd/"

def ucd
  -> path { -> pattern { -> {
    response = Net::HTTP.get(URI.parse("#{UCD_DIR}#{path}"))
    break unless response
    response.scan(pattern).each_with_object({}) {|(*cp, c), db|
      db[c.to_sym] ||= []
      cp.last ?
      db[c.to_sym].push(*cp.first.to_i(16)..cp.last.to_i(16)) :
      db[c.to_sym].push(cp.first.to_i(16))
    }.inject({i:{},r:{}}) {|db, (k, v)|
      v.slice_before(value:v[0]) {|value, prev|
        prev[:value], prev_value = value, prev[:value]
        prev_value + 1 != value
      }.each {|values|
        if values.length > 2
          db[:r][k] ||= []
          db[:r][k].push(values.first..values.last)
        else
          db[:i][k] ||= []
          db[:i][k].push(*values)
        end
      }
      db
    }
  }}}
end

def dump_dbs(dbs)
  dbs.each do |file, db|
    JSON.dump(db[], File.open("#{file.to_s}.json", 'w+:utf-8'))
  end
end

dump_dbs(
  ucd_line_break:
    ucd['LineBreak.txt'][/^([0-9A-F]+)(?:\.\.([0-9A-F]+))?;([A-Z][A-Z0-9])/],
  ucd_east_asian_width:
    ucd['EastAsianWidth.txt'][/^([0-9A-F]+)(?:\.\.([0-9A-F]+))?;([AFHW]|Na?)/]
)
