class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :first_name, :last_name, presence: true
  
  def self.connect(params)
    # Read SSH-key from file
    private_key_data = params[:private_key].present? ? params[:private_key].tempfile.read : ""
    host = params[:host]
    user = params[:user]
    passphrase = params[:passphrase]
    process_name = params[:process_name]
    used_port = params[:used_port]
    
    tmp_script_name = ".#{SecureRandom.urlsafe_base64}.py"
    remote_path = "./"
    json_file_path = "#{remote_path}process_#{process_name}.json"
    output = ""
    json_file_data = ""
    
    Net::SCP.upload!(host, user, "#{Rails.root}/vendor/process_info.py", remote_path + tmp_script_name, :ssh => { key_data: [private_key_data], passphrase: passphrase })
    Net::SSH.start(host, user, key_data: [private_key_data], passphrase: passphrase) do |ssh|
      output = ssh.exec! "python2.7 #{remote_path}#{tmp_script_name} -j #{process_name} #{used_port}"
      json_file = ssh.exec! "cat #{json_file_path} 2>/dev/null"
      json_file_data = json_file.present? ? JSON.parse(json_file) : nil
      ssh.exec! "rm #{remote_path}{tmp_script_name}"
    end
    return [output, json_file_data]
  rescue => e
    p e
    return ["Something went wrong",""]
  end
end
