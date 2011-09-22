require 'spec_helper'

class FooMultiObjectMapper < Importable::Mapper
  def map_row(row)
    [
      Foo.create!(row),
      Foo.create!(row)
    ]
  end
end

module Importable
  describe Mapper do
    let(:data) do
      [
        {
          moof: 1,
          doof: 2
        },
        {
          moof: 3,
          doof: 4
        },
        {
          moof: 5,
          doof: 6
        }
      ]
    end

    it "maps the data to foo objects using the FooMapper" do
      mapper = FooMapper.new(data)
      mapper.data[0].should be_a Foo
      mapper.data[0].moof.should eq 1
      mapper.data[0].doof.should eq 2

      mapper.data[1].should be_a Foo
      mapper.data[1].moof.should eq 3
      mapper.data[1].doof.should eq 4

      mapper.data[2].should be_a Foo
      mapper.data[2].moof.should eq 5
      mapper.data[2].doof.should eq 6
    end

    it "data is flattened so mappers can return more than one object" do
      mapper = FooMultiObjectMapper.new(data)
      mapper.data.should have_exactly(6).items
    end

    it "saves three Foo objects using the FooMapper" do
      expect {
        FooMapper.new(data)
      }.to change(Foo, :count).by(3)
    end

    describe "#valid?" do
      it "should be valid if the incoming data is complete" do
        mapper = FooRequiredFieldMapper.new(data)
        mapper.should be_valid
      end

      it "should be invalid if the incoming data is not complete" do
        data.second.delete(:doof)
        mapper = FooRequiredFieldMapper.new(data)
        mapper.should_not be_valid
      end
    end
    
    describe "#method_missing" do
      it "should expose import params as attributes" do
        mapper = FooRequiredParamMapper.new(data, { foo_id: 1 })
        mapper.foo_id.should eq 1
      end
    end
  end
end
