require 'spec_helper'

feature 'manager adds positions', %q{
  As a manager
  I want to be able to add Positions
  So I can create new positions for my employees
} do

  # Acceptance Criteria
  # - Form for adding new position
  # - Only takes a name

  scenario 'add new position with valid attributes' do
    visit employee_path
  end

  scenario 'attempt new positions with invalid attributes'

end
