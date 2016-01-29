require 'test_helper'

class FoodEntriesTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:test)
        @food_entry = {  day: 20000101,
                         description: "Food entry",
                         calories: 200,
                         fat: 10,
                         carbs: 45,
                         protein: 10}
        log_in_as(@user)
        assert logged_in?
    end

    test "user can create valid food entry" do
        create_food_entry
    end

    test "user can edit food entry" do
        create_food_entry
        # Edits the entry we create in the above test
        forms = css_select("form.edit_food_entry")
        patch forms[0]['action'], food_entry: {
            # Note, in the real app environment, users can't change the day a
            # food entry is logged in as, but I'm going to leave it open for
            # APIs to do it, if necessary.
            day: 20000102,
            description: "Changed food entry",
            calories: 201,
            fat: 11,
            carbs: 46,
            protein: 11
        }
        assert_redirected_to '/foodlog/20000102'
        follow_redirect!
        assert_select "form.edit_food_entry"
        # Now check if all of the info has been updated
        inputs = css_select "form.edit_food_entry input[type='text']"
        assert_equal "Changed food entry", inputs[0]['value']
        assert_equal 201, inputs[1]['value'].to_i
        assert_equal 11, inputs[2]['value'].to_i
        assert_equal 46, inputs[3]['value'].to_i
        assert_equal 11, inputs[4]['value'].to_i
    end

    test "user can delete food entry" do
        create_food_entry
        # Find the delete link in the foodlog-table row
        delete_link = css_select ".foodlog-table .row.entry a"
        delete delete_link[0]["href"]
        assert_redirected_to '/foodlog/20000101'
        follow_redirect!
        assert_select "form.edit_food_entry", count: 0
    end

    private

    def create_food_entry
        get foodlog_path
        assert_template 'food_entries/index'
        # Creates an item for January 1, 2000
        post food_entries_path, food_entry: @food_entry
        assert_redirected_to '/foodlog/20000101'
        follow_redirect!
    end

end
