#Movie Catalog Sinatra Site

This is a Sinatra web app I built to practice rendering dynamic web pages with information pulled from a relational database. The movie catalog is backed by a PostgreSQL database called `movies`

All code files are covered by feature tests written in RSpec with Capybara.

###Features

* User visits `/actors` and sees a list of actors, sorted alphabetically by name.
  * Each actor name is a link to the details page for that actor.
* User visits `/actors/:id` and sees the details for a given actor.
  * Each page dynamically displays a list of movies the actor has starred in and what their role was.
  * Each movie links to the details page for that movie.
* User visits `/movies` and sees a table of movies, sorted alphabetically by title.
  * The table includes the movie title, the year it was released, the rating, the genre, and the studio that produced it.
  * Each movie title is a link to the details page for that movie.
* User visits `/movies/:id` and sees the details for the movie.
  * This page should contain information about the movie (including genre and studio) as well as a list of all of the actors and their roles.
  * Each actor name is a link to the details page for that actor.
