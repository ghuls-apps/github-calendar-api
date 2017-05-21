# Changelog
## Version 1
### Version 1.3.1
* Update for latest GitHub contribution section changes (format of yearly count).
* Update to StringUtility 3.0.
* Update to Nokogiri 2.7.

### Version 1.3.0
* Update for latest GitHub contribution graph changes (#6).
  * The methods relating to contribution streaks have been removed, as GitHub has removed that data.
  * get_total_year is slightly slower, as there is no longer a specific class for the yearly contributions and as a 
  result we now have to iterate over all of the level 3 headers until we find that specific one using regex.
* Fix leftover OpenURI rescuing, which prevented the UserNotFoundException from ever being raised.

### Version 1.2.1
* Pessimistic version requirements. Bump dependencies.
* License as MIT.

### Version 1.2.0
* Switch to Curb instead of OpenURI for the `#get_page_source` method, due to possible conflicted `Kernel#open` monkeypatches from Sinatra and OpenURI (#4, ghuls-web#15)
* Improve reliability of `#get_daily`, `#get_weekly`, and `#get_monthly` by properly using Nokogiri's Element methods.
* `#get_calendar` no longer gets the initial `g` (containing the entire calendar); just the individual weeks as a NodeSet.

### Version 1.1.0
* Bump Ruby to 2.3.0, Nokogiri to 1.6.7.2, and StringUtility to 2.7.1.
* Improve some redundant regex.
* Improve some documentation.

### Version 1.0.0
* Initial release.
