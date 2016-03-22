require 'curb'
require 'nokogiri'
require 'string-utility'
require_relative 'exceptions'

module GitHub
  module Calendar
    extend self
    using StringUtility

    # Gets the total number of contributions for the past year.
    # @param user [String] The username to get this data for.
    # @return [Integer] An integer value of their total contributions this year.
    def get_total_year(user)
      source = get_page_source(user)
      string = source.css('span.contrib-number')[0].text
      string.to_i_separated
    end

    # Gets the longest contribution streak (in days) that the user has had.
    # @param user [String] See #get_total_year
    # @return [Integer] The user's longest contribution streak in days.
    def get_longest_streak(user)
      source = get_page_source(user)
      string = source.css('span.contrib-number')[1].text
      string.to_i_separated
    end

    # Gets the current contribution streak (in days) that the user is in.
    # @param user [String] See #get_total_year
    # @return [Integer] The user's current contribution streak in days.
    def get_current_streak(user)
      source = get_page_source(user)
      string = source.css('span.contrib-number')[2].text
      string.to_i_separated
    end

    # Gets the weekly contribution count for the past year.
    # @param user [String] See #get_total_year
    # @return [Hash] How many contributions they have done each week. Example: { 0: 0, 1: 8, etc. }
    def get_weekly(user)
      weeks = get_calendar(user)
      ret = {}
      count = 0
      weeks.each do |k|
        week_data = 0
        k.children.each do |element|
          week_data += element.attribute('data-count').value.to_i
        end
        ret[count] = week_data
        count += 1
      end
      ret
    end

    # Gets the daily contribution count for the past year.
    # @param user [String] See #get_total_year
    # @return [Hash] How many contributions they have performed each day. See #get_weekly
    def get_daily(user)
      weeks = get_calendar(user)
      ret = {}
      count = 0
      weeks.each do |k|
        k.children.each do |day|
          val = day.attribute('data-count').value.to_i
          ret[count] = val
          count += 1
        end
      end
      ret
    end

    # Gets the monthly contribution count for the past year.
    # @param user [String] See #get_total_year
    # @return [Hash] How many contributions they have performed each month. Months are listed as their string integers,
    # e.g., 01 is January and 12 is December.
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
      weeks.each do |k|
        k.children.each do |day|
          date = day.attribute('data-date').value.split('-')[1]
          count = day.attribute('data-count').value
          ret[date] += count.to_i
        end
      end
      ret
    end

    # Gets the average weekly number of contributions by the user.
    # @param user [String] See #get_total_year
    # @return [Integer] The average number of contributions.
    def get_average_week(user)
      weekly = get_weekly(user)
      get_average(weekly)
    end

    # Gets the average daily number of contributions by the user.
    # @param user [String] See #get_total_year
    # @return [Integer] See #get_average_week
    def get_average_day(user)
      daily = get_daily(user)
      get_average(daily)
    end

    # Gets the average monthly number of contributions by the user.
    # @param user [String] See #get_total_year
    # @return [Integer] See #get_average_week
    def get_average_month(user)
      monthly = get_monthly(user)
      get_average(monthly)
    end

    private

    # Gets the parsed HTML source for the user profile.
    # @param user [String] See #get_total_year
    # @return [Nokogiri::HTML::Document] The parsed HTML for the user page
    # @raise [UserNotFoundException] If the user is not found.
    def get_page_source(user)
      begin
        Nokogiri::HTML(Curl.get("https://github.com/#{user}").body_str, &:noblanks)
      rescue OpenURI::HTTPError
        raise GitHub::Exceptions::UserNotFoundException.new(user)
      end
    end

    # Gets the parsed calendar HTML source for the user profile.
    # @param user [String] See #get_total_year
    # @return [Nokogiri::XML::NodeSet] The NodeSet for all the days in the calendar. Consider this as an array of all
    # the weeks.
    def get_calendar(user)
      source = get_page_source(user)
      source.css('svg.js-calendar-graph-svg g g')
    end

    # Gets an average for all the integer values in a hash.
    # @param hash [Hash] The hash to get the average for.
    # @return [Integer] The average of the values.
    def get_average(hash)
      hash_max = hash.length
      hash_total = 0
      hash.each { |_, v| hash_total += v }
      hash_total / hash_max
    end
  end
end
