class Question < ApplicationRecord
    
    after_initialize :set_defaults
    before_save :capitalize_title

    has_many :answers, dependent: :destroy
    belongs_to :user
    validates :title, presence: { message: "must be provided" }, uniqueness: {scope: :body}, length: { minimum: 2, maximum: 200 }
    validates :body, presence: true, length: { minimum: 10, maximum: 300}
    validates :view_count, numericality: { greater_than_or_equal_to: 0 }

    validate :no_monkey

    has_many :likes, dependent: :destroy
    has_many :likers, through: :likes, source: :user

    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    def no_monkey
        if body&.downcase&.include?("monkey")
            self.errors.add(:body, "Must not have monkey")
        end
    end

    private
    
    def set_defaults
        self.view_count ||= 0
    end

    def capitalize_title
        self.title.capitalize!
    end

    scope :recent_ten, lambda { order(created_at: :DESC).limit(10)}
end
