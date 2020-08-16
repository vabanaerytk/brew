# frozen_string_literal: true

require "utils/curl"

module Repology
  module_function

  MAX_PAGINATION = 15

  def query_api(last_package_in_response = "")
    last_package_in_response += "/" if last_package_in_response.present?
    url = "https://repology.org/api/v1/projects/#{last_package_in_response}?inrepo=homebrew&outdated=1"

    output, _errors, _status = curl_output(url.to_s)
    JSON.parse(output)
  end

  def single_package_query(name)
    url = "https://repology.org/api/v1/project/#{name}"

    output, _errors, _status = curl_output(url.to_s)
    data = JSON.parse(output)

    homebrew = data.select do |repo|
      repo["repo"] == "homebrew"
    end

    homebrew.empty? ? nil : { name => data }
  end

  def parse_api_response
    ohai "Querying outdated packages from Repology"

    outdated_packages = query_api
    last_package_index = outdated_packages.size - 1
    response_size = outdated_packages.size
    page_no = 1

    while response_size > 1 && page_no <= MAX_PAGINATION
      odebug "Paginating Repology API page: #{page_no}"

      last_package_in_response = outdated_packages.keys[last_package_index]
      response = query_api(last_package_in_response)

      response_size = response.size
      outdated_packages.merge!(response)
      last_package_index = outdated_packages.size - 1
      page_no += 1
    end

    puts "#{outdated_packages.size} outdated #{"package".pluralize(outdated_packages.size)} found"
    puts

    outdated_packages
  end

  def validate_and_format_packages(outdated_repology_packages, limit)
    packages = {}
    outdated_repology_packages.each do |_name, repositories|
      # identify homebrew repo
      repology_homebrew_repo = repositories.find do |repo|
        repo["repo"] == "homebrew"
      end

      next if repology_homebrew_repo.blank?

      latest_version = repositories.find { |repo| repo["status"] == "newest" }

      next if latest_version.blank?

      latest_version = latest_version["version"]
      srcname = repology_homebrew_repo["srcname"]
      package_details = format_package(srcname, latest_version)
      packages[srcname] = package_details unless package_details.nil?

      break if limit && packages.size >= limit
    end

    packages
  end

  def format_package(package_name, latest_version)
    formula = formula_data(package_name)

    return if formula.blank?

    formula_name = formula.to_s
    tap_full_name = formula.tap&.full_name
    current_version = formula.version.to_s
    livecheck_response = LivecheckFormula.init(package_name)
    pull_requests = GitHub.fetch_pull_requests(formula_name, tap_full_name, state: "open")

    if pull_requests.try(:any?)
      pull_requests = pull_requests.map { |pr| "#{pr["title"]} (#{Formatter.url(pr["html_url"])})" }.join(", ")
    end

    pull_requests = "None" if pull_requests.empty?

    {
      repology_latest_version:  latest_version,
      current_formula_version:  current_version.to_s,
      livecheck_latest_version: livecheck_response[:livecheck_version],
      open_pull_requests:       pull_requests,
    }
  end

  def formula_data(package_name)
    Formula[package_name]
  rescue
    nil
  end
end
