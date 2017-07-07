class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :first_name, :last_name, presence: true
  
  def self.connect(params)
    # Read SSH-key from file
    private_key_data = params[:private_key].tempfile.read
    host = params[:host]
    user = params[:user]
    passphrase = params[:passphrase]
    process_name = params[:process_name]
    output = ""
    Net::SSH.start(host, user, port: "3022", key_data: [private_key_data], passphrase: passphrase) do |ssh|
      output = ssh.exec!("uname -r")
    end
    return output
  end
end
