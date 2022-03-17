class LikesController < ApplicationController
    def create
        question = Question.find params[:question_id]
        like = Like.new(question: question, user: current_user)
        
        if can?(:like, question)
            if like.save
                flash[:notice] = 'Question liked!'
            else
                flash[:notice] = 'You already liked!'
            end    
        else
            flash[:notice] = 'You can not like this question'
        end
        redirect_to question_path(question)
    end

    def destroy
        like = current_user.likes.find params[:id]
        if can?(:destroy, like)
            like.destroy
            flash.notice = "Question Unliked!"
        else
            flash.alert = "Can't unlike it!"
        end
        redirect_to question_path(like.question)
    end

    def liked
        @questions = current_user.liked_questions.questions
    end
    
end