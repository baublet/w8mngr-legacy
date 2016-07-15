# w8mngr | The Lifestyle Tracker

[![Travis CI Build](https://api.travis-ci.org/baublet/w8mngr.svg)](https://travis-ci.org/baublet/w8mngr) [![Code Climate](https://codeclimate.com/github/baublet/w8mngr/badges/gpa.svg)](https://codeclimate.com/github/baublet/w8mngr) [![Test Coverage](https://codeclimate.com/github/baublet/w8mngr/badges/coverage.svg)](https://codeclimate.com/github/baublet/w8mngr/coverage)

The source for my side project, a lifestyle and fitness tracker. I want users to be able to track their calories, food intake, fitness, weight, and other variables that affect their health. The current version, [w8mngr.com](http://w8mngr.com) was originally coded in 2009. Back then, I was interested in super high-performance PHP. It is based on super simple architecture, raw queries, and PHP templates. As expected, it was quick to code but tough to maintain. So with this version I'm testing out Ruby on Rails.

It's my first Rails project, but I'm learning very quickly due to how mature Rails is as a framework.

## Architecture

I'm using PostgreSQL, Ruby on Rails, Javascript (vanilla), Vue.js, and nginx. The entire stack is new to me, so I'm learning a ton. To further improve my devops in hopes of becoming a well-rounded full stack developer, I'm using Amazon Web Services.

The frontend is based on CSS and Javascript. Although the day of hardcore progressive enhancement seems to be waning (or at least isn't as popular as full JS apps), I'm sticking to my guns. The entire app works without Javascript -- but it _really_ helps to have CSS enabled -- and I hope to turn certain pages into full-featured applications on their own.

For example, the food log will incorporate its own recipe and food search, navigating across days, and so on. But I want to do this in a lightweight manner with a small footprint, rather than incorporate the behemoth JS frameworks like Angular.

I settled on Vue.js because it's beautiful, and is easy to use with Rails. More on that in upcoming versions. React is great, so I will eventually use it on a project or two, but Vue.js struck me as the perfect tool for this job.

## Demo

The site is now live! Check it out at [w8mngr.com](https://w8mngr.com/).

## Contributing

I'm not accepting contributions without very good reasoning at the moment. I'm using this as a learning project, so open an issue that hints at the problem, point me toward a solution or two, and I will address it.

# Deploy and Development Aliases

For testing and deployment, you need the following environment variables set:

* `W8MNGR_API_KEY_POSTMARK` - API key for [Postmark](https://postmarkapp.com/), our email provider
* `W8MNGR_API_KEY_USDA` - Our [USDA API key](https://ndb.nal.usda.gov/ndb/api/doc), for nutritional info

## Development

```
alias prep_dev="sudo service redis-server start && sudo service postgresql start"
alias start_dev="prep_dev && foreman start -f Procfile.dev"
```

To start developing, add these two lines to your `.bash_aliases` file and start the appropriate services by running `start_dev`. It will start Redis, PostgreSQL, and run our development Procfile using Foreman.

## Deployment

```
alias clear_assets="echo 'Clearing old assets...' && rm -f ~/workspace/public/webpack/* && rm -f -r ~/workspace/public/assets/*"
alias deploy="echo 'Running deployment script...' && clear_assets && echo 'Precompiling rake assets...' && rake assets:precompile && echo 'Compiling webpack assets...' && rake webpack:compile && echo 'Adding compiled assets to the repo...' && git add . && git commit -a -m 'Precompile assets for deploy' && echo 'Pushing to Dokku...' && git push && git push dokku master"
```

These aliases clear the old assets out of our public folder, runs our Rake and webpack tasks to precompile new assets, adds them via git commit, and pushes it all up to our Github account and Dokku.

*Note:* you must be on your `master` branch for this to work properly with Dokku. You may also need to change the path of your public folder so this script can properly clear your assets.

To deploy, pull your changes to `master` and run the `deploy` alias in your development terminal. It clears local assets, recompiles them, pushes them to master, and then pushes them to your Dokku server.