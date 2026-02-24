class Order < ApplicationRecord
  belongs_to :user
  has_many :order_descriptions, dependent: :destroy, inverse_of: :order
  has_many :items, through: :order_descriptions

  # Allow creating order_descriptions together with order (used in OrdersController#create)
  accepts_nested_attributes_for :order_descriptions

  validates :user_id, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
