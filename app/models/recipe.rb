class Recipe < ActiveRecord::Base
  belongs_to   :user,         inverse_of: :recipes
  has_many     :ingredients,  inverse_of: :recipe,
                              dependent: :destroy

  validates    :name,         presence: true,
                              length: { minimum: 8,  maximum: 155 }

  validates    :description,  presence: true

  validates    :servings,     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }

  before_save  :remove_blank_ingredients

  include PgSearch
  pg_search_scope :search_recipes,
                      :against => {
                          :name => 'A',
                          :description => 'B',
                          :instructions => 'C'
                      },
                      :using => {
                          :tsearch => {
                              :prefix => true,
                              :negation => true,
                              :dictionary => "english"
                          }
                      }

  def calories
    get_total :calories
  end

  def calories_per_serving
    (servings > 0) ? (calories / servings).to_i.round : calories
  end

  def fat
    get_total :fat
  end

  def fat_per_serving
    (servings > 0) ? (fat / servings).to_i.round : fat
  end

  def carbs
    get_total :carbs
  end

  def carbs_per_serving
    (servings > 0) ? (carbs / servings).to_i.round : carbs
  end

  def protein
    get_total :protein
  end

  def protein_per_serving
    (servings > 0) ? (protein / servings).to_i.round : protein
  end

  def remove_blank_ingredientsaa
    ingredients.each do |ingredient|
      ingredient.destroy if ingredient.id.blank?
    end
  end

  private

  def get_total macro
    0 if ![:calories, :fat, :carbs, :protein].include?(macro)
    sum = 0
    ingredients.each do |ingredient|
      sum = sum + ingredient.send(macro) if !ingredient.send(macro).nil?
    end
    sum
  end

  # We need to call this method every time we want to save a recipe because we don't
  # necessarily care if the ingredient input is invalid if all we're trying to do is
  # save the text directly on the recipe. If we don't do this, we get a bunch of blank
  # ingredients muddling up our ingredients.
  def remove_blank_ingredients
    ingredients.each do |ingredient|
      ingredient.destroy if ingredient.id.blank?
    end
  end

end
