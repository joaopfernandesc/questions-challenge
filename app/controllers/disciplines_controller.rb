# frozen_string_literal: true
class DisciplinesController < ApplicationController
  include DisciplinesHelper

  def get_disciplines_accesses
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    daily_access = (params[:orm] ? Question.group(:discipline).sum(:daily_access) : fetch_disciplines_daily_access).sort_by { |_k, v| v }.reverse!

    total_accesses = 0
    daily_access.map! do |da|
      total_accesses += da[1]
      { da[0] => da[1] }
    end

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed_time = (end_time - start_time).round(6)
    Rails.logger.info("Got disciplines accesses in #{elapsed_time} seconds.")
    render(json: { access_ranking: daily_access, total_accesses: total_accesses, elapsed_time: elapsed_time })
  rescue => e
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace.join("\n"))
    render(status: 500)
  end

  def get_hottest_disciplines
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    hottest_disciplines = (params[:orm] ? Question.order('daily_access DESC, id ASC').limit(10).pluck(:discipline) : fetch_hottest_disciplines).uniq

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed_time = (end_time - start_time).round(6)
    Rails.logger.info("Got hottest disciplines in #{elapsed_time} seconds.")
    render(json: { hottest_disciplines: hottest_disciplines, elapsed_time: elapsed_time })
  rescue => e
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace.join("\n"))
    render(status: 500)
  end
end
