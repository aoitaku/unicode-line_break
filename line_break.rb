require_relative 'db.rb'

module Unicode

  class LineBreak

    # [UAX #14 - 7.3 Example Pair Table](http://www.unicode.org/reports/tr14/#Table2)
    @@pair_table = [
      %i[^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ @ ^ ^ ^ ^ ^ ^ ^],
      %i[_ ^ ^ % % ^ ^ ^ ^ % % _ _ _ _ _ % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[_ ^ ^ % % ^ ^ ^ ^ % % % % % _ _ % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[^ ^ ^ % % % ^ ^ ^ % % % % % % % % % % % ^ # ^ % % % % % %],
      %i[% ^ ^ % % % ^ ^ ^ % % % % % % % % % % % ^ # ^ % % % % % %],
      %i[_ ^ ^ % % % ^ ^ ^ _ _ _ _ _ _ _ % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[_ ^ ^ % % % ^ ^ ^ _ _ _ _ _ _ _ % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[_ ^ ^ % % % ^ ^ ^ _ _ % _ _ _ _ % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[_ ^ ^ % % % ^ ^ ^ _ _ % % % _ _ % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[% ^ ^ % % % ^ ^ ^ _ _ % % % % _ % % _ _ ^ # ^ % % % % % _],
      %i[% ^ ^ % % % ^ ^ ^ _ _ % % % _ _ % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[% ^ ^ % % % ^ ^ ^ % % % % % _ % % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[% ^ ^ % % % ^ ^ ^ _ _ % % % _ % % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[% ^ ^ % % % ^ ^ ^ _ _ % % % _ % % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[_ ^ ^ % % % ^ ^ ^ _ % _ _ _ _ % % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[_ ^ ^ % % % ^ ^ ^ _ _ _ _ _ _ % % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[_ ^ ^ % _ % ^ ^ ^ _ _ % _ _ _ _ % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[_ ^ ^ % _ % ^ ^ ^ _ _ _ _ _ _ _ % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[% ^ ^ % % % ^ ^ ^ % % % % % % % % % % % ^ # ^ % % % % % %],
      %i[_ ^ ^ % % % ^ ^ ^ _ _ _ _ _ _ _ % % _ ^ ^ # ^ _ _ _ _ _ _],
      %i[_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ^ _ _ _ _ _ _ _ _],
      %i[% ^ ^ % % % ^ ^ ^ _ _ % % % _ % % % _ _ ^ # ^ _ _ _ _ _ _],
      %i[% ^ ^ % % % ^ ^ ^ % % % % % % % % % % % ^ # ^ % % % % % %],
      %i[_ ^ ^ % % % ^ ^ ^ _ % _ _ _ _ % % % _ _ ^ # ^ _ _ _ % % _],
      %i[_ ^ ^ % % % ^ ^ ^ _ % _ _ _ _ % % % _ _ ^ # ^ _ _ _ _ % _],
      %i[_ ^ ^ % % % ^ ^ ^ _ % _ _ _ _ % % % _ _ ^ # ^ % % % % _ _],
      %i[_ ^ ^ % % % ^ ^ ^ _ % _ _ _ _ % % % _ _ ^ # ^ _ _ _ % % _],
      %i[_ ^ ^ % % % ^ ^ ^ _ % _ _ _ _ % % % _ _ ^ # ^ _ _ _ _ % _],
      %i[_ ^ ^ % % % ^ ^ ^ _ _ _ _ _ _ _ % % _ _ ^ # ^ _ _ _ _ _ %]
    ]

    OP = 0
    CL = 1
    CP = 2
    QU = 3
    GL = 4
    NS = 5
    EX = 6
    SY = 7
    IS = 8
    PR = 9
    PO = 10
    NU = 11
    AL = 12
    HL = 13
    ID = 14
    IN = 15
    HY = 16
    BA = 17
    BB = 18
    B2 = 19
    ZW = 20
    CM = 21
    WJ = 22
    H2 = 23
    H3 = 24
    JL = 25
    JV = 26
    JT = 27
    RI = 28
    AI = 29
    BK = 30
    CB = 31
    CJ = 32
    CR = 33
    LF = 34
    NL = 35
    SA = 36
    SG = 37
    SP = 38
    XX = 39

    def pair_table(prev, char)
      @@pair_table[prev][char]
    end
    private :pair_table

    def mandatory_break
      :_
    end
    private :mandatory_break

    def breakable
      :%
    end
    private :breakable

    def combining_breakable
      :'#'
    end
    private :combining_breakable

    def combining_non_breakable
      :'@'
    end
    private :combining_non_breakable

    def non_breakable
      :^
    end
    private :non_breakable

    def initialize(db=nil)
      @db = db || Unicode::DB.new
    end

    def line_break(char)
      @db.line_break(char.ord)
    end

    def breakables(string)
      string.each_char.lazy.slice_before({}) {|char, with|
        cid = cid_map(line_break(char))
        unless with[:prev_cid]
          with[:prev_cid] = with[:last_cid] = cid_map_beginning(cid)
          next false
        end
        last_cid, prev_cid, with[:last_cid] = with[:last_cid], with[:prev_cid], cid
        do_break, with[:prev_cid] =
          if prev_cid == BK or (prev_cid == CR and not cid == LF)
            [true, cid_map_beginning(cid)]
          elsif [SP, BK, LF, NL, CR, CB].include?(cid)
            break_without_table(prev_cid, cid)
          else
            break_by_table(last_cid, prev_cid, cid)
          end
        do_break
      }.map(&:join)
    end

    def cid_map(cid)
      case cid
      when AI
        AL
      when CM, XX, SA
        AL
      when CJ
        NS
      else
        cid
      end
    end
    private :cid_map

    def cid_map_beginning(cid)
      case cid
      when LF, NL
        BK
      when CB
        BA
      when SP
        WJ
      else
        cid
      end
    end
    private :cid_map_beginning

    def break_without_table(prev_cid, cid)
      case cid
      when SP
        [false, prev_cid]
      when BK, LF, NL
        [false, BK]
      when CR
        [false, CR]
      when CB
        [true, BA]
      end
    end
    private :break_without_table

    def break_by_table(last_cid, prev_cid, cid)
      case pair_table(prev_cid, cid)
      when mandatory_break
        [true, cid]
      when breakable
        [last_cid == SP, cid]
      when non_breakable
        [false, cid]
      else
        last_cid == SP ? [true, cid] : [false, prev_cid]
      end
    end
    private :break_by_table

  end
end
