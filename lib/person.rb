class Person < ActiveRecord::Base
  validates :name, :presence => true

  has_many :children, :through => :parents, :class_name => 'Person'

  has_many :parents, :through => :children, :class_name => 'Person'

  after_save :make_marriage_reciprocal

  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

  def get_parents
    parents_array = []
    parents_array << Person.find(self.parent_id1)
    parents_array << Person.find(self.parent_id2)
    parents_array
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
