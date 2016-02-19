require 'test_helper'

class FoodsTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:test)
		log_in_as(@user)
		assert logged_in?
	end

	test "user can create valid food with measurement" do
		create_valid_food
	end

	test "user can edit food and measurements, add measurements, and delete them" do
		create_valid_food
		forms = css_select("form.food-form")
		measurement_box = css_select ".measurement-box"
		measurement_id = measurement_box[0]['data-measurement-id']
        patch forms[0]['action'], {
									:food => {  name: "Updated name",
										      	description: "Updated description" },
								    :measurement => { measurement_id => {
													amount: "5", unit: "units",
										  			calories: 6, fat: 7, carbs: 8, protein: 9 }
												}
								  }
		assert_select ".error-explanation", false
		assert_template "foods/edit"
		food_inputs = css_select ".food-form .info input[type=text], .food-form .info textarea"
		assert_equal "Updated name", food_inputs[0]['value']
		assert_equal "\nUpdated description", food_inputs[1].text
		measurement_inputs = css_select  ".measurement-box .col input"
		assert_equal "5", measurement_inputs[0]['value']
		assert_equal "units", measurement_inputs[1]['value']
		assert_equal "6", measurement_inputs[2]['value']
		assert_equal "7", measurement_inputs[3]['value']
		assert_equal "8", measurement_inputs[4]['value']
		assert_equal "9", measurement_inputs[5]['value']

		# Add new measurement
		patch forms[0]['action'], {
									:food => { name: "Updated name",
										  	   description: "Updated description" },
								    :measurement => {'0' => {
													amount: "5", unit: "units",
										  			calories: 6, fat: 7, carbs: 8, protein: 9 }
									}
								  }
		assert_template "foods/edit"
		assert_select ".error-explanation", false
		assert_select ".measurement-box", count: 3

		# Delete measurement
		patch forms[0]['action'], {
									:food => { name: "Updated name",
										       description: "Updated description" },
								    :measurement => {
												measurement_id => {
													amount: "5", unit: "units",
										  			calories: 6, fat: 7, carbs: 8, protein: 9,
												 	delete: "yes" }
												}
								  }
		assert_template "foods/edit"
		assert_select ".error-explanation", false
		assert_select ".measurement-box", count: 2
	end

	test "user cannot delete last measurement of a food" do
		create_valid_food
		forms = css_select("form.food-form")
		measurement_box = css_select ".measurement-box"
		measurement_id = measurement_box[0]['data-measurement-id']

		# Try to delete measurement
		patch forms[0]['action'], {
									:food => { name: "Updated name",
										       description: "Updated description" },
								    :measurement => {
												measurement_id => {
													amount: "5", unit: "units",
										  			calories: 6, fat: 7, carbs: 8, protein: 9,
												 	delete: "yes" }
												}
								  }
		assert_template "foods/edit"
		assert_select ".alert.error", true
	end

	test "user can delete food" do
		create_valid_food
		get foods_path
		delete_link = css_select ".foods-table .delete-btn"
        get delete_link[0]["href"]
        assert_select "form.edit_food_entry", count: 0
	end

	test "user can search foods and add them to their log" do
		create_valid_food
		get food_search_path
		get food_search_path, q: "Food"
		assert_template "foods/find"
		results = css_select ".search-result h2 a"
		get results[1]["href"]
		assert_template "foods/show"
		results = css_select "main form"
		measurement_box = css_select ".measurement-box"
		post results[0]['action'], measurement: measurement_box[0]['data-measurement-id']
		follow_redirect!
		assert_template "food_entries/index"
	end

	private

	def create_valid_food
		get new_food_path
		assert_template "foods/new"
		post foods_path, {
						 :food => {name: "Food name", description: "This is a description"},
						 :measurement => {'0' => {amount: "1", unit: "unit",
							 				 calories: 1, fat: 2, carbs: 3, protein: 4}}
						 }
		assert_template "foods/edit"
		assert_select ".error-explanation", false
	end
end
