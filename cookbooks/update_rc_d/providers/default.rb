action :defaults do
  execute "updating-rc.d" do
    command "update-rc.d #{new_resource.name} defaults #{new_resource.nn}"
  end
end

action :start do
  execute "updating-rc.d" do
    command "update-rc.d #{new_resource.name} start #{new_resource.nn} #{new_resource.runlvl.join(" ")} ."
  end
end

action :stop do
  execute "updating-rc.d" do
    command "update-rc.d #{new_resource.name} stop #{new_resource.nn} #{new_resource.runlvl.join(" ")} ."
  end
end

action :remove do
  execute "updating-rc.d" do
    command "update-rc.d -f #{new_resource.name} remove"
  end
end
