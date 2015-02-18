class Product < ActiveRecord::Base
  def age_range
    if self.minimum_age_appropriate == nil
      "0 and above"
    elsif self.maximum_age_appropriate == nil
      "#{self.minimum_age_appropriate} and above"
    elsif self.minimum_age_appropriate == self.maximum_age_appropriate
      "Age #{self.minimum_age_appropriate}"
    else
      "#{self.minimum_age_appropriate} to #{self.maximum_age_appropriate}"
    end
  end

  def age_appropriate?(age)
    if age < 0
      false
    elsif self.minimum_age_appropriate == nil
      true
    elsif self.minimum_age_appropriate > age #past this point we know above min age
      false
    elsif self.maximum_age_appropriate == nil
      true
    elsif self.maximum_age_appropriate < age
      false
    else
      true
    end
  end

  def self.sorted_by(col)
    if self.column_names.include?(col)
      self.order(col)
    else
      self.order("name")
    end
  end
end
