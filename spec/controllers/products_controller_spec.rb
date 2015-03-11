require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  describe "root route" do
    it "routes to products#index" do
      expect(:get => '/').to route_to(:controller => "products", :action => "index")
    end
  end

  describe "GET #index" do
    it "routes correctly" do
      get :index
      expect(response.status).to eq(200)
    end

    it "renders the index template and sorts by name by default" do
      x, y = Product.create!, Product.create!
      expect(Product).to receive(:sorted_by).with("name") { [x,y] }
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:products)).to match_array([x,y])
    end
  end

  describe "GET #show" do
    it "routes correctly" do
      expect(Product).to receive(:find).with("1") { p }
      get :show, id: 1
      p = Product.new
      expect(response.status).to eq(200)
    end

    it "renders the show template" do
      expect(Product).to receive(:find).with("1") { p }
      get :show, id: 1
      expect(response).to render_template(:show)
    end
  end
  
  describe "create new product" do
    it "should show success flash message and redirect to index upon successful creation" do
      p = Product.new
      expect(Product).to receive(:new) {p}
      expect(p).to receive(:save) {true}
      post :create, {:product => {"name"=>"dummy", "price"=> "10.99"}}
      expect(response).to redirect_to(products_path)
      flash['notice'] != nil
    end
    it "should show failure flash message and redirect to new page upon failure" do
      p = Product.new
      expect(Product).to receive(:new) {p}
      expect(p).to receive(:save) {nil}
      post :create, {:product => {"name"=>"dummy", "price"=>"10.99"}}
      expect(response).to redirect_to(new_product_path)
      flash['warning'] != nil
    end
  end

  describe "update product" do
    it "should show success flash message and redirect to  upon successful update" do
      p = Product.new
      expect(Product).to receive(:find).with("1") {p}
      expect(p).to receive(:update)
      expect(p).to receive(:save) {true}
      put :update, {:id => "1", :product => {:name =>"dummy", :price =>"10.99"}}
      expect(response).to redirect_to(product_path(:id =>"1"))
      flash['notice'] != nil
    end
    it "should show failure flash message and redirect to upon failed update" do
      p = Product.new
      expect(Product).to receive(:find).with("1") {p}
      expect(p).to receive(:update)
      expect(p).to receive(:save) {nil}
      put :update, {:id=>"1", :product => {:name =>"dummy", :price =>"10.99"}}
      expect(response).to redirect_to(edit_product_path(:id =>"1"))
      flash['warning'] != nil
    end
  end
end
