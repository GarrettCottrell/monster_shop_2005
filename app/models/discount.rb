class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :quantity,
                        :percent_discount
end
