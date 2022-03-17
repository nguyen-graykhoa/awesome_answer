class JobPostsController < ApplicationController
    before_action :authenticate_user!, only:[ :new, :create, :destroy, :edit, :update]
    def new
        @job_post = JobPost.new
    end
    def create
        @job_post = JobPost.create params.require(:job_post)
        .permit(
            :title,
            :description,
            :location,
            :company_name,
            :min_salary,
            :max_salary             
        )
        @job_post.user = current_user
        if @job_post.save
            redirect_to job_post_path(@job_post)
        else
            render "new"
        end     
    end

    def show
        @job_post = JobPost.find params[:id]
    end

    def index
        @job_posts = JobPost.all.order(created_at: :desc)
    end

    def destroy
        @job_post = JobPost.find params[:id]

        if can?(:delete, @job_post)
          @job_post.destroy
          flash[:notice] = "deleted record"
          redirect_to job_posts_path           
        else 
          flash.notice = "Access Denied"  
          redirect_to new_sessions_path
        end
    end

    def edit
        @job_post = JobPost.find params[:id]
        if can?(:edit, @job_post)
            render :edit
        else
            redirect_to root_path
        end
    end

   def update
        @job_post = JobPost.find params[:id]
        @job_post.update params.require(:job_post)
        .permit(
            :title,
            :description,
            :location,
            :company_name,
            :min_salary,
            :max_salary
        )
        redirect_to @job_post
    end
end
