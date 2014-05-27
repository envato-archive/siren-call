require 'spec_helper'

describe SirenCall::Entity do
  let(:hash) do
    {
      "class" => [ "order" ],
      "properties" => { 
          "orderNumber" => 42, 
          "itemCount" => 3,
          "status" => "pending"
      },
      "entities" => [
        { 
          "class" => [ "items", "collection" ], 
          "rel" => [ "http://x.io/rels/order-items" ], 
          "href" => "http://api.x.io/orders/42/items"
        },
        {
          "class" => [ "info", "customer" ],
          "rel" => [ "http://x.io/rels/customer" ], 
          "properties" => { 
            "customerId" => "pj123",
            "name" => "Peter Joseph"
          },
          "links" => [
            { "rel" => [ "self" ], "href" => "http://api.x.io/customers/pj123" }
          ]
        }
      ]
    }
  end

  describe ".parse" do
    context "passing a basic entity" do

      it "loads in the class" do
        expect(described_class.parse(hash).classes).to eql ["order"]
      end

      it "loads in the properties" do
        expect(described_class.parse(hash).properties).to eql("orderNumber" => 42, "itemCount" => 3, "status" => "pending")
      end

      it "loads in the entities" do
        expect(described_class.parse(hash).entities).to have(2).entities
      end
    end
  end

  describe "#entities_by_class" do
    subject(:entity) { described_class.parse(hash) }

    it "finds the items class" do
      expect(entity.entities_by_class("items")).to have(1).entity
    end

    it "returns empty array when nothing found" do
      expect(entity.entities_by_class("item")).to have(0).entities
    end
  end
end