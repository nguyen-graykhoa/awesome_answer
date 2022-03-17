require 'rails_helper'

RSpec.describe JobPostsController, type: :controller do
    describe "#new" do
        context "with signed in user" do
            before do
                # this before block will run before all the cases in this context block
                session[:user_id] = FactoryBot.create(:user).id
            end
            
            it "requires a render of a new template" do
                #GIVEN
                #In render there's not really a given
                #The given is that the action is triggered

                #WHEN
                get(:new)
                #We have this get method available from rails-controller-testing gem
                #In the backend it simulates/mocks the behaviour of sending an http get request
            
                #THEN
                expect(response).to(render_template(:new))
                #response is an object that represents the HTTP-response

            end

            it "requires setting an instance variable with a new job post" do
                #GIVEN
                #The given is that the action is triggered

                #WHEN
                get(:new)
            
                #THEN
                #assigns(:job_post) is available from the gem rails-controller-testing
                #it allows you to grab an instance variable, and it takes a symbol (:job_post)
                #All the models are available to the controller
                expect(assigns(:job_post)).to(be_a_new(JobPost))
                #We check that the instance variable @job_post is a new instance of the model JobPost
            end
        end
        context "without sign in user" do
            it "should redirect to the sign in page" do
                get(:new)
                expect(response).to redirect_to(new_sessions_path)
            end
            
        end

    end

    describe "#create" do
        def valid_request
            post(:create, params: { job_post: 
                FactoryBot.attributes_for(:job_post)
            })
        end
        context "with signed in user" do
            before do
                session[:user_id] = FactoryBot.create(:user).id
            end
            
            context "with valid parameters" do
                it "requires a new creation of job post in the database" do
                    #GIVEN
                    count_before = JobPost.count #the number of all records in the JobPost table

                    #WHEN
                    valid_request #mocking a post request to the create method with valid params

                    #THEN
                    count_after = JobPost.count
                    expect(count_after).to(eq(count_before + 1))
                    # eq is an assertion provided by Rspec that checks the value to the right of the .to is equal to the paramater passed in to the method.
                end

                it "requires a redirect to the show page for the new job post" do
                    #GIVEN
                    #we are creating a new job post

                    #WHEN
                    valid_request #mocking a post request to the create method with valid params

                    #THEN
                    job_post = JobPost.last
                    expect(response).to(redirect_to(job_post_path(job_post.id)))
                end
            end

            context "with invalid parameters" do
                def invalid_request
                    post(:create, params: { job_post: 
                        FactoryBot.attributes_for(:job_post, title:nil)
                    })
                end

                it "requires that the database does not save the new record of job post" do
                    #GIVEN
                    count_before = JobPost.count #the number of all records in the JobPost table

                    #WHEN
                    invalid_request #mocking a post request to the create method with invalid params

                    #THEN
                    count_after = JobPost.count
                    expect(count_after).to(eq(count_before))
                    #eq is an assertion provided by Rspec that checks the value to the right of the .to is equal to the paramater passed in to the method.
                end

                it "requires a render of the new job post template" do
                    #GIVEN
                    #on new template creating a new record of job post

                    #WHEN
                    #invalid params given
                    invalid_request

                    #THEN
                    expect(response).to render_template(:new)
                end
            end
        end
        
        context "without signed in user" do
            it "should redirect to the sign in page" do
                valid_request
                expect(response).to redirect_to(new_sessions_path) 
            end
        end


    end

    describe "#show" do
        it "requires a render of the show template" do
            #GIVEN
            job_post = FactoryBot.create(:job_post)

            #WHEN
            get(:show, params: {id: job_post.id})

            #THEN
            expect(response).to render_template(:show)
        end

        it "requires setting an instance variable @job_post for the shown object" do
        #GIVEN
        job_post = FactoryBot.create(:job_post)

        #WHEN
        get(:show, params: {id: job_post.id})

        #THEN
        expect(assigns(:job_post)).to eq(job_post)
        end
    end

    describe "#index" do
        it "requires a render of the index template" do
            #GIVEN
            #triggers the index action

            #WHEN
            get(:index)

            #THEN
            expect(response).to(render_template(:index))
        end

        it "requires assigning an instance variable @job_posts which contains all the job posts in the db" do
            #GIVEN
            job_post_1 = FactoryBot.create(:job_post)
            job_post_2 = FactoryBot.create(:job_post)
            job_post_3 = FactoryBot.create(:job_post)

            #WHEN
            get(:index)

            #THEN
            expect(assigns(:job_posts)).to eq([job_post_3,job_post_2,job_post_1])
        end
    end

    describe "#destroy" do
        context "with signed in user" do
            context "as owner" do
                before do
                    #this code will be run first before every single test within the describe block
                    #GIVEN
                    current_user = FactoryBot.create(:user)
                    session[:user_id] = current_user.id
                    @job_post = FactoryBot.create(:job_post, user: current_user)
                    #WHEN
                    delete(:destroy, params: {id: @job_post.id})
                end
                it "requires a record of job post to be removed from the database" do
                    #THEN
                    expect(JobPost.find_by(id: @job_post.id)).to be(nil)
                end

                it "requires a redirect to job posts index page" do
                    #THEN
                    expect(response).to redirect_to(job_posts_path)
                end

                it "requires a flash message that the record was deleted" do
                    #THEN
                    expect(flash[:alert]).to be #asserts that the danger property of the flash object exists
                end 
            end
            context "not onwner" do
                it "the job post shouldn't be removed" do
                    # Given
                    # 1. need to have a job post
                    # 2. need to have a user signed in
                    # 3. this current user should not be the owner of this job post
                    job_post = FactoryBot.create(:job_post)
                    session[:user_id] = FactoryBot.create(:user).id

                    # When send a destory request
                    delete(:destroy, params:{id: job_post.id})

                    # Then this job post should still inside the db
                    expect(JobPost.find_by(id: job_post.id)).to eq(job_post)
                end
            end
        end

        context "without signed in user" do
            before do
                # Given 
                @job_post = FactoryBot.create(:job_post)
                # When
                delete(:destroy, params:{id: @job_post.id})
            end
            
            it "the job post shouldn't be removed" do
                # Then
                expect(JobPost.find_by(id: @job_post.id)).to eq(@job_post)
            end
            it "it should redirect to the sign in page" do
                # Then
                expect(response).to redirect_to(new_sessions_path) 
            end
            it "requires a flash msg" do
                # Then
                expect(flash[:notice]).to be
                # check the notice message exists or not
            end
        end
    end

    describe "#edit" do              
        context "with signed in user" do
            context "as owner" do
                it "renders the edit template" do
                    current_user = FactoryBot.create(:user)
                    session[:user_id] = current_user.id
                    @job_post = FactoryBot.create(:job_post, user: current_user)
                    #WHEN
                    get(:edit, params: {id: @job_post.id})
                    #THEN
                    expect(response).to render_template :edit
                end
            end
            context "not owner" do
                it "should redirect to the root path" do
                    # Given
                    session[:user_id] = FactoryBot.create(:user).id
                    job_post = FactoryBot.create(:job_post)
                    # When
                    get(:edit, params:{id: job_post.id})
                    # Then
                    expect(response).to redirect_to root_path
                end
            end
        end

        context "without signed in user" do
            it "redirect to sign in page" do
                #GIVEN
                @job_post = FactoryBot.create(:job_post)
                #WHEN
                get(:edit, params: {id: @job_post.id})
                expect(response).to redirect_to(new_sessions_path)
            end
        end
    end

    describe "#update" do
        context "with signed in user" do
            before do
                #GIVEN
                session[:user_id] = FactoryBot.create(:user).id
                @job_post = FactoryBot.create(:job_post)
            end
            context "with valid parameters" do
                it "requires an update of the job post record with new attributes" do
                    #part of GIVEN
                    new_title = "#{@job_post.title} Plus some changes"

                    #WHEN
                    patch(:update, params: { id: @job_post.id, job_post: {title: new_title}})

                    #THEN
                    expect(@job_post.reload.title).to eq(new_title)
                end

                it "requires a redirect to the show page of the updated job post" do
                    #part of GIVEN
                    new_title = "#{@job_post.title} Plus some changes"

                    #WHEN
                    patch(:update, params: { id: @job_post.id, job_post: {title: new_title}})

                    #THEN
                    expect(response).to redirect_to(@job_post)
                end
            end

            context "with invalid parameters" do
                it "requires job post record not to be updated in database" do
                    #WHEN
                    patch(:update, params: { id: @job_post.id, job_post: {title: nil}}) #we will grab the job_post and make it invalid
                    job_post_after_update = JobPost.find(@job_post.id) 
                    
                    #THEN
                    expect(job_post_after_update.title).to eq(@job_post.title)
                    #it should remain the same because change not saved in db
                end
            end 
        end
        context "without signed in user" do
            it "redirect to the sign in page" do
                job_post = FactoryBot.create(:job_post)
                patch(:update, params: {id: job_post.id, job_post: {title:"aaa"}})
                expect(response).to redirect_to new_sessions_path
            end
            
        end
    end

end