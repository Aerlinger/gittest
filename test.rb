require 'active_support/all'
require 'faker'

DEBUG = false

def weekend?(day)
  day.sunday? || day.saturday?
end

start_date = 1.years.ago.to_date
today = (Date.today - 1.day)

days_in_last_year = start_date..today


calendar_days = days_in_last_year.to_a
idx = 0
while idx < calendar_days.length
  day = calendar_days[idx]

  commit_probability_weekday = 0.6
  commit_probability_weekend = 0.2
  commit_skip_interval = rand(2..10)
  commit_probability_skip_interval = 0.3

  num_commits = rand(10)

  if rand <= commit_probability_skip_interval
    idx += rand(commit_skip_interval)
    next
  end

  if weekend?(day) 
    num_commits = 0 if rand <= commit_probability_weekend
  else
    num_commits = 0 if rand <= commit_probability_weekday
  end
  
  if DEBUG
    print num_commits.to_s + " "

    if idx % 7 == 0
      puts
    end
  end

  num_commits.times do |i|
    commit_time = (day + i.hours + rand(60).minutes).to_formatted_s(:rfc822)

    # Run the shell commit to make the commit
    %x(
        echo #{commit_time} >> edit;
        export GIT_AUTHOR_DATE="#{commit_time}"
        export GIT_COMMITTER_DATE="#{commit_time}"
        git commit -am "#{Faker::Lorem.sentence(4)}"
      )

    puts commit_time
  end
  
  idx += 1
end

