module Unicode

  module Linebreak

    class DB

      def initialize
        JSON.parse(File.read('ucd_db.json'))
      end


    end

  end
end
