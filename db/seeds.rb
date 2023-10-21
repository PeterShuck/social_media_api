# Handy way to seed via csv's, outlined by arjunvenkat - https://gist.github.com/arjunvenkat/1115bc41bf395a162084
require 'csv'

users_raw = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
# posts_raw = File.read(Rails.root.join('lib', 'seeds', 'posts.csv'))
# comments_raw = File.read(Rails.root.join('lib', 'seeds', 'comments.csv'))
ratings_raw = File.read(Rails.root.join('lib', 'seeds', 'ratings.csv'))

users_csv = CSV.parse(users_raw, headers: true, encoding: 'ISO-8859-1')
# posts_csv = CSV.parse(posts_raw, headers: true, encoding: 'ISO-8859-1') # quote_char included to disable the quote policing of text they may use '"' within it
# comments_csv = CSV.parse(comments_raw, headers: true, encoding: 'ISO-8859-1')
# puts comments_csv
ratings_csv = CSV.parse(ratings_raw, headers: true, encoding: 'ISO-8859-1')
# puts ratings_csv

# Destroy existing data to reset to reset to default for proper testing
User.destroy_all
Post.destroy_all
Comment.destroy_all
Rating.destroy_all

puts "Seeding Users..."
users_csv.each do |row|
  t = User.new
  t.id = row['id']
  t.email = row['email']
  t.name = row['name']
  t.github_username = row['github_username']
  t.registered_at = row['registered_at']
  t.save
end

puts "There are now #{User.count} rows in the users table"

# puts "Seeding Posts..."
# debugger
# posts_csv.each do |row|
#   t = Post.new
#   t.title = row['title']
#   t.body = row['body']
#   t.user_id = row['user_id']
#   t.posted_at = row['posted_at']
#   t.save
# end

# puts "There are now #{Post.count} rows in the users table"

# puts "Seeding Comments..."
# comments_csv.each do |row|
#   t = Comment.new
#   t.message = row['message']
#   t.post_id = row['post_id']
#   t.user_id = row['user_id']
#   t.commented_at = row['commented_at']
# end

# puts "There are now #{Comment.count} rows in the users table"

puts "Seeding Ratings..."
ratings_csv.each do |row|
  t = Rating.new
  t.rating = row['rating']
  t.rater = User.find(row['rater_id'])
  t.user = User.find(row['user_id'])
  t.rated_at = row['rated_at']
  t.save
end

puts "There are now #{Rating.count} rows in the ratings table"
