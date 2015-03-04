require 'json'
require 'json/add/core'

module Unicode

  class CharacterDB

    class Table
      def initialize(hash)
        @range_table = hash[:r]
        @index_table = hash[:i]
      end
      def find(code)
        Array(
          @index_table.find {|_, values| values.include?(code) } ||
          @range_table.find {|_, values| values.find {|value| value === code }}
        ).first
      end
    end

    def initialize
      @east_asian_width = Table.new(load_db('ucd_east_asian_width'))
      @line_break = Table.new(load_db('ucd_line_break'))
    end

    def load_db(db_file)
      if File.exist?("#{db_file}.db")
        Marshal.load(File.binread("#{db_file}.db"))
      else
        JSON.load(File.read("#{db_file}.json"), method(:hash_symbolize_key)).tap do |db|
          File.binwrite("#{db_file}.db", Marshal.dump(db))
        end
      end
    end

    def hash_symbolize_key(h)
      h.keys.each {|k| (h[k.to_sym] = h[k]) and h.delete(k)} if Hash === h
    end
    private :hash_symbolize_key

    def line_break(code)
      @line_break.find(code)
    end

  end
end

db = Unicode::CharacterDB.new
p db.line_break('あ'.ord)
p db.line_break('→'.ord)
