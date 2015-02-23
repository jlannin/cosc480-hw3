require 'rails_helper'

RSpec.describe "index page", type: :feature do
  let(:price_sort) { ["coconut borer", "apple corer", "banana peeler", "donut holer" ] }
  let(:age_sort) { [ "coconut borer", "donut holer", "banana peeler", "apple corer" ] }

  before :each do
    Product.create!(:name => "apple corer", :description => "nada", :price => 1.99, :minimum_age_appropriate => 3)
    Product.create!(:name => "banana peeler", :description => "nada", :price => 2.99, :minimum_age_appropriate => 2, :maximum_age_appropriate => 2)
    Product.create!(:name => "coconut borer", :description => "nada", :price => 0.99)
    Product.create!(:name => "donut holer", :description => "nada", :price => 50.00, :minimum_age_appropriate => 1, :maximum_age_appropriate => 6)

    visit "/products"
  end

  it "should show the products in name order by default" do
    names = []
    page.all(".productname").each { |x| names << x.text}
    expect(names).to match_array(names.sort)
  end

  it "should show the products in correct price order when sorting by price" do
    names = []
    click_link("Price")
    page.all(".productname").each { |x| names << x.text }
    expect(names).to match_array(price_sort)
  end

  it "should show the products in correct age order when sorting by age" do
    names = []
    click_link("Appropriate age")
    page.all(".productname").each { |x| names << x.text }
    expect(names).to match_array(age_sort)
  end

  it "should show the products in correct name order when sorting by name" do
    names = []
    click_link("Name")
    page.all(".productname").each { |x| names << x.text }
    expect(names).to match_array(names.sort)
  end
end
