## The existing transferwise ruby gems are poorly maintained,
## so we're creating our own Transferwise class.

Error = Struct.new(:error)

class Transferwise
  attr_reader :api_key
  attr_reader :profile_id
  
  def initialize(opts)
    @api_key = opts[:api_key]
    @profile_id = opts[:profile_id]
  end
  
  def profile
    request(endpoint: 'profiles')
  end
  
  def accounts
    request(endpoint: "borderless-accounts?profileId=#{@profile_id}")
  end
  
  def request(opts = {})
    url = "https://api.transferwise.com/v1/#{opts[:endpoint]}"
    headers = {}
    headers["Authorization"] = "Bearer #{@api_key}"
        
    connection = Excon.new(url, headers: headers)

    params = {
      method: opts[:method] || 'GET'
    }

    if opts[:body]
      params[:body] = JSON.generate(opts[:body])
    end

    response = connection.request(params)
    
    if response.status == 200
      begin
        result = JSON.parse(response.body)
      rescue JSON::ParserError
        result = response.body
      end
            
      result
    else
      Error.new(error: "API request failed")
    end
  end
end