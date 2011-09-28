require 'spec_helper'

module Importable
  describe Row do
    it "should initialize key from a hash if it's passed to #new" do
      row = Importable::Row.new({
        a: 1,
        b: 2,
        c: 3
      })
      row.keys.should eq [:a, :b, :c]
    end
    
    it "should export keys via attributes" do
      row = Importable::Row.new({
        moof: 1,
        Doof: 2,
        FOOF: 3,
      })
      row.moof.should eq 1
      row.Doof.should eq 2
      row.FOOF.should eq 3
    end

    it "should export keys via lowercase attribute names" do
      row = Importable::Row.new({
        moof: 1,
        Doof: 2,
        FOOF: 3,
      })
      row.moof.should eq 1
      row.doof.should eq 2
      row.foof.should eq 3
    end
    
    describe "self#from_resource" do
      it "builds a row from the resource's attributes" do
        start_fake_foo_api

        resource = FooResource.find(1)

        row = Importable::Row.from_resource(resource)
        row.keys.should eq [:id, :foo_date]
      end
    end

    describe "self#from_hash" do
      it "does nothing but creates a new row from the hash" do
        row = Importable::Row.from_hash({
          moof: 'doof',
          foo: 'bar'
        })
        row.keys.should eq [:moof, :foo]
      end
    end
  end
end
