require 'spec_helper'

describe Employee do

  context 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :user }
    it { should validate_presence_of :position }
    it { should validate_presence_of :work_type }

    it { should have_valid(:work_type).when('FT', 'PT') }
    it { should_not have_valid(:work_type).when(nil, '', 'Full Time', 'Part') }

    it { should have_valid(:email).when('email@email.com', 'name.last@sub.domain.edu') }
    it { should_not have_valid(:email).when(nil, '', 'hello', 'email@com', 'first.last') }
  end

  context 'associations' do
    it { should belong_to :user }
    it { should belong_to :position }
  end

  context 'methods' do
    it 'should have a full name' do
      user = FactoryGirl.build(:employee)

      expect(user.full_name).to eq(user.first_name + ' ' + user.last_name)
    end
  end

end
