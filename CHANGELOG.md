# Changelog
## Version 1
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
