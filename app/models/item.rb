class Item < ApplicationRecord
  has_many :order_descriptions, dependent: :destroy
  has_many :orders, through: :order_descriptions

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, presence: true
end
