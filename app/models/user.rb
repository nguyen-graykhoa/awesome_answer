class User < ApplicationRecord
     
    has_secure_password
    has_many :answers, dependent: :destroy
    has_many :questions, dependent: :destroy
    has_many :job_posts, dependent: :destroy

    has_many :likes, dependent: :destroy
    has_many :liked_questions, through: :likes, source: :question
 

    # has_and_belongs_to_many(
    #     :liked_questions,{
    #         class_name: "Question",
    #         join_table: "likes",
    #         association_foreign_key: "question_id",
    #         foreign_key: "user_id"
    #     }
    # )  

    def full_name
        self.first_name + " " + self.last_name
    end
end
