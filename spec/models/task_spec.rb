require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  describe "#title" do
    context "when nil" do
      let(:task) { build(:task, title: nil) }

      before { task.valid? }

      it { expect(task.errors[:title]).to include("can't be blank") }
    end

    context "when longer than 100 characters" do
      let(:task) { build(:task, title: Faker::Lorem.paragraph_by_chars(number: 101, supplemental: false)) }

      before { task.valid? }

      it { expect(task.errors[:title]).to include("is too long (maximum is 100 characters)") }
    end
  end

  describe "#status" do
    let(:task) { build(:task, completed_at: completed_at) }

    context "when incomplete" do
      let(:completed_at) { nil }
      it { expect(task.status).to eq("incomplete") }
    end

    context "when completed" do
      let(:completed_at) { Time.current }

      it { expect(task.status).to eq("completed") }
    end
  end
end
