json.extract! machine, :id, :ssh_user, :ssh_host, :cpu, :number_of_cores, :cpu_max_freq, :kernel, :hostname, :architecture, :memory_total, :memory_used, :memory_type, :created_at, :updated_at
json.url machine_url(machine, format: :json)
