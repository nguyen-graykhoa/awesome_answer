class AnswersController < ApplicationController
  before_action :find_question
  def index
  end

  def new
  end

  def create
    @answer = Answer.new(params.require(:answer).permit(:body))
    @question = Question.find(params[:question_id])
    @answer.question = @question
    @answer.user = current_user
    @answer.save
    if @answer.save
      redirect_to question_path(@question), status: 303
    else
      
      @answers = @question.answers 
      render '/questions/show', status: 303
    end
  
  end

  def show
  end

  def delete
  end

  def destroy
        @answer = Answer.find params[:id]
        if can?(:crud, @answer)
          @answer.destroy
          redirect_to question_path(@question.id), status: 303
        else
          redirect_to root_path, alert: "#{current_user} you are not authorized"
        end
 
  end

      private

    def find_question
        @question = Question.find params[:question_id]
    end
end
