# app/services/ai/project_description_generator.rb
module Ai
  class ProjectDescriptionGenerator
    def initialize(title:, short_description:)
      @title = title.to_s.strip
      @short_description = short_description.to_s.strip
      @client = OpenAI::Client.new(api_key: ENV.fetch("OPENAI_API_KEY"))
    end

    def call
      raise ArgumentError, "Title is required" if @title.blank?
      raise ArgumentError, "Short description is required" if @short_description.blank?

      prompt = <<~PROMPT
        You are helping a developer write a project description for a collaborative app-building platform.

        Write a clear, structured, motivating full project description in English.

        Project title: #{@title}
        Short description: #{@short_description}

        Requirements:
        - Keep it concise but useful
        - 1 short intro paragraph
        - Then 3 sections:
          1. Goal
          2. Main features
          3. Who we are looking for
        - Keep the tone practical, inspiring, and startup-oriented
        - Do not invent absurd technical details
        - Return plain text only
      PROMPT

      response = @client.responses.create(
        model: "gpt-5.2",
        input: prompt
      )

      extract_text(response)
    end

    private

    def extract_text(response)
      if response.respond_to?(:output_text) && response.output_text.present?
        response.output_text
      else
        response.to_s
      end
    end
  end
end
