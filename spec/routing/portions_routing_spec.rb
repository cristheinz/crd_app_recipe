require "spec_helper"

describe PortionsController do
  describe "routing" do

    it "routes to #index" do
      get("/portions").should route_to("portions#index")
    end

    it "routes to #new" do
      get("/portions/new").should route_to("portions#new")
    end

    it "routes to #show" do
      get("/portions/1").should route_to("portions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/portions/1/edit").should route_to("portions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/portions").should route_to("portions#create")
    end

    it "routes to #update" do
      put("/portions/1").should route_to("portions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/portions/1").should route_to("portions#destroy", :id => "1")
    end

  end
end
