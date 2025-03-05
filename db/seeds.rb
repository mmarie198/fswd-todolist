# db/seeds.rb
user = User.find_by(email: 'test@example.com')

unless user
  user = User.create!(
    email: 'test2@example.com',
    password: 'password123',
    password_confirmation: 'password123'
  )
end

# Clear existing tasks for this user to avoid duplicates
user.tasks.destroy_all

Task.create!([
  { description: "Buy groceries", completed: false, user: user },
  { description: "Clean the house", completed: true, user: user },
  { description: "Finish Rails project", completed: false, user: user }
])