require 'json'
require 'json/add/core'

module Unicode

  class DB

    CLASSES = {
      OP: 0,
      CL: 1,
      CP: 2,
      QU: 3,
      GL: 4,
      NS: 5,
      EX: 6,
      SY: 7,
      IS: 8,
      PR: 9,
      PO: 10,
      NU: 11,
      AL: 12,
      HL: 13,
      ID: 14,
      IN: 15,
      HY: 16,
      BA: 17,
      BB: 18,
      B2: 19,
      ZW: 20,
      CM: 21,
      WJ: 22,
      H2: 23,
      H3: 24,
      JL: 25,
      JV: 26,
      JT: 27,
      RI: 28,
      AI: 29,
      BK: 30,
      CB: 31,
      CJ: 32,
      CR: 33,
      LF: 34,
      NL: 35,
      SA: 36,
      SG: 37,
      SP: 38,
      XX: 39
    }

    class Table

      def initialize(table)
        @table = table
      end

    end

    class IndexTable < Table

      def find(code)
        Array(@table.find {|_, values|
          values.include?(code)
        }).first
      end

    end

    class RangeTable < Table

      def find(code)
        Array(@table.find {|_, values|
          values.find {|value| value === code }
        }).first
      end

    end

    class CharacterDB

      class << self

        def load(file)
          self.new(load_from_file(file))
        end

        def load_from_file(file)
          if File.exist?("#{file}.db")
            load_from_db("#{file}.db")
          else
            load_from_json("#{file}.json").tap do |db|
              File.binwrite("#{file}.db", Marshal.dump(db))
            end
          end
        end
        private :load_from_file

        def load_from_db(db)
          Marshal.load(File.binread(db))
        end
        private :load_from_db

        def load_from_json(json)
          JSON.load(File.read(json), method(:hash_symbolize_key))
        end
        private :load_from_json

        def hash_symbolize_key(h)
          h.keys.each {|k| (h[k.to_sym] = h[k]) and h.delete(k)} if Hash === h
        end
        private :hash_symbolize_key

      end

      def initialize(hash)
        @range_table = RangeTable.new(hash[:r])
        @index_table = IndexTable.new(hash[:i])
      end

      def find(code)
        Unicode::DB.sym2cid(@index_table.find(code) || @range_table.find(code) || :XX)
      end

    end

    class << self

      def symbol_to_classid(symbol)
        CLASSES[symbol]
      end
      alias sym2cid symbol_to_classid
  
      def classid_to_symbol(classid)
        CLASSES.key(classid)
      end
      alias cid2sym classid_to_symbol

    end

    def initialize
      @east_asian_width = CharacterDB.load('ucd_east_asian_width')
      @line_break = CharacterDB.load('ucd_line_break')
    end

    def line_break(code)
      @line_break.find(code)
    end

    def east_asian_width(code)
      @east_asian_width.find(code)
    end

  end
end
