class Option < ActiveRecord::Base
    has_many  :option_values, dependent: :destroy
                                # Destroy all option values when its parent is destroyed
    validates :name,  presence: true, length: { maximum: 16 },
					  uniqueness: { case_sensitive: false }
end
