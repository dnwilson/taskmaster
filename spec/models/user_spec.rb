require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "#email" do
    context "when nil" do
      let(:user) { build(:user, email: nil) }

      before { user.valid? }
      it { expect(user.errors[:email]).to include("can't be blank")}
    end

    context "when incorrectly formatted" do
      let(:user) { build(:user, email: %w[email email.com @foo.com].sample) }

      before { user.valid? }

      it { expect(user.errors[:email]).to include("is invalid")}
    end

    context "when email already exists" do
      let(:existing_user) { create(:user) }
      let(:user) { build(:user, email: existing_user.email) }

      before { user.valid? }

      it { expect(user.errors[:email]).to include("has already been taken")}
    end
  end
end
