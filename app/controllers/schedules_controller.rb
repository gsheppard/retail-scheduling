class SchedulesController < ApplicationController
  def index

  end

  def show
  end

  def week
    @schedule = Schedule.new

    @sunday = int_to_time(params[:sunday])
    @weekdays = [@sunday]
    6.times { |x| @weekdays << @sunday + (x+1).days }

    @schedules = Schedule.where(user: current_user).where(start_time: @sunday..(@sunday + 6.days))
    @employees = Employee.where(user: current_user)

    @emp_schedules = {}

    @schedules.each do |sched|
      @employees.each do |emp|
        if sched.employee == emp
          if !@emp_schedules[emp].is_a?(Array)
            @emp_schedules[emp] = [sched]
          else
            @emp_schedules[emp] << sched
          end
        end
      end
    end

  end

  def create
    @schedule = Schedule.new(schedule_params.merge(user: current_user))

    if @schedule.save
      redirect_to schedule_week_path(sunday_before(@schedule.start_time))
    else

    end
  end

  private
  def int_to_time(int)
    int = int.to_s.split('')
    Time.new(int[0..3].join, int[4..5].join, int[6..7].join)
  end

  def schedule_params
    params.require(:schedule).permit(:start_time, :end_time, :employee_id)
  end

  def sunday_before(datetime)
    (datetime - datetime.wday.days).to_s.match(/(\d{4}\-\d{2}\-\d{2})/).to_s.gsub('-', '')
  end
end
