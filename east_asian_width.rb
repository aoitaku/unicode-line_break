require_relative 'db.rb'

module Unicode

  class EastAsianWidth

    N  = 0
    A  = 1
    H  = 2
    W  = 3
    F  = 4
    Na = 5

    def initialize(db=nil)
      @db = db || Unicode::DB.new
    end

    def east_asian_width(char)
      @db.east_asian_width(char.ord)
    end

  end
end

eaw = Unicode::EastAsianWidth.new
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('a'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('1'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('あ'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('α'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('а'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('亜'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('→'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width(']'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('('))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('」'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('ｲ'))
p Unicode::EastAsianWidthDB.cid2sym(eaw.east_asian_width('Ａ'))
