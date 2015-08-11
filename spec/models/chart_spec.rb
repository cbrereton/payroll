require 'filter_employees'

describe FilterEmployees do
  let(:chart) { HistoryChart.new(params) }

  context 'Filtering on employment status' do

    let!(:current) { create :employee, start_date: Date.today - 1, end_date: Date.today + 1 }
    let!(:past) { create :employee, start_date: Date.today - 10, end_date: Date.today - 1 }
    let!(:future) { create :employee, start_date: Date.today + 10 }

    context 'include only past employees' do
      let(:params) { {employment: {past: 1}} }
      it 'excludes current and future employees' do
        expect(chart.filtered_collection(params)).not_to include current
        expect(chart.filtered_collection(params)).not_to include future
      end
      it 'includes past employees' do
        expect(chart.filtered_collection(params)).to include past
      end
    end

    context 'include only current employees' do
      let(:params) { {employment: {current: 1}} }
      it 'excludes past and future employees' do
        expect(chart.filtered_collection(params)).not_to include past
        expect(chart.filtered_collection(params)).not_to include future
      end
      it 'includes current employees' do
        expect(chart.filtered_collection(params)).to include current
      end
    end

    context 'include only future employees' do
      let(:params) { {employment: {future: 1}} }
      it 'excludes past and current employees' do
        expect(chart.filtered_collection(params)).not_to include past
        expect(chart.filtered_collection(params)).not_to include current
      end
      it 'includes future employees' do
        expect(chart.filtered_collection(params)).to include future
      end
    end

    context 'include both current and future' do
      let(:params) { {employment: {current: 1, future: 1}} }
      it 'excludes past employees' do
        expect(chart.filtered_collection(params)).not_to include past
      end
      it 'includes current and future employees' do
        expect(chart.filtered_collection(params)).to include current
        expect(chart.filtered_collection(params)).to include future
      end
    end

    context 'include both past and current' do
      let(:params) { {employment: {past: 1, current: 1}} }
      it 'excludes future employees' do
        expect(chart.filtered_collection(params)).not_to include future
      end
      it 'includes current and past employees' do
        expect(chart.filtered_collection(params)).to include current
        expect(chart.filtered_collection(params)).to include past
      end
    end

    context 'include all' do
      context 'all checked' do
        let(:params) { {employment: {past: 1, current: 1, future: 1}} }
        it 'includes all employees' do
          expect(chart.filtered_collection(params)).to eq Employee.all
        end
      end
      context 'none checked' do
        let(:params) { {employment: nil} }
        it 'includes all employees' do
          expect(chart.filtered_collection(params)).to eq Employee.all
        end
      end
    end
  end


  context 'filtering on billable status' do
    let!(:billed) { create :employee, billable: true }
    let!(:unbilled) { create :employee, billable: false }

    context 'include only billable' do
      let(:params) { {billable: {true: 1}} }
      it 'includes billable employees' do
        expect(chart.filtered_collection(params)).to include billed
      end
      it 'excludes unbillable employees' do
        expect(chart.filtered_collection(params)).not_to include unbilled
      end
    end

    context 'include only support' do
      let(:params) { {billable: {false: 1}} }
      it 'includes unbillable employees' do
        expect(chart.filtered_collection(params)).to include unbilled
      end
      it 'excludes billable employees' do
        expect(chart.filtered_collection(params)).not_to include billed
      end
    end

    context 'include all' do
      context 'all checked' do
        let(:params) { {billable: {true: 1, false: 1}} }
        it 'includes all employees' do
          expect(chart.filtered_collection(params)).to eq Employee.all
        end
      end
      context 'none checked' do
        let(:params) { {billable: nil} }
        it 'includes all employees' do
          expect(chart.filtered_collection(params)).to eq Employee.all
        end
      end
    end
  end
end