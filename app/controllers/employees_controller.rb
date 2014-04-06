class EmployeesController < ApplicationController
  before_filter :authenticated?

  def index
    @employees = current_user.employees
    @employee = Employee.new

    @positions = current_user.positions
    @position = Position.new
  end

  def create
    @employee = Employee.new(employee_params.merge(user: current_user))

    if @employee.save
      redirect_to employees_path, notice: 'Employee created'
    else
      redirect_to employees_path, alert: 'Employee not saved'
    end
  end

  private
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :email, :position_id, :work_type)
  end
end
