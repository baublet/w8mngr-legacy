require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

    test "get days of week returns seven correct days" do
        days = get_days_of_week Date.today
        assert convert_day_to_date(days[0]).monday?
        assert convert_day_to_date(days[1]).tuesday?
        assert convert_day_to_date(days[2]).wednesday?
        assert convert_day_to_date(days[3]).thursday?
        assert convert_day_to_date(days[4]).friday?
        assert convert_day_to_date(days[5]).saturday?
        assert convert_day_to_date(days[6]).sunday?
    end

end
