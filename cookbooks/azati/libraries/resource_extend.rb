class Chef
  class Resource

    def read_setting(message)
      Chef::Log.info message
      readline.strip
    end

  end
end