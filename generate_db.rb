require 'net/http'
require 'uri'
require 'json'

module Unicode
  VERSION = '7.0.0'
end

ucd = -> path do
  Net::HTTP.get(URI.parse("http://www.unicode.org/Public/#{Unicode::VERSION}/ucd/#{path}"))
end
gen = -> items do
  JSON.generate(items.each_with_object({ i: {}, r: {} }) {|(*cp, c), db|
    cp.last ? db[:r].store(cp.first.to_i(16)..cp.last.to_i(16), c.to_sym) : db[:i].store(cp.first.to_i(16), c.to_sym)
  })
end

# line break
File.write(
  'ucd_line_break.json',
  gen[ucd['LineBreak.txt'].scan(/^([0-9A-F]+)(?:\.\.([0-9A-F]+))?;([A-Z][A-Z0-9])/)]
)

# east asian width
File.write(
  'ucd_east_asian_width.json',
  gen[ucd['EastAsianWidth.txt'].scan(/^([0-9A-F]+)(?:\.\.([0-9A-F]+))?;([AFHNW]|Na)/)]
)
