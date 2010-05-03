class Chef
  class Node
    class Attribute
      def generate_random_password(length = 20)
        `</dev/urandom tr -dc A-Za-z0-9|head -c #{length}`.strip
      end
    end
  end
end