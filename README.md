# w8mngr | The Lifestyle Tracker

The source for my side project, a lifestyle and fitness tracker. I want users to be able to track their calories, food intake, fitness, weight, and other variables that affect their health. The current version, (w8mngr.com)[http://w8mngr.com] was originally coded in 2009. Back then, I was interested in super high-performance PHP. It is based on super simple architecture, raw queries, and PHP templates. As expected, it was quick to code but tough to maintain. So with this version I'm testing out Ruby on Rails.

It's my first Rails project, so be gentle on feedback!

## Architecture

I'm using PostgreSQL, Ruby on Rails, Javascript (vanilla), Vue.js (planned), and nginx. The entire stack is new to me, so I'm learning a ton. To further improve my devops in hopes of becoming a well-rounded full stack developer, I'm using Amazon Web Services.

The frontend is based on CSS and Javascript. Although the day of hardcore progressive enhancement seems to be waning (or at least isn't as popular as full JS apps), I'm still sticking to my guns. The entire page works without Javascript -- but it *really* helps to have CSS enabled -- and I hope to turn certain pages into full-featured applications on their own.

For example, the food log will incorporate its own recipe and food search, navigating across days, and so on. But I want to do this in a lightweight manner with a small footprint, rather than incorporate the behemoth JS frameworks like Angular or Express.

In that vein, you might notice that this site is only optimized for mobile at the moment! That is intentional. I will add the appropriate CSS for desktop versions later, but since this application will mostly be used on cell phones, I wanted to fully optimize it and have a working version (from top to bottom) for mobile *before* any desktop enhancements.

I settled on Vue.js because it's beautiful, and is easy to use with Rails. More on that in upcoming versions. React is great, so I will eventually use it on a project or two, but Vue.js struck me as the perfect tool for this job.

## Demo

When the demo is online, you can view it at [the AWS link](http://w8mngr.nq8c4qzfar.us-east-1.elasticbeanstalk.com/).

## Contributing

I'm not accepting contributions without very good reasoning at the moment. I'm using this as a learning project, so open an issue that hints at the problem, point me toward a solution or two, and I will address it.

# Todo

## For Version 0.2

- Fill out the integration tests and increase the testing coverage the rest of the site
- Basic Vue.js interactivity
- Refactor and make the CSS more consistent across elements (especially the forms)
- Add recipes that we will want searchable and addable to food logs just like food items
- Incoporate a universal tagging system so that foods (and later training activities) can be searched by tags, e.g. "gluten free" "vegetarian", etc.
