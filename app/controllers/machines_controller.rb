class MachinesController < ApplicationController
  before_action :set_machine, only: [:show, :edit, :update, :destroy]
  
  # GET /machines
  # GET /machines.json
  def index
    @machines = Machine.all
    p current_user
  end

  # GET /machines/1
  # GET /machines/1.json
  def show
  end

  # GET /machines/new
  def new
    @machine = Machine.new
    @machine.connections.build
  end

  # GET /machines/1/edit
  def edit
  end
  
  # POST /machines
  # POST /machines.json
  def create
    # Read SSH-key from file
    connections = params[:machine][:connections_attributes]
    connections.each do |num,file|
      ssh_key_file = file[:ssh_key]
      params[:machine][:connections_attributes][num][:ssh_key] = ssh_key_file.tempfile.read
    end
    
    @machine = Machine.new(machine_params)
    # User connects to the machine
    @machine.users << current_user if current_user
    respond_to do |format|
      if @machine.save
        format.html { redirect_to @machine, notice: 'Machine was successfully created.' }
        format.json { render :show, status: :created, location: @machine }
      else
        format.html { render :new }
        format.json { render json: @machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machines/1
  # PATCH/PUT /machines/1.json
  def update
    respond_to do |format|
      if @machine.update(machine_params)
        format.html { redirect_to @machine, notice: 'Machine was successfully updated.' }
        format.json { render :show, status: :ok, location: @machine }
      else
        format.html { render :edit }
        format.json { render json: @machine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /machines/1
  # DELETE /machines/1.json
  def destroy
    @machine.destroy
    respond_to do |format|
      format.html { redirect_to machines_url, notice: 'Machine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def machine_params
      params.require(:machine).permit(
      :ssh_user, :ssh_host, :cpu, :number_of_cores, :cpu_max_freq, :kernel, :hostname, :architecture, :memory_total, :memory_used, :memory_type,
      connections_attributes: [:id, :ssh_key, :passphrase]
    )
    end
end
