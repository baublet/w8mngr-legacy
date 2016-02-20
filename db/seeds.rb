# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Options spec: all option keys are lower case, with dashes or underscores and no space or punctuation.
# The only punctuation should be a period to denote groupings (e.g. name: "user.real-name")
Option.create([
	{ name: "user.real-name" },
	{ name: "user.units", kind: "o", default_value: "metric",
		values: "	metric 	 :: Metric
					imperial :: Imperial" },
	{ name: "user.timezone" },

	# In our app, we will always store the height in CM and convert it on the fly
	# for metric and imperial
	{ name: "user.height", kind: "i" },
	{ name: "user.height_display" },
	{ name: "user.sex", kind: "i", default_value: "na",
		values: "	na :: Prefer not to disclose
					 f :: Female
					 m :: Male" },
	{ name: "user.bmr", kind: "i" },
	{ name: "user.birthday", kind: "i"}
])

Option.create([
	{ name: "plan.beginning", kind: "i" },
	{ name: "plan.goal-end", kind: "i" },
	{ name: "plan.goal-weight", kind: "i"},
	# This will be their caloric deficit or surplus per day
	{ name: "plan.pace", kind: "i" }
])
