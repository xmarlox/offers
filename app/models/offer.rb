class Offer < ApplicationRecord
  include FriendlyId

  friendly_id :name, use: :slugged
  acts_as_paranoid

  has_and_belongs_to_many :groups, join_table: :offers_groups

  validates :name, presence: true

  scope :by_groups, -> (ids:) { includes(:groups).joins(:groups).where(offers_groups: { group_id: ids }).uniq }
end
