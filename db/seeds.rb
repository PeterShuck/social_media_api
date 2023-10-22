# Handy way to seed via csv's, outlined by arjunvenkat - https://gist.github.com/arjunvenkat/1115bc41bf395a162084
require 'csv'

# Commas inside of quotes were breaking the csv parsing. We'll temporarily substitue '|' (a value not present in any of
# the csv files) for them, and sub them back once the csv parses.
def read_clean_and_parse_raw_csv file_path
  CSV.parse(File.read(file_path).gsub(/"(.*?)"/) { |match| match.gsub(',', '|') }, headers: true, quote_char: "\x00")
end

puts "Parsing csv files..."
users_csv = read_clean_and_parse_raw_csv(Rails.root.join('lib', 'seeds', 'users.csv'))
posts_csv = read_clean_and_parse_raw_csv(Rails.root.join('lib', 'seeds', 'posts.csv'))
comments_csv = read_clean_and_parse_raw_csv(Rails.root.join('lib', 'seeds', 'comments.csv'))
ratings_csv = read_clean_and_parse_raw_csv(Rails.root.join('lib', 'seeds', 'ratings.csv'))

# Destroy existing data to reset to reset to default for proper testing. Since all models are dependent on User
# calling User.destroy_all should suffice in clearing the db
puts "Emptying Database of existing records..."
User.destroy_all

puts "Seeding Users..."
users_csv.each do |row|
  t = User.new
  t.id = row['id']
  t.email = row['email']
  t.name = row['name']
  t.github_username = row['github_username']
  t.registered_at = row['registered_at']
  t.created_at = row['created_at']
  t.updated_at = row['updated_at']
  t.save
end

puts "There are now #{User.count} rows in the users table"

puts "Seeding Posts..."
posts_csv.each do |row|
  t = Post.new
  t.id = row['id']
  # Sub the commas back into the strings that were previously cleaned
  t.title = row['title']&.gsub("|", ",")
  t.body = row['body']&.gsub("|", ",")
  t.user = User.find(row['user_id'])
  t.posted_at = row['posted_at']
  t.created_at = row['created_at']
  t.updated_at = row['updated_at']
  t.save
end

puts "There are now #{Post.count} rows in the posts table"

puts "Seeding Comments..."
comments_csv.each do |row|
  t = Comment.new
  t.id = row['id']
  t.message = row['message']&.gsub("|", ",")
  t.post_id = row['post_id']
  t.user_id = row['user_id']
  t.commented_at = row['commented_at']
  t.created_at = row['created_at']
  t.updated_at = row['updated_at']
  t.save
end

puts "There are now #{Comment.count} rows in the comments table"

puts "Seeding Ratings..."
ratings_csv.each do |row|
  t = Rating.new
  t.id = row['id']
  t.rating = row['rating']
  t.rater = User.find(row['rater_id'])
  t.user = User.find(row['user_id'])
  t.rated_at = row['rated_at']
  t.created_at = row['created_at']
  t.updated_at = row['updated_at']
  t.save
end

puts "There are now #{Rating.count} rows in the ratings table"
