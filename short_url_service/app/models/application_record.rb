class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.like(field, value)
    arel_table[field].matches("%#{value.strip.downcase}%") if field.present? && value.present?
  end
end
