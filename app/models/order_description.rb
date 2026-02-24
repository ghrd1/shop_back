class OrderDescription < ApplicationRecord
  belongs_to :order, inverse_of: :order_descriptions
  belongs_to :item

  validates :quantity, presence: true, numericality: { greater_than: 0 }
end
