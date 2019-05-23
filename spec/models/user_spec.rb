require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  let(:user) { build(:user) }

  context "validations" do

  	it "requires a name" do
  		expect(user).to validate_presence_of :name
  	end

  	it "requires a last name" do
  		expect(user).to validate_presence_of :last_name
  	end

  end

  context "associations" do

    it { expect(user).to have_many(:payments).dependent(:destroy) }
    it { expect(user).to have_many(:subscriptions).dependent(:destroy) }

  end

  context "attributes" do

  	it "has a name" do
  		expect(build(:user, name: "test-name")).to have_attributes(name: "test-name")
  	end

  	it "has a last name" do
  		expect(build(:user, last_name: "test-last-name")).to have_attributes(last_name: "test-last-name")
  	end

  end

  context "callbacks" do

  end

  context "scopes" do

  end

  describe "public instance methods" do

    context "responds to its methods" do
      it { expect(user).to respond_to(:name) }
      it { expect(user).to respond_to(:last_name) }
      it { expect(user).to respond_to(:full_name) }
      it { expect(user).to respond_to(:payment_method?) }
    end

	  context "executes methods correctly" do

	    context "#name" do

	      it "returns their name" do
	        expect(user.name).to eq("Name")
	      end

	    end

	    context "#last_name" do

	    	it "returns their last name" do
		    	expect(user.last_name).to eq("Last Name")
	    	end

	    end

      context "#full_name" do

        it "returns their full name" do
          expect(user.full_name).to eq("Name Last Name")
        end

      end

	  end

  end

  describe "public class methods" do

  end

end
