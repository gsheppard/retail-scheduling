class SchedulesController < ApplicationController
  def index
  end

  def show
  end

  def week
    @schedule = Schedule.new

    @sunday = int_to_time(params[:sunday])
    @upcoming_weeks = []
    4.times { |x| @upcoming_weeks << @sunday + (x+1).weeks }
    @weekdays = [@sunday]
    6.times { |x| @weekdays << @sunday + (x+1).days }

    @schedules = Schedule.where(user: current_user).where(start_time: @sunday..(@sunday + 6.days))
    @employees = Employee.where(user: current_user)

    @shifts = {}
    7.times do |day_index|
      @schedules.each do |sched|
        @shifts[sched.employee] ||= []

        if sched.start_time.wday == day_index
          @shifts[sched.employee][day_index] ||= sched
        else
          @shifts[sched.employee][day_index] ||= Schedule.new(employee: sched.employee)
        end
      end
    end

  end

  def week_create
    sunday = params[:create_schedules][:weeks].match(/(\d{4}\-\d{2}\-\d{2})/).to_s.split('-')
    sunday.map! { |x| x.to_i }

    @employees = Employee.where(user: current_user)

    @employees.each do |emp|
      7.times do |num|

        Schedule.create(
          user: current_user,
          employee: emp,
          start_time: DateTime.new(sunday[0], sunday[1], sunday[2]+num),
          end_time: DateTime.new(sunday[0], sunday[1], sunday[2]+num)
          )
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

  #############################
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
