class Option < ActiveRecord::Base
    has_many    :options, dependent: :destroy
                          # Destroy all option values when its parent is destroyed
end
