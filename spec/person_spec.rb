require 'spec_helper'

describe Person do
  it { should validate_presence_of :name }
  it { should have_many(:children) }
  it { should have_many(:parents) }

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      steve.spouse.should eq earl
    end

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be_nil
    end
  end

  it "updates the spouse's id when it's spouse_id is changed" do
    earl = Person.create(:name => 'Earl')
    steve = Person.create(:name => 'Steve')
    steve.update(:spouse_id => earl.id)
    earl.reload
    earl.spouse_id.should eq steve.id
  end

  it "Should create a child with two different parent ids" do
    bob = Person.create(:name => 'Bob', :gender => "M", :parent_id1 => nil, :parent_id2 => nil)
    mildred = Person.create(:name => 'Mildred', :gender => 'F', :parent_id1 => nil, :parent_id2 => nil)
    junior = Person.create(:name => 'Junior', :gender => 'F', :parent_id1 => bob.id, :parent_id2 => mildred.id)
    junior.parent_id2.should eq mildred.id
  end


end
