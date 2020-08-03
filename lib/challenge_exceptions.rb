# frozen_string_literal: true
module ChallengeExceptions
  class ChallengeException < StandardError; end
  class BadParameters < ChallengeException; end
end
