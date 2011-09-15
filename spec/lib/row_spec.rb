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
  end
end
