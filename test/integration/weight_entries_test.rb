require 'test_helper'

class FoodsTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:test)
		log_in_as(@user)
		assert logged_in?
	end
	
	test "user can create new weight" do
		create_valid_weight
	end
	
	test "user can delete weights" do
		create_valid_weight
		delete_button = css_select(".weightlog-table .weight-entry .delete-btn")
		get delete_button[0]['href']
		assert_select ".weightlog-table .weight-entry .delete-btn", count: 0
	end
	
	test "user can add two weights and it shows a correct average" do
		create_valid_weight "183lbs"
		create_valid_weight "185lbs"
		assert_select ".weightlog-table .average"
		average = css_select(".weightlog-table .average .number")
		assert_equal "184", average[0].children[0].to_s
	end
	
	private
	
	def create_valid_weight weight = "185lbs"
		get weightlog_path
		assert_template "weight_entries/index"
		@weight_entry = {
				day: 20000101,
				value: weight
		}
		post weight_entries_path, weight_entry: @weight_entry
		assert_select ".weightlog-table .weight"
	end
	
end