class Product < ActiveRecord::Base
  has_attached_file :image, :styles=> {:medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/noimg.jpg"
  validates_attachment :image, :content_type => {:content_type => ["image/jpeg", "image/png", "image/gif"]}

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
  
  def self.filter(min_age, max_price)
    if min_age == nil && max_price == nil
      self.all
    elsif min_age == ""
       self.where("price <= ?", max_price)
    else
      self.where("price <= ? AND (minimum_age_appropriate <= ? OR minimum_age_appropriate is NULL) AND (maximum_age_appropriate >= ? or maximum_age_appropriate IS NULL)", max_price, min_age, min_age)
    end
  end
end
