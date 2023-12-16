class Group < ApplicationRecord
  include FriendlyId

  TARGET_OPERATOR_METHODS = {
    equals: "eql?", # texts or numbers
    range: "include?", # numbers
    in: "include?", # texts
  }
  TARGET_OPERATOR_CHAR_DELIMITER = {
    equals: nil, # texts or numbers
    range: "...", # numbers
    in: ",", # texts
  }

  friendly_id :name, use: :slugged
  acts_as_paranoid

  has_and_belongs_to_many :users, join_table: :users_groups
  has_and_belongs_to_many :offers, join_table: :offers_groups

  validates :name, :target_table, :target_column, :target_value, presence: true
  validates :target_operator, inclusion: { in: TARGET_OPERATOR_METHODS.keys.map(&:to_s), message: "'%{value}' invalid operator! Valid operators are: #{TARGET_OPERATOR_METHODS.keys.join(", ")}"}

  def targeted?(value:)
    detect_value.try(compare_method, value)
  end

  def self.target_by(table:, column:, value:)
    where(target_table: table, target_column: column).select do |group|
      group.targeted?(value: value)
    end
  end

  private

    def detect_value
      case target_operator.to_sym
      when :equals
        target_value
      when :range
        val = target_value.split(delimiter)
        Range.new(val.first.to_i, val.last.to_i)
      when :in
        target_value.split(delimiter).map(&:to_s)
      end
    end

    def compare_method
      TARGET_OPERATOR_METHODS[target_operator.to_sym].to_sym
    end

    def delimiter
      TARGET_OPERATOR_CHAR_DELIMITER[target_operator.to_sym].to_s
    end
end
