class Food < ActiveRecord::Base
	# So that they're always sorted by popularity
    default_scope {
                order("popularity DESC")
            }

	belongs_to	:user,          inverse_of: :foods
	validates	:user_id,	    presence: true

	validates	:name,          presence: true,
							    length: { minimum: 2,  maximum: 155 }

	has_many	:measurements,  dependent: :destroy, inverse_of: :food
	validates	:measurements,  :presence => true
    
    include PgSearch
    pg_search_scope :search_foods, 
                        :against => {
                            :name => 'A',
                            :description => 'B'
                        },
                        :using => {
                            :tsearch => {
                                :prefix => true,
                                :negation => true,
                                :dictionary => "english",
                                :start_sel => '<span class="highlight">',
                                :stop_sel => '</span>'
                            }
                        },
                        :ignoring => :accents
end
