require 'readline'

class Chef
  class Resource

    def read_setting(message)
      Chef::Log.info message
      ::Readline.readline('> ', false)
    end

  end
end
