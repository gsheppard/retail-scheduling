class WeeksController < ApplicationController

  def index
    @weeks = Week.where(user: current_user)
    @week = Week.new

    @upcoming = []
    4.times do |n|
      @upcoming << DateTime.now.beginning_of_week(:sunday) + n.weeks
    end
  end

  def edit
    @week = Week.find(params[:id])
    @shifts = build_employee_shifts

    @weekdays = []
    7.times do |n|
      @weekdays << @week.week_start + n.days
    end

  end

  def update
    @week = Week.find(params[:id])
    @shifts = build_employee_shifts
    shift_data = {}

    shifts_params.each do |employee, shifts|
      employee_id = employee.gsub(/\D/, '').to_i
      # shifts format is shift_{weekday}_{id}
      shifts.each do |id, startend|
        # startend["start_time"] and startend["end_time"]
        shift_id = id.split('_')[1..2]
        # shift_id[0] is weekday, shift_id[1] is schedule.id

        start_time = s_to_time(@week.week_start, startend["start_time"]) + shift_id[0].to_i.days
        end_time = s_to_time(@week.week_start, startend["end_time"]) + shift_id[0].to_i.days

        s = Schedule.find(shift_id[1])
        if s.start_time != start_time || s.end_time != end_time
          s.update_attributes(start_time: start_time, end_time: end_time)
        end
      end
    end

    redirect_to edit_week_path(@week)
  end

  def create
    @week = Week.new(week_params)
    @employees = Employee.where(user: current_user)

    if @week.save
      @employees.each do |emp|
        7.times do |n|
          Schedule.create(
            employee: emp,
            week: Week.where(week_start: @week.week_start).first,
            start_time: @week.week_start + n.days,
            end_time: @week.week_start + n.days
          )
        end
      end

      redirect_to edit_week_path(@week), notice: 'Schedule created successfully.'
    else
      redirect_to weeks_path, alert: 'Oops! Something happened.'
    end
  end

  private
  def week_params
    params.require(:week).permit(:week_start).merge(user: current_user)
  end

  def shifts_params
    params.require(:week)
  end

  def s_to_time(week, time)
    # week is the seed data for year/month/day
    # time is the time formatted as 5:15 PM
    hour = time.gsub(/\s/, '').match(/\A\d{1,2}/).to_s.to_i
    minute = time.match(/\:\d{2}/).to_s.gsub(':', '').to_i

    DateTime.new(
      week.year,
      week.month,
      week.day,
      hour,
      minute
    )
  end

  def build_employee_shifts
    week = Week.find(params[:id])
    schedules = Schedule.where(week: week)
    employees = Employee.where(user: current_user)

    shifts = {}
    employees.each do |emp|
      shifts[emp] ||= []

      schedules.each do |sched|
        if sched.employee == emp
          shifts[emp] << sched
        end
      end
    end

    shifts
  end

end
