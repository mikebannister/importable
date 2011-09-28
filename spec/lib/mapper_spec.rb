require 'spec_helper'

class FooMultiObjectMapper < Importable::Mapper
  attr_accessor :before_callback_called
  attr_accessor :after_callback_called

  def map_row(row)
    [
      Foo.create!(row),
      Foo.create!(row)
    ]
  end

  def before_mapping
    @before_callback_called = true
  end

  def after_mapping
    @before_callback_called = true
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

    it "should call the before mapping callback" do
      FooMultiObjectMapper.any_instance.expects(:before_mapping)

      mapper = FooMultiObjectMapper.new(data)
      mapper.before_callback_called.should be_true
    end

    it "should call the after mapping callback" do
      FooMultiObjectMapper.any_instance.expects(:after_mapping)

      mapper = FooMultiObjectMapper.new(data)
      mapper.before_callback_called.should be_true
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

    describe "self#mapper_types" do
      it "should list the available mapper files" do
        Mapper.mapper_types[0].should eq 'bar/moof'
        Mapper.mapper_types[1].should eq 'foo'
        Mapper.mapper_types[2].should eq 'foo_required_field'
        Mapper.mapper_types[3].should eq 'foo_required_param'
        Mapper.mapper_types[4].should eq 'foo_required_param_and_field'
        Mapper.mapper_types[5].should eq 'foo_required_param_resource'
        Mapper.mapper_types[6].should eq 'foo_resource'
        Mapper.mapper_types[7].should eq 'moof'
        Mapper.mapper_types[8].should eq 'plural_widgets'
        Mapper.mapper_types[9].should eq 'singular_widget'

        Mapper.mapper_types.should have_exactly(10).items
      end
    end

    describe "self#mapper_type_exists?" do
      it "should return true if the supplied mapper type exists" do
        Mapper.mapper_type_exists?('foo').should be_true
        Mapper.mapper_type_exists?('foo_required_field').should be_true
      end

      it "should return false if the supplied mapper type doesn't exist" do
        Mapper.mapper_type_exists?('bar').should be_false
        Mapper.mapper_type_exists?('').should be_false
        Mapper.mapper_type_exists?(nil).should be_false
      end

      it "should be module friendly with a dash denoting a module" do
        Mapper.mapper_type_exists?('bar-moof').should be_true
      end

      it "should not care about pluralization" do
        Mapper.mapper_type_exists?('singular_widget').should be_true
        Mapper.mapper_type_exists?('singular_widgets').should be_true
        Mapper.mapper_type_exists?('plural_widget').should be_true
        Mapper.mapper_type_exists?('plural_widgets').should be_true
        Mapper.mapper_type_exists?('foos').should be_true
        Mapper.mapper_type_exists?('foo_required_fields').should be_true
      end
    end
  end
end
