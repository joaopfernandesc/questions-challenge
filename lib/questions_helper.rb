# frozen_string_literal: true
module QuestionsHelper
  def fetch_most_accessed_with_orm(_time)
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    offset, limit, start_timestamp = fetch_params

    time_increment = get_time_increment(_time)

    accesses = QuestionAccess
      .where(
        'date >= ? AND date <= ?',
      Time.at(start_timestamp),
      Time.at(start_timestamp) + time_increment
      )
      .joins("INNER JOIN questions ON questions.id = question_accesses.question_id")
      .order('question_accesses.times_accessed DESC')
    total = accesses.count
    paginated_accesses = accesses
      .offset(offset)
      .limit(limit)
      .select(:question_id, :times_accessed, :statement, :discipline, :text, :answer)

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed_time = (end_time - start_time).round(6)

    [paginated_accesses.as_json(only: [:question_id, :times_accessed, :statement, :discipline, :text, :answer]), total, elapsed_time]
  end

  def fetch_most_accessed_from_file(_time)
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    offset, limit, start_timestamp = fetch_params

    question_accesses = JSON.parse(File.open('new_question_access.json', 'r').read)
    questions = JSON.parse(File.open('new_questions.json', 'r').read)
    time_increment = get_time_increment(_time)

    start_date = Time.at(start_timestamp)
    end_date = Time.at(start_timestamp) + time_increment

    questions_bucket = []
    question_accesses.each do |qa|
      if qa["date"] >= start_date && qa["date"] <= end_date
        questions_bucket << { times_accessed: qa["times_accessed"].to_i, question_id: qa["question_id"] }
      end
    end

    total = questions_bucket.size

    paginated_accesses = questions_bucket
      .sort_by { |qb| qb[:times_accessed] }
      .reverse![offset..limit]
      .compact

    questions_ids = paginated_accesses.pluck(:question_id)
    selected_questions = questions.select { |q| questions_ids.include?(q["id"]) }

    paginated_accesses.map! do |pa|
      pa.merge!(
        (selected_questions
          .select { |sq| pa[:question_id] == sq["id"] }
        )
        .first
      )
    end

    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed_time = (end_time - start_time).round(6)

    [paginated_accesses, total, elapsed_time]
  end

  def fetch_params
    [(params[:offset].to_i || 0), (params[:limit].to_i || 10), params[:start_timestamp].to_i]
  end

  def get_time_increment(_time)
    case _time
    when 'weekly'
      time_increment = 1.week
    when 'monthly'
      time_increment = 1.month
    when 'yearly'
      time_increment = 1.year
    else
      raise ChallengeExceptions::BadParameters
    end

    time_increment
  end
end
