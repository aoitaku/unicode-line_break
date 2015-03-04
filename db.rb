require 'json'
require 'json/add/core'

module Unicode

  class CharacterDB

    def initialize
      @east_asian_width = load_db('ucd_east_asian_width')
      @line_break = load_db('ucd_line_break')
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
      Array(@line_break[:i].find {|_, values|
        values.include?(code)
      }).first or
      Array(@line_break[:r].find {|_, values|
        values.find {|value| value === code }
      }).first
    end

  end
end

db = Unicode::CharacterDB.new
p db.line_break('あ'.ord)
p db.line_break('→'.ord)
