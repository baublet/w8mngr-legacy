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
      unit: Faker::Name.first_name,
      calories: Faker::Number.between(1, 200),
      fat: Faker::Number.between(1, 200),
      carbs: Faker::Number.between(1, 200),
      protein: Faker::Number.between(1, 200)
    }

    create_valid_food new_food
    new_food_id = Food.last.id

    new_measurement = {
      amount: Faker::Number.between(1, 200),
      unit: Faker::Name.first_name,
      calories: Faker::Number.between(1, 200),
      fat: Faker::Number.between(1, 200),
      carbs: Faker::Number.between(1, 200),
      protein: Faker::Number.between(1, 200)
    }

    assert_difference "Measurement.count" do
      # Add new measurement
      patch food_path(new_food_id), {
          :food => {
                  name: new_food[:name],
                  description: new_food[:description]
          },
            :measurement => {
              0 => {
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

    new_id = Measurement.last.id

    assert_template "foods/edit"

    # Make sure our values are there
    new_measurement.each_value do |param|
      assert response_contains?(param), "Reponse body did not contain " + param.to_s
    end

    # Try editing that measurement
    new_measurement_2 = {
      amount: Faker::Number.between(1, 200),
      unit: Faker::Name.first_name,
      calories: Faker::Number.between(1, 200),
      fat: Faker::Number.between(1, 200),
      carbs: Faker::Number.between(1, 200),
      protein: Faker::Number.between(1, 200)
    }

    patch food_path(new_food_id), {
      :food => {
              name: new_food[:name],
              description: new_food[:description]
      },
        :measurement => {
          new_id => {
              amount: new_measurement_2[:amount],
              unit: new_measurement_2[:unit],
              calories: new_measurement_2[:calories],
              fat: new_measurement_2[:fat],
              carbs: new_measurement_2[:carbs],
              protein: new_measurement_2[:protein]
          }
      }
    }

    # Make sure our new values are there
    new_measurement.each_value do |param|
      assert response_contains?(param), "Reponse body did not contain " + param.to_s
    end

    first_measurement_id = Food.find(new_food_id).measurements.first.id

    # Now try deleting the food's first measurement
    assert_difference "Measurement.count", -1 do
      patch food_path(new_food_id), {
          :food => {
                  name: new_food[:name],
                  description: new_food[:description]

          },
          :measurement => {
              first_measurement_id => {
                  delete: "yes"
              }
          }
      }
    end

    # Now try to delete the food's only remaining measurement
    assert_no_difference "Measurement.count" do
      patch food_path(new_id), {
          :food => {
                  name: new_food[:name],
                  description: new_food[:description]

          },
          :measurement => {
              first_measurement_id => {
                  delete: "yes"
              }
          }
      }
    end
  end

  test "user can delete food" do
    create_valid_food
    new_id = Food.last.id
    get foods_path
    assert response_contains?(food_delete_path(new_id)), "Reponse body did not contain " + food_delete_path(new_id)
    assert_difference "Food.count", -1 do
      get food_delete_path(new_id)
    end
  end

  test "user can search foods and add them to their log" do
    # Search for the first food
    food = Food.first
    measurement_id = food.measurements.last.id

    get food_search_path, q: food.name
    assert_template "search_foods/search"

    # Does it find our new food?
    assert !response_contains?("Nothing Found for")
    assert response_contains?(food.name)

    # Does it find our new form?
    form_path = food_entry_add_food_path(current_day, measurement_id)
    assert response_contains? form_path

    # Sweet, let's go there
    assert_difference "FoodEntry.count" do
      post form_path
      assert_response :redirect
      follow_redirect!
    end

    # Make sure the new values match
    measurement = food.measurements.last
    food_hash = {
     name: food.name,
     calories: measurement.calories,
     fat: measurement.fat,
     carbs: measurement.carbs,
     protein: measurement.protein
    }
    food_hash.each_value do |param|
      assert response_contains?(param), "Reponse body did not contain " + param.to_s
    end

    # Now, find the latest food entry and ensure it matches
    last_entry = FoodEntry.last
    # Because foods have names, but food entries only have descriptions, we use
    # this to replace name with description
    food_hash[:description] = food_hash.delete :name
    food_hash.each_pair do |key, value|
      assert last_entry.send(key).to_s.include?(value.to_s), "Mismatch: food[" + key.to_s + "] !== " + value.to_s
    end
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
      assert response_contains?(param), "Reponse body did not contain " + param.to_s
    end
    assert_select ".error-explanation", false
  end
end
