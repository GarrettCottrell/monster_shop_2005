require 'rails_helper'

describe Discount, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
  end
end
