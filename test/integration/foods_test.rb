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

  test "user can add, update, delete measurements" do
    # Build our new measurement
    new_food = {
      name: Faker::Name.name,
      description: Faker::Lorem.sentence(20),
      amount: Faker::Number.between(1, 200),
      unit: Faker::Name.name,
      calories: Faker::Number.between(1, 200),
      fat: Faker::Number.between(1, 200),
      carbs: Faker::Number.between(1, 200),
      protein: Faker::Number.between(1, 200)
    }

    create_valid_food new_food

    new_measurement = {
      amount: Faker::Number.between(1, 200),
      unit: Faker::Name.name,
      calories: Faker::Number.between(1, 200),
      fat: Faker::Number.between(1, 200),
      carbs: Faker::Number.between(1, 200),
      protein: Faker::Number.between(1, 200)
    }

    assert_difference 'Measurement.count' do
      # Add new measurement
      patch food_path, {
          :food => {
                  name: new_food[:name],
                  description: new_food[:description]

          },
            :measurement => {
              '0' => {
                  amount: new_measurement[:amount],
                  unit: new_measurement[:unit],
                  calories: new_measurement[:calories],
                  fat: new_measurement[:fat],
                  carbs: new_measurement[:carbs],
                  protein: new_measurement[:protein]
              }
          }
        }
    end

    assert_template "foods/edit"

    # Make sure our values are there
    new_measurement.each_value do |param|
      assert response_contains param
    end

    return

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
    return
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
    delete_link = css_select ".foods-table a.delete"
    get delete_link[0]["href"]
    assert_select "form.edit_food_entry", count: 0
  end

  test "user can search foods and add them to their log" do
    return
    create_valid_food
    get food_search_path
    get food_search_path, q: "Food"
    assert_template "search_foods/search"
    # Selects the first food found on the page
    results = css_select ".food h2 a"
    get results[0]["href"]
    assert_template "foods/show"
    # Find the first measurement and add it to the food log
    results = css_select "main form"
    measurement_box = css_select ".measurement-box"
    post results[0]['action'], measurement: measurement_box[0]['data-measurement-id']
    follow_redirect!
    assert_template "food_entries/index"
  end

  private

  def create_valid_food parameters = nil
    parameters = {
      name: "Totally New Food name",
      description: "This is a description",
      amount: "12",
      unit: "unit",
      calories: 123,
      fat: 234,
      carbs: 345,
      protein: 456
    } if parameters.nil?
    get new_food_path
    assert_template "foods/new"
    post foods_path, {
             :food =>
                 {
                  name: parameters[:name],
                  description: parameters[:description]
                },
             :measurement =>
                 {
                  0 =>
                    {
                      amount: parameters[:amount],
                      unit: parameters[:unit],
                      calories: parameters[:calories],
                      fat: parameters[:fat],
                      carbs: parameters[:carbs],
                      protein: parameters[:protein]
                   }
                }
             }
    assert_response :redirect
    follow_redirect!
    assert_template "foods/edit"
    parameters.each_value do |param|
      assert response_contains param
    end
    assert_select ".error-explanation", false
  end
end
