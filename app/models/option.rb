class Option < ActiveRecord::Base
    has_many    :option_values, dependent: :destroy
                                # Destroy all option values when its parent is destroyed
end
