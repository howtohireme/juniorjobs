# frozen_string_literal: true

require 'octokit'

# The service load contributors list from github
class ContributorsBuilder
  def initialize
    @client = Octokit::Client.new(per_page: 1000)
  end

  def contributors_logins
    contributors.map(&:login)
  end

  private

  # return [objects - contributors]
  def contributors
    @contributors ||= @client.contributors('howtohireme/juniorjobs')
  end
end
