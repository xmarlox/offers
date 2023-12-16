class User < ApplicationRecord
  include FriendlyId

  PASSWORD_MIN_LENGTH = 8
  GENDERS = {
    male: :male,
    female: :female,
    others: :others,
  }
  BIRTHDATE_REGEX = /\d{4}\/\d{2}\/\d{2}/
  BIRTHDATE_HUMAN_FORMAT = "YYYY/MM/DD"
  BIRTHDATE_TEXT_FORMAT = "%Y/%m/%d"

  has_secure_password

  friendly_id :username, use: :slugged
  acts_as_paranoid

  has_many :sessions, dependent: :destroy
  has_many :events, dependent: :destroy
  has_and_belongs_to_many :groups, join_table: :users_groups

  normalizes :birthdate, with: -> bdate { bdate.strip.gsub("-", "/") }
  validates :username, presence: true, uniqueness: true
  validates :password, allow_nil: true, length: { minimum: PASSWORD_MIN_LENGTH }
  validates :password, not_pwned: { message: "might easily be guessed" }
  validates :gender, inclusion: { in: GENDERS.values.map(&:to_s), message: "'%{value}' is an invalid gender" }, allow_nil: false
  validates :birthdate, format: { with: BIRTHDATE_REGEX, message: "'%{value}' has an invalid format. Birthdate should be formatted as '#{BIRTHDATE_HUMAN_FORMAT}'" }

  before_validation :assign_age
  after_create :assign_groups
  after_update :assign_groups, if: :age_or_gender_previously_changed?

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  after_update if: :password_digest_previously_changed? do
    events.create!(action: "password_changed")
  end

  def offers
    Offer.by_groups(ids: group_ids)
  end

  def self.calculate_age(birthdate = nil)
    return 0 if birthdate.blank?

    ((Time.now - Time.parse(birthdate)) / 1.year.seconds).floor
  end

  private

    def assign_age
      return unless birthdate_changed?

      self.age = self.class.calculate_age(birthdate)
    end

    def age_or_gender_previously_changed?
      age_previously_changed? || gender_previously_changed?
    end

    def target_groups
      Group.target_by(table: self.class.table_name, column: :age, value: age) +
        Group.target_by(table: self.class.table_name, column: :gender, value: gender)
    end

    def assign_groups
      targeted_groups = target_groups
      return if targeted_groups.blank?

      groups.clear
      groups << targeted_groups
    end
end
