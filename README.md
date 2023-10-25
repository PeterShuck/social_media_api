# Social Media API

## About
This is a Rails 7 based API running on a sqlite3 db that returns some Social Media data for registered users including:
* Posts
* Comments
* Ratings

Additionally, a Timeline endpoint is supported that combines the above data with the following events from a User's
GitHub account:
* New repositories created
* Pull requests opened
* Pull requests merged
* Commits pushed

## Requirements
This project currently requires:
* **Rails 7.1.1**
* **Ruby 3.2.2**

## Installation
You'll first want to clone this repository:
```
git clone https://github.com/PeterShuck/social_media_api.git
```

Then, you'll run the command below to ensure the prerequisite gems are installed
```
bundle
```
Next you'll set up the database
```
rails db:migrate
```
And lastly, you'll seed the database
```
rails db:seed
```

## Usage
Now, if you start a Rails server
```
rails s
```

The API endpoints will be live on `http://localhost:3000`. Here's a guide on hitting the API via `curl`

### Timeline for a user
The Timeline will return a list of New Posts and Comments authored by the current user, Rating records in which the
current user exceeded a 4 star rating or higher, and GitHub actions taken by the user (if they have a GitHub username).
Currently, we pass the user's `id` to the `timelines` API to receive data.
```
curl http://localhost:3000/timelines/5
```
 _Note_: The user id should change to  `current` or `me` once proper user authentication is implemented and we can pull
the current user's info in the backend.

Data will be sorted in descending order from the `most_recent_action` time (newest to oldest).
Also, for ease of defining templates, I've defined a `media_type` property for each data type I'm returning, they are as
follows:
* `new_post`, for new posts
* `commented_on_post`, for comments
* `passed_four_stars`, when a user received a rating four stars or higher
* `pushed_commits`, for pushed commits
* `opened_pr`, for opened pull requests
* `merged_pr`, for merged pull requests
* `new_repo`, for new repositories
* `github_error`, this only occurs if there's a problem with the GitHub API (typically when the rate is exceeded)

### Retrieve a user's data
A user's data can be retrieved by passing their `id` like in the example below
```
curl http://localhost:3000/users/12
```

### Rate a user
A user can be given a new rating by passing the email of the current user to the `rater` param, and a number 0-5 for the
number of stars the rating is intended to be.
```
curl -d "rating=3" -d "rater=clovis@example.net" http://localhost:3000/users/5/ratings
```
A user's `average_rating` will be tracked and made available in all API calls pertaining to a user.

### Retrieve existing post data
Post data can be retrieved by passing the post `id` like in the example below
```
curl http://localhost:3000/posts/15
```

### Create a new post
A new post can be created by passing the `title`, `message`, and current user's email to the `user` param like in the example below:
```
curl -d "title=Darmok and Jalad at Tanagra" -d "body=Shaka, when the walls fell." -d "user=clovis@example.net" http://localhost:3000/posts
```

### List comments from a post
Comments from a post can be retrieved with an API call like the example below
```
curl http://localhost:3000/posts/4908/comments
```

### Add a new comment
Comments must be created under existing posts. A new comment can be added to a post by passing the `message` and current
user's email to the `user` param like in the example below:
```
curl -d "message=Sokath, his eyes open." -d "user=clovis@example.net" http://localhost:3000/posts/4908/comments
```

### Delete a comment
Comments can be deleted by passing the comment's `id` directly to a request like the one below:
```
curl -X DELETE http://localhost:3000/comments/24356
```

## TODO's
* Unit tests. Since this project is a proof of concept for a Social Media API, I have elected to forego Unit Tests until
  approach has been approved.
* Authentication. This will be needed to register new users to the API and streamline the API calls that need to refer to
  the current user.
* Pagination. This will enhance performance of the Index API calls (especially the timeline).
* Search. Especially for the Timeline, I would want to index data returned for a user to drastically improve performance
  of the API there.
