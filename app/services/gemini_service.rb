class GeminiService
  BASE_URL = 'https://generativelanguage.googleapis.com/v1beta/models'
  MODEL = 'gemini-2.5-flash'
  
  def initialize
    @api_key = ENV['GOOGLE_API_KEY']
  end

  def get_pfc_values(food_name)
    prompt = build_prompt(food_name)
    response = call_api(prompt)
    parse_response(response)
  rescue StandardError => e
    Rails.logger.error("Gemini API Error: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    nil
  end

  private

  def build_prompt(food_name)
    <<~PROMPT
      以下の食材のPFC値（タンパク質、脂質、炭水化物）を100gあたりのグラム数で教えてください。
      また、カロリーも教えてください。
      
      食材名: #{food_name}
      
      以下のJSON形式で回答してください:
      {
        "name": "食材名",
        "protein": タンパク質(g),
        "fat": 脂質(g),
        "carb": 炭水化物(g),
        "calories": カロリー(kcal)
      }
      
      数値のみを返し、説明は不要です。
      JSON形式以外の余計なテキストは含めないでください。
    PROMPT
  end

  def call_api(prompt)
    uri = URI("#{BASE_URL}/#{MODEL}:generateContent?key=#{@api_key}")
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 30 # タイムアウト設定
    
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    
    request.body = {
      contents: [
        {
          parts: [
            { text: prompt }
          ]
        }
      ],
      generationConfig: {
        temperature: 0.2,  
        maxOutputTokens: 500
      }
    }.to_json
    
    response = http.request(request)
    
    
    Rails.logger.info("Gemini API Response: #{response.code}")
    Rails.logger.debug("Response Body: #{response.body}")
    
    unless response.is_a?(Net::HTTPSuccess)
      raise "API request failed: #{response.code} - #{response.body}"
    end
    
    JSON.parse(response.body)
  end

  def parse_response(response)
    text = response.dig('candidates', 0, 'content', 'parts', 0, 'text')
    return nil unless text
    
    json_text = text.strip
    json_text = json_text.gsub(/```json\n?/, '').gsub(/```\n?/, '')
    
    JSON.parse(json_text, symbolize_names: true)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON Parse Error: #{e.message}")
    Rails.logger.error("Text was: #{text}")
    nil
  end
end