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

end
