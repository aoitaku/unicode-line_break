require 'json'
require 'json/add/core'

module Unicode

  class DB

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

      def self.load(file)
        self.new(load_from_file(file))
      end

      def self.load_from_file(file)
        if File.exist?("#{file}.db")
          load_from_db("#{file}.db")
        else
          load_from_json("#{file}.json").tap do |db|
            File.binwrite("#{file}.db", Marshal.dump(db))
          end
        end
      end

      def self.load_from_db(db)
        Marshal.load(File.binread(db))
      end

      def self.load_from_json(json)
        JSON.load(File.read(json), method(:hash_symbolize_key))
      end

      def self.hash_symbolize_key(h)
        h.keys.each {|k| (h[k.to_sym] = h[k]) and h.delete(k)} if Hash === h
      end

      def initialize(hash)
        @range_table = RangeTable.new(hash[:r])
        @index_table = IndexTable.new(hash[:i])
      end

      def find(code)
        @index_table.find(code) or @range_table.find(code)
      end

    end

    def initialize
      @east_asian_width = CharacterDB.load('ucd_east_asian_width')
      @line_break = CharacterDB.load('ucd_line_break')
    end

    def line_break(code)
      @line_break.find(code)
    end

  end
end

db = Unicode::DB.new
p db.line_break('あ'.ord)
p db.line_break('→'.ord)
