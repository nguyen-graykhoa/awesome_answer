class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, length: {minimum: 3, maximum: 200}
end
