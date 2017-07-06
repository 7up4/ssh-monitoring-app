require 'test_helper'

class MachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @machine = machines(:one)
  end

  test "should get index" do
    get machines_url
    assert_response :success
  end

  test "should get new" do
    get new_machine_url
    assert_response :success
  end

  test "should create machine" do
    assert_difference('Machine.count') do
      post machines_url, params: { machine: { architecture: @machine.architecture, cpu: @machine.cpu, cpu_max_freq: @machine.cpu_max_freq, hostname: @machine.hostname, kernel: @machine.kernel, memory_total: @machine.memory_total, memory_type: @machine.memory_type, memory_used: @machine.memory_used, number_of_cores: @machine.number_of_cores, ssh_host: @machine.ssh_host, ssh_user: @machine.ssh_user } }
    end

    assert_redirected_to machine_url(Machine.last)
  end

  test "should show machine" do
    get machine_url(@machine)
    assert_response :success
  end

  test "should get edit" do
    get edit_machine_url(@machine)
    assert_response :success
  end

  test "should update machine" do
    patch machine_url(@machine), params: { machine: { architecture: @machine.architecture, cpu: @machine.cpu, cpu_max_freq: @machine.cpu_max_freq, hostname: @machine.hostname, kernel: @machine.kernel, memory_total: @machine.memory_total, memory_type: @machine.memory_type, memory_used: @machine.memory_used, number_of_cores: @machine.number_of_cores, ssh_host: @machine.ssh_host, ssh_user: @machine.ssh_user } }
    assert_redirected_to machine_url(@machine)
  end

  test "should destroy machine" do
    assert_difference('Machine.count', -1) do
      delete machine_url(@machine)
    end

    assert_redirected_to machines_url
  end
end
