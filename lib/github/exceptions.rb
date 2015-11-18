module GitHub
  module Exceptions
    class UserNotFoundException < StandardError
      attr_reader :message
      def initialize(user)
        @message = "The user, #{user}, could not be found."
      end
    end
  end
end
