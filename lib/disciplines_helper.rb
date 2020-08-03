# frozen_string_literal: true
module DisciplinesHelper
  def fetch_disciplines_daily_access
    questions = JSON.parse(File.open('new_questions.json', 'r').read)

    daily_access = Hash.new { |h, k| h[k] = 0 }

    questions.map { |q| daily_access[q["discipline"]] += q["daily_access"] }

    daily_access
  end

  def fetch_hottest_disciplines
    sorted_questions = JSON.parse(File.open('new_questions.json', 'r').read).sort_by { |q| [-q["daily_access"], q["id"]] }

    sorted_questions.pluck("discipline")[0..9]
  end
end
