require 'rails_helper'

RSpec.describe Task, type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:task, user_id: user.id) }
  let(:invalid_attributes) { attributes_for(:task, title: nil, user_id: user.id) }

  describe "GET /api/v1/tasks" do
    it "renders a successful response" do
      task = create(:task, :with_user)
      get "/api/v1/tasks"
      expect(response).to be_successful
    end
  end

  describe "GET /api/v1/tasks/:id" do
    let(:task) { create(:task, :with_user) }

    it "returns a successful response" do
      get "/api/v1/tasks/#{task.id}"
      expect(response).to be_successful
    end

    it "returns the requested task" do
      get "/api/v1/tasks/#{task.id}"
      expect(response.body).to eq(TaskSerializer.new(task).to_json)
    end
  end

  describe "POST /api/v1/tasks" do
    context "with valid attributes" do
      it "creates a new task" do
        expect {
          post "/api/v1/tasks", params: { task: valid_attributes }, as: :json
        }.to change(Task, :count).by(1)
      end
    end

    context "with invalid attributes" do
      it "DOES NOT create a new task" do
        expect {
          post "/api/v1/tasks", params: { task: invalid_attributes }, as: :json
        }.not_to change(Task, :count)
      end

      it "returns an error" do
        post "/api/v1/tasks", params: { task: invalid_attributes }, as: :json
        expect(response).to be_unprocessable
      end
    end
  end

  describe "DELETE /api/v1/tasks/:id" do
    let!(:task) { create(:task, :with_user) }

    it "returns a successful response" do
      delete "/api/v1/tasks/#{task.id}"
      expect(response).to be_successful
    end

    it "deletes the requested task" do
      expect { delete "/api/v1/tasks/#{task.id}"}.to change(Task, :count).by(-1)
    end
  end


  describe "PATCH /api/v1/tasks/:id" do
    let(:task) { create(:task, :with_user, completed_at: nil) }
    let(:updated_attributes) { { completed_at: Time.current } }

    context "with valid attributes" do
      it "update the task" do
        patch "/api/v1/tasks/#{task.id}", params: { task: updated_attributes }, as: :json
        expect(task.reload.status).to eq("completed")
      end
    end

    context "with invalid attributes" do
      let(:updated_attributes) { { user_id: nil } }

      it "returns an error" do
        patch "/api/v1/tasks/#{task.id}", params: { task: updated_attributes }, as: :json
        expect(response).to be_unprocessable
      end
    end
  end
end