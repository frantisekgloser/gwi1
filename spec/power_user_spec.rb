require 'spec_helper'
require_relative '../power_user'

describe 'PowerUser' do
  let(:email) { "john.doe@gmail.com" }
  let(:power_user) { PowerUser.new(email) }

  describe '#power_user_status: for score <20 INACTIVE_USER, 20..99 ACTIVE_USER, >100 POWER_USER' do
    let (:activities) { { "analysis_performed"=>10, "custom_audience_created"=>3, "analysis_exported"=>0, "report_downloaded"=>7 } }

    before do
      allow_any_instance_of(UserActivity).to receive(:activities).with(activities.keys).and_return(activities)
    end

    context 'when score is as in example: 10 * 5 + 3 * 4 + 0 * 2 + 7 * 1 = 69' do #example
      it { expect(power_user.status).to eql 'ACTIVE_USER' }
    end

    context 'when score is 0 * 5 + 0 * 4 + 0 * 2 + 0 * 1 = 0' do #lower limit of INACTIVE_USER
      let (:activities) { { "analysis_performed"=>0, "custom_audience_created"=>0, "analysis_exported"=>0, "report_downloaded"=>0 } }

      it { expect(power_user.status).to eql 'INACTIVE_USER' }
    end

    context 'when score is 3 * 5 + 1 * 4 + 0 * 2 + 0 * 1 = 19' do #upper limit of INACTIVE_USER
      let (:activities) { { "analysis_performed"=>3, "custom_audience_created"=>1, "analysis_exported"=>0, "report_downloaded"=>0 } }

      it { expect(power_user.status).to eql 'INACTIVE_USER' }
    end

    context 'when score is 3 * 5 + 1 * 4 + 0 * 2 + 1 * 1 = 20' do #lower limit of ACTIVE_USER
      let (:activities) { { "analysis_performed"=>3, "custom_audience_created"=>1, "analysis_exported"=>0, "report_downloaded"=>1 } }

      it { expect(power_user.status).to eql 'ACTIVE_USER' }
    end

    context 'when score is 10 * 5 + 10 * 4 + 4 * 2 + 1 * 1 = 99' do #upper limit of ACTIVE_USER
      let (:activities) { { "analysis_performed"=>10, "custom_audience_created"=>10, "analysis_exported"=>4, "report_downloaded"=>1 } }

      it { expect(power_user.status).to eql 'ACTIVE_USER' }
    end

    context 'when score is 10 * 5 + 10 * 4 + 4 * 2 + 2 * 1 = 100' do #lower limit of POWER_USER
      let (:activities) { { "analysis_performed"=>10, "custom_audience_created"=>10, "analysis_exported"=>4, "report_downloaded"=>2 } }

      it { expect(power_user.status).to eql 'POWER_USER' }
    end

    context 'with changed criteria - only the 3rd from default key activities is requested: 20 * 2 = 40' do
      let (:key_activities) { { "analysis_exported"=>2 } }
      let (:activities) { { "analysis_exported"=>20 } }

      it { expect(power_user.status(key_activities)).to eql 'ACTIVE_USER' }
    end

  end

end