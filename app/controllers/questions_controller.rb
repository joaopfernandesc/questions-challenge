# frozen_string_literal: true
class QuestionsController < ApplicationController
  include QuestionsHelper

  def index
    raise ChallengeExceptions::BadParameters unless params[:offset] && params[:limit] && params[:start_timestamp]

    time_range = params[:range]
    if params[:orm] == "true"
      accesses, total, elapsed_time = fetch_most_accessed_with_orm(time_range)
    else
      accesses, total, elapsed_time = fetch_most_accessed_from_file(time_range)
    end

    Rails.logger.info("Got #{time_range} accesses in #{elapsed_time} seconds.")

    render(json: { questions: accesses, elapsed_time: elapsed_time, range: time_range, total: total })
  end
end
