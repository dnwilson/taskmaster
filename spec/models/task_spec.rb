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

  describe ".search" do
    let!(:task_1) { create(:task, :with_user, title: "Hello World!") }
    let!(:task_2) { create(:task, :with_user, description: "hello Ruby on Rails!") }
    let(:search) { Task.search(term) }
    
    context "with matching term" do
      let(:term) { "Hello" }
      
      it { expect(search).to eq([task_1, task_2]) }
    end
    
    context "with NO matching term" do
      let(:term) { "goodbye" }
      
      it { expect(search).to eq([]) }
    end
  end
end
