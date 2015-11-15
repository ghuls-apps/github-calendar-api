require 'open-uri'
require 'nokogiri'
require 'string-utility'

module GitHub
  module Calendar
    extend self
    using StringUtility

    # Gets the total number of contributions for the past year.
    # @param user [String] The username to get this data for.
    # @return [Int] An integer value of their total contributions this year.
    def get_total_year(user)
      source = get_page_source(user)
      string = source.css('span.contrib-number')[0].text
      string.to_i_separated
    end

    # Gets the longest contribution streak (in days) that the user has had.
    # @param user [String] See #get_total_year
    # @return [Int] The user's longest contribution streak in days.
    def get_longest_streak(user)
      source = get_page_source(user)
      string = source.css('span.contrib-number')[1].text
      string.to_i_separated
    end

    # Gets the current contribution streak (in days) that the user is in.
    # @param user [String] See #get_total_year
    # @return [Int] The user's current contribution streak in days.
    def get_current_streak(user)
      source = get_page_source(user)
      string = source.css('span.contrib-number')[2].text
      string.to_i_separated
    end

    # Gets the weekly contribution count for the past year.
    # @param user [String] See #get_total_year
    # @return [Hash] How many contributions they have done each week. Example:
    # { 0: 0, 1: 8, etc. }
    def get_weekly(user)
      weeks = get_calendar(user)
      ret = {}
      count = 0
      weeks[1..-1].each do |k|
        data = 0
        capture = k.to_s.scan(/data-count=\"(.*?)\"/)
        capture[1..-1].each do |ints|
          data += ints[0].to_i
        end
        ret[count] = data
        count += 1
      end
      ret
    end

    # Gets the daily contribution count for the past year.
    # @param user [String] See #get_total_year
    # @return [Hash] How many contributions they have performed each day. See
    # #get_weekly
    def get_daily(user)
      weeks = get_calendar(user)
      ret = {}
      count = 0
      weeks[1..-1].each do |k|
        capture = k.to_s.scan(/data-count=\"(.*?)\"/)
        capture[1..-1].each do |i|
          ret[count] = i[0].to_i
          count += 1
        end
      end
      ret
    end

    # Gets the monthly contribution count for the past year.
    # @param user [String] See #get_total_year
    # @return [Hash] How many contributions they have performed each month.
    # Months are listed as their string integers, e.g., 01 is January and
    # 12 is December.
    def get_monthly(user)
      weeks = get_calendar(user)
      ret = {
        '01' => 0,
        '02' => 0,
        '03' => 0,
        '04' => 0,
        '05' => 0,
        '06' => 0,
        '07' => 0,
        '08' => 0,
        '09' => 0,
        '10' => 0,
        '11' => 0,
        '12' => 0
      }
      weeks[1..-1].each do |k|
        date = k.to_s.scan(/data-date=\".*-(.*?)-/)
        capture = k.to_s.scan(/data-count=\"(.*?)\"/)
        capture[1..-1].each do |i|
          ret[date[0][0]] += i[0].to_i
        end
      end
      ret
    end

    # Gets the average weekly number of contributions by the user.
    # @param user [String] See #get_total_year
    # @return [Int] The average number of contributions.
    def get_average_week(user)
      get_average(get_weekly(user))
    end

    # Gets the average daily number of contributions by the user.
    # @param user [String] See #get_total_year
    # @return [Int] See #get_average_week
    def get_average_day(user)
      get_average(get_daily(user))
    end

    # Gets the average monthly number of contributions by the user.
    # @param user [String] See #get_total_year
    # @return [Int] See #get_average_week
    def get_average_month(user)
      get_average(get_monthly(user))
    end

    private

    # Gets the parsed HTML source for the user profile.
    # @param user [String] See #get_total_year
    # @return [Nokogiri::HTML::Document] The parsed HTML for the user page
    def get_page_source(user)
      Nokogiri::HTML(open("https://github.com/#{user}"), &:noblanks)
    end

    # Gets the parsed calendar HTML source for the user profile.
    # @param user [String] See #get_total_year
    # @return [Nokogiri::XML::NodeSet] The NodeSet for all the g's in the
    # calendar. Consider this as an array of all the weeks. In iteration,
    # you will probably want to skip the first, as it is the total yearly.
    def get_calendar(user)
      source = get_page_source(user)
      source.css('svg.js-calendar-graph-svg g')
    end

    # Gets an average for all the integer values in a hash.
    # @param [Hash] The hash to get the average for.
    # @return [Int] The average of the values.
    def get_average(hash)
      hash_max = hash.length
      hash_total = 0
      hash.each { |_, v| hash_total += v }
      hash_total / hash_max
    end
  end
end
