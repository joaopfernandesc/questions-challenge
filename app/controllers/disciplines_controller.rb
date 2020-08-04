# frozen_string_literal: true
class DisciplinesController < ApplicationController
  include DisciplinesHelper

  def get_disciplines_accesses
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    daily_access = (
      if params[:orm] == "true"
        Question
          .group(:discipline)
          .sum(:daily_access)
      else
        fetch_disciplines_daily_access
      end
    ).sort_by { |_k, v| v }.reverse!

    total_accesses = 0
    daily_access.map! do |da|
      total_accesses += da[1]
      { da[0] => da[1] }
    end

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed_time = (end_time - start_time).round(6)
    Rails.logger.info("Got disciplines accesses in #{elapsed_time} seconds.")
    render(json: { access_ranking: daily_access, total_accesses: total_accesses, elapsed_time: elapsed_time })
  end

  def get_hottest_disciplines
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    hottest_disciplines = (
      if params[:orm] == "true"
        Question
          .order('daily_access DESC, id ASC')
          .limit(10)
          .pluck(:discipline)
      else
        fetch_hottest_disciplines
      end
    ).uniq

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed_time = (end_time - start_time).round(6)
    Rails.logger.info("Got hottest disciplines in #{elapsed_time} seconds.")
    render(json: { hottest_disciplines: hottest_disciplines, elapsed_time: elapsed_time })
  end
end
