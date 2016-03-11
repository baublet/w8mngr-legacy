class Recipe < ActiveRecord::Base
  belongs_to   :user,         inverse_of: :recipes
  has_many     :ingredients,  inverse_of: :recipe,
                              dependent: :destroy

  validates    :name,         presence: true,
                              length: { minimum: 8,  maximum: 155 }

  validates    :description,  presence: true

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

  def fat
    get_total :fat
  end

  def carbs
    get_total :carbs
  end

  def protein
    get_total :protein
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
