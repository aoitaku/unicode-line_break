require 'net/http'
require 'uri'
require 'json'

module Unicode
  VERSION = '7.0.0'
end

url = URI.parse("http://www.unicode.org/Public/#{Unicode::VERSION}/ucd/LineBreak.txt")
linebreak = Net::HTTP.get(url)
db = { i: {}, r: {} }
linebreak.scan(/^([0-9A-F]+)(?:\.\.([0-9A-F]+))?;([A-Z][A-Z0-9])/) do |(*cp, c)|
  if cp.last
    db[:r].store(cp.first.to_i(16)..cp.last.to_i(16), c.to_sym)
  else
    db[:i].store(cp.first.to_i(16), c.to_sym)
  end
end
File.write('ucd_db.json', JSON.generate(db))
