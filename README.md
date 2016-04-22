# w8mngr | The Lifestyle Tracker
The source for my side project, a lifestyle and fitness tracker. I want users to be able to track their calories, food intake, fitness, weight, and other variables that affect their health. The current version, [w8mngr.com](http://w8mngr.com) was originally coded in 2009. Back then, I was interested in super high-performance PHP. It is based on super simple architecture, raw queries, and PHP templates. As expected, it was quick to code but tough to maintain. So with this version I'm testing out Ruby on Rails.

It's my first Rails project, so be gentle on feedback!

## Architecture
I'm using PostgreSQL, Ruby on Rails, Javascript (vanilla), Vue.js (planned), and nginx. The entire stack is new to me, so I'm learning a ton. To further improve my devops in hopes of becoming a well-rounded full stack developer, I'm using Amazon Web Services.

The frontend is based on CSS and Javascript. Although the day of hardcore progressive enhancement seems to be waning (or at least isn't as popular as full JS apps), I'm still sticking to my guns. The entire page works without Javascript -- but it _really_ helps to have CSS enabled -- and I hope to turn certain pages into full-featured applications on their own.

For example, the food log will incorporate its own recipe and food search, navigating across days, and so on. But I want to do this in a lightweight manner with a small footprint, rather than incorporate the behemoth JS frameworks like Angular or Express.

In that vein, you might notice that this site is only optimized for mobile at the moment! That is intentional. I will add the appropriate CSS for desktop versions later, but since this application will mostly be used on cell phones, I wanted to fully optimize it and have a working version (from top to bottom) for mobile _before_ any desktop enhancements.

I settled on Vue.js because it's beautiful, and is easy to use with Rails. More on that in upcoming versions. React is great, so I will eventually use it on a project or two, but Vue.js struck me as the perfect tool for this job.

## Demo
When the demo is online, you can view it at [the AWS link](http://w8mngr.nq8c4qzfar.us-east-1.elasticbeanstalk.com/).

## Contributing
I'm not accepting contributions without very good reasoning at the moment. I'm using this as a learning project, so open an issue that hints at the problem, point me toward a solution or two, and I will address it.

# Todo/Roadmap
## Version 0.4
- [ ] Goals
  - [ ] Create a barebones dashboard where goals will be seen
  - [ ] Consider the types and build toward expanding the types in the future
  - [ ] Schema tinkering
    - id, user, begin_date, target_date, begin_value, target_value, type, target_id, expired, deleted

  - [ ] Model tests
  - [ ] Build the model
  - [ ] Integration tests
  - [ ] Build the controller
  - [ ] Build the view
  - [ ] User experience smoothing

## Version 0.3
- [ ] Keep on top of the design

- [ ] Barcode scanning
  - [ ] Scanning element (incorporate existing JS libraries)
  - [ ] Attaching scanned codes to existing foods/recipes
  - [ ] Third-party API integration

- [ ] Queuing system for JS requests
  - [ ] For processing normal requests
  - [ ] For error handling
  - [ ] For connectivity issues

- [ ] Incorporate a universal tagging system so that foods (and later, recipes and training activities) can be searched by tags, e.g. "gluten free" "vegetarian", etc.

## Version 0.2.1
- [x] Create controller tests
  - [x] Figure out what a controller test is! ;)
  - [x] Food entries
  - [x] Foods
  - [x] Ingredients
  - [x] Password resets
  - [x] Recipes
  - [x] Sessions
  - [x] USDA
  - [x] Users
  - [x] Weight entries
  - [x] Welcome

- [x] Auto-complete form for food entries
  - [x] JSON search point
  - [x] Add it to the Vue component
  - [x] Incorporate Webpack into my build process before things get out of control

## Version 0.2
- [x] Fill out the integration tests and increase the testing coverage the rest of the site
  - [x] Weight entries integration test
  - [x] Generative tests for food and weight entries
  - [x] User profile -- preferences integration tests
  - [x] User profile -- preferences model tests

- [x] Basic Vue.js interactivity
  - [x] API request integration from Rails
  - [x] Vue.js basic integration
  - [x] Connect frontend with backend
  - [x] Add the ability to switch between days
  - [x] Add nice animations

- [x] Refactor and make the CSS more consistent across elements (especially the forms)
- [x] Add recipes that we will want searchable and addable to food logs just like food items
  - [x] Basic model test
  - [x] Build the model to fit the test
  - [x] Basic integration test
  - [x] Mock up a controller structure
  - [x] Build controller for using custom ingredients
  - [x] Build the Basic UI
  - [x] Style the UI and polish UX
  - [x] Update the foods API to allow users to add custom foods to recipes
    - Make it cookie-based; a param from our food search controller tells if the
    - user is coming from a recipe page, if so, it removes the last_day cookie
    - and instead sets an add_to_recipe cookie to the recipe ID.
    - Then we change the food show.html.erb to reflect which we're doing: adding
    - the food to a recipe, or to our food log.

  - [x] Update the recipes UI to compensate
  - [x] Smooth out the UX
