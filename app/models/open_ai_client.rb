require "openai"

class OpenAiClient
  DEFAULT_MODEL = "gpt-3.5-turbo"
  MODEL_PRICES = {
    "gpt-3.5-turbo": { "input": 0.0015, "output": 0.002 },
    "gtp-4": { "input": 0.03, "output": 0.06 },
  }

  def initialize(opts)
    @messages = opts["messages"] || opts[:messages] || []
    @prompt = opts["prompt"] || opts[:prompt] || "backup"
  end

  def self.openai_client
    @openai_client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def create_image
    response = openai_client.images.generate(parameters: { prompt: @prompt, size: "512x512" })
    if response
      img_url = response.dig("data", 0, "url")
      puts "*** ERROR *** Invaild Image Response: #{response}" unless img_url
    else
      puts "**** Client ERROR **** \nDid not receive valid response.\n#{response}"
    end
    img_url
  end

  def create_image_variation(img_url, num_of_images = 1)
    response = openai_client.images.variations(parameters: { image: img_url, n: num_of_images })
    img_variation_url = response.dig("data", 0, "url")
    puts "*** ERROR *** Invaild Image Variation Response: #{response}" unless img_variation_url
    img_variation_url
  end

  def create_completion
    response = openai_client.completions(parameters: { model: DEFAULT_MODEL, prompt: @prompt })
    if response
      choices = response["choices"].map { |c| "<p class='ai-response'>#{c["text"]}</p>" }.join("\n")
      response_body = choices[0]
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    response_body
  end

  def create_chat
    opts = {
      model: DEFAULT_MODEL, # Required.
      messages: @messages, # Required.
      temperature: 0.9,
    }
    response = openai_client.chat(
      parameters: opts,
    )

    message_tokens = num_tokens_from_messages

    puts "Sent to OpenAI -- message count: #{@messages&.count} - num_tokens: #{message_tokens}"

    if response
      @model = response.dig("model")
      @role = response.dig("choices", 0, "message", "role")
      @content = response.dig("choices", 0, "message", "content")
      @prompt_tokens = response.dig("usage", "prompt_tokens")
      @completion_tokens = response.dig("usage", "completion_tokens")
      @total_tokens = response.dig("usage", "total_tokens")
      @message_tokens = message_tokens
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    { role: @role, content: @content, prompt_tokens: @prompt_tokens, completion_tokens: @completion_tokens, total_tokens: @total_tokens, message_tokens: @message_tokens, model: @model }
  end

  def self.ai_models
    @models = openai_client.models.list
  end

  def self.get_model_prices(model = DEFAULT_MODEL)
    model = DEFAULT_MODEL unless MODEL_PRICES.keys.include?(model.to_sym)
    MODEL_PRICES[model.to_sym]
  end
end
