class Recipe < ActiveRecord::Base
  belongs_to   :user,         inverse_of: :recipes
  has_many     :ingredients,  inverse_of: :recipe,
                              dependent: :destroy

  validates    :name,         presence: true,
                              length: { minimum: 8,  maximum: 155 }

  validates    :description,  presence: true

  validates    :servings,     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }

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
    (servings > 0) ? calories / servings : calories
  end

  def fat
    get_total :fat
  end

  def fat_per_serving
    (servings > 0) ? fat / servings : fat
  end

  def carbs
    get_total :carbs
  end

  def carbs_per_serving
    (servings > 0) ? carbs / servings : carbs
  end

  def protein
    get_total :protein
  end

  def protein_per_serving
    (servings > 0) ? protein / servings : protein
  end

  private

  def get_total macro
    nil if ![:calories, :fat, :carbs, :protein].include?(macro)
    sum = 0
    ingredients.each do |ingredient|
      sum = sum + ingredient.send(macro)
    end
    sum
  end

end
