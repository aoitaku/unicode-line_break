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
