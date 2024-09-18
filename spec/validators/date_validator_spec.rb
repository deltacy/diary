require 'rails_helper'

RSpec.describe DateValidator do
  let(:test_date_validator) do
    Class.new do
      include ActiveModel::Validations
      include ActiveModel::Model

      validates :date, date: true
    end
  end
  let(:model) { TestDateValidator.new(date:) }
  let(:date) { nil }

  before do
    stub_const('TestDateValidator', test_date_validator)
  end

  context 'configurable validations' do
    context 'when after_or_equal_to: :field' do
      let(:test_date_validator) do
        Class.new do
          include ActiveModel::Validations
          include ActiveModel::Model

          attr_accessor :date, :other_date

          validates :other_date, date: { after_or_equal_to: :date }
        end
      end

      let(:model) { TestDateValidator.new(date:, other_date:) }

      context 'when the date is after the provided field date' do
        let(:date) { Time.zone.today - 2.months }
        let(:other_date) { Time.zone.today - 5.months }

        it 'returns :before error' do
          expect(model).not_to be_valid
          expect(model.errors[:other_date]).to contain_exactly(I18n.t('errors.messages.after_or_equal_to',
                                                                      attribute: :other_date, compared_attribute: :date))
        end
      end
    end
  end
end
