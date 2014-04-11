class Week < ActiveRecord::Base
  belongs_to :user
  has_many :schedules, dependent: :destroy

  validates :week_start, uniqueness: { scope: :user,
    message: "Only 1 set of schedules for a given week" }
end
