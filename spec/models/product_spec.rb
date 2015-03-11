require 'rails_helper'

RSpec.describe Product, type: :model do
  context "The age_range method should create a user-friendly string" do
    it "should have an 'age_range' that creates a user-friendly string" do
      p = Product.new
      expect(p).to respond_to(:age_range)
    end

    it "should return '0 and above' if neither min or max is set" do
      p = Product.new
      expect(p.age_range).to eq("0 and above")
    end

    it "should return '1 to 3' if min is set to 1 and max is set to 3" do
      p = Product.new
      p.minimum_age_appropriate = 1
      p.maximum_age_appropriate = 3
      expect(p.age_range).to eq("1 to 3")
    end

    it "should return '1 and above' if min is set to 1 but max is not set" do
      p = Product.new
      p.minimum_age_appropriate = 1
      expect(p.age_range).to eq("1 and above")
    end

    it "should return '1 and above' if min is set to 1 but max is not set" do
      p = Product.new
      p.minimum_age_appropriate = 1
      p.maximum_age_appropriate = 1
      expect(p.age_range).to eq("Age 1")
    end

  end

  context "The age_appropriate? predicate should determine whether a toy is age-appropriate or not" do
    it "should have an 'age_appropriate?' predicate method" do
      p = Product.new
      expect(p).to respond_to(:age_appropriate?)
    end

    it "should return true to any age if neither min/max are set" do
      p = Product.new
      0.upto(10) { |a| expect(p.age_appropriate?(a)).to be true }
    end

    it "should check that the age is >= to min if min is set but max isn't" do
      p = Product.new
      p.minimum_age_appropriate = 3
      3.upto(10) { |a| expect(p.age_appropriate?(a)).to be true }
      0.upto(2) { |a| expect(p.age_appropriate?(a)).to be false }
    end

    it "should return false if the specified age is less than 0" do
      p = Product.new
      expect(p.age_appropriate?(-10)).to be false
    end

    it "should check that the age is between (inclusive) min and max if both min and max are set" do
      p = Product.new
      p.minimum_age_appropriate = 3
      p.maximum_age_appropriate = 6
      3.upto(6) { |a| expect(p.age_appropriate?(a)).to be true }
      0.upto(2) { |a| expect(p.age_appropriate?(a)).to be false }
      7.upto(10) { |a| expect(p.age_appropriate?(a)).to be false }
    end
  end

  context "the sorted_by method" do
    it "should exist" do
      expect(Product).to respond_to(:sorted_by)
    end

    it "should call the right underlying ActiveRecord method to do default sort" do
      expect(Product).to receive(:order).with("name") 
      Product.sorted_by("name")
    end

    it "should call the right underlying ActiveRecord method to sort by price" do
      expect(Product).to receive(:order).with("price") 
      Product.sorted_by("price")
    end

    it "should handle the situation when a bogus sort column is given" do
      expect(Product).to receive(:order).with("name") 
      Product.sorted_by("bogus_column")
    end
  end

end
