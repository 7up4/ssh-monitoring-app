class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :first_name, :last_name, presence: true
  
  def self.connect(params)
    # Read SSH-key from file
    private_key_data = params[:private_key].present? ? params[:private_key].tempfile.read : ""
    method = params[:method]
    host = params[:host]
    user = params[:user]
    port = params[:port].to_s || "22"
    password = params[:password]
    passphrase = params[:passphrase]
    process_name = params[:process_name]
    port_to_check = params[:port_to_check].to_s
    
    tmp_script_name = ".#{SecureRandom.urlsafe_base64}.py"
    remote_path = "./"
    json_file_name = "process_#{process_name}.json"
    output = ""
    json_file_data = ""
    
    if method == "By private key"
      Net::SCP.upload!(host,
                      user,
                      "#{Rails.root}/vendor/process_info.py",
                      remote_path + tmp_script_name,
                      :ssh => { port: port, key_data: [private_key_data], passphrase: passphrase, auth_methods: ['publickey'] }
                      )
      begin
        ssh_tunnel = Net::SSH.start(host, user, port: port, key_data: [private_key_data], passphrase: passphrase, auth_methods: ['publickey'])
        output = ssh_tunnel.exec! "source ~/.bashrc; source ~/.bash_profile; python2.7 #{remote_path}#{tmp_script_name} -j #{process_name} #{port_to_check}"
        json_file = ssh_tunnel.exec! "cat #{remote_path}#{json_file_name} 2>/dev/null"
        json_file_data = json_file.present? ? JSON.parse(json_file) : nil
      ensure
        ssh_tunnel.exec! "rm #{remote_path}#{tmp_script_name}"
        ssh_tunnel.exec! "rm #{remote_path}#{json_file_name}"
        ssh_tunnel.close if ssh_tunnel
      end
      return [output, json_file_data]
    else
      Net::SCP.upload!(host,
                      user,
                      "#{Rails.root}/vendor/process_info.py",
                      remote_path + tmp_script_name,
                      :ssh => { port: port, password: password, auth_methods: ['password'], number_of_password_prompts: 0 }
                      )
      begin
        ssh_tunnel = Net::SSH.start(host, user, port: port, password: password, auth_methods: ['password'], number_of_password_prompts: 0)
        output = ssh_tunnel.exec! "source ~/.bashrc; source ~/.bash_profile; python2.7 #{remote_path}#{tmp_script_name} -j #{process_name} #{port_to_check}"
        json_file = ssh_tunnel.exec! "cat #{remote_path}#{json_file_name} 2>/dev/null"
        json_file_data = json_file.present? ? JSON.parse(json_file) : nil
      ensure
        ssh_tunnel.exec! "rm #{remote_path}#{tmp_script_name}"
        ssh_tunnel.exec! "rm #{remote_path}#{json_file_name}"
        ssh_tunnel.close if ssh_tunnel
      end
      return [output, json_file_data]
    end
  rescue => e
    return ["#{e.to_s}",""]
  end
end
