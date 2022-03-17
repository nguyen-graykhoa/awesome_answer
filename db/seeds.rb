# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#Destroy all records in the database before creating new data:
Question.destroy_all
Answer.destroy_all
User.destroy_all
Like.destroy_all
Tagging.destroy_all
Tag.destroy_all
JobPost.destroy_all

#To access Faker, remember to add the faker gem to Gemfile and the run: bundle

PASSWORD = "123"
super_user = User.create(
    first_name: "Admin",
    last_name: "User",
    email: "admin@user.com",
    password: PASSWORD,
    is_admin: true
)

5.times do
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    User.create(
        first_name: first_name,
        last_name: last_name,
        email: "#{first_name}@#{last_name}.com",
        password: PASSWORD
    )
end

users = User.all

NUM_TAGS = 20
NUM_TAGS.times do
    Tag.create(
        name: Faker::Vehicle.make
    )
end

tags = Tag.all

50.times do 
    created_at = Faker::Date.backward(days:365 * 5)

    q = Question.create(
        title: Faker::Hacker.say_something_smart,
        body: Faker::ChuckNorris.fact,
        view_count: rand(100_000),
        created_at: created_at,
        updated_at: created_at,
        user: users.sample
    )
    if q.valid?
        rand(1..5).times do
            Answer.create(body: Faker::Hacker.say_something_smart, question: q, user: users.sample)
        end
        q.likers = users.shuffle.slice(0, rand(users.count))
        q.tags = tags.shuffle.slice(0, rand(tags.count))
    end
    
end

questions = Question.all
answers = Answer.all

# puts Cowsay.say("Generated #{questions.count} questions", :frogs)
# puts Cowsay.say("Generated #{answers.count} answers", :cow)
# puts Cowsay.say("Generated #{users.count} users", :koala)
# puts Cowsay.say("Generated #{Like.count} likes", :dragon)
# puts Cowsay.say("Generated #{Tag.count} tags", :bunny)

#To run this file use command: rails db:seed

