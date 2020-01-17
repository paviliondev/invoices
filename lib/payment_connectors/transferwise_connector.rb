class TransferwiseConnector
  
  attr_reader :bank_details
    
  def initialize(provider)
    @transferwise = Transferwise.new(
      api_key: provider.api_key,
      profile_id: provider.external_id
    )
  end
  
  def test
    result = @transferwise.profile
    result.respond_to?(:error) ? result : result[0]['id']
  end
  
  def bank_details(currency = 'USD')
    if accounts = @transferwise.accounts
      account = accounts[0]['balances'].select { |a| a['currency'] === currency }
      raw_details = account[0]['bankDetails']
      
      @bank_details = [
        {
          key: 'name',
          label: 'Account Holder',
          value: raw_details['accountHolderName']
        },
        {
          key: 'routing',
          label: 'Routing Number (ACH or ABA)',
          value: raw_details['bankCode']
        },
        {
          key: 'account',
          label: 'Account Number',
          value: raw_details['accountNumber']
        },
        {
          key: 'swift',
          label: 'Bank Code (SWIFT / BIC)',
          value: raw_details['swift']
        },
        {
          key: 'address',
          label: 'Bank Address',
          value: "
            #{raw_details['bankName']}\n
            #{raw_details['bankAddress']['addressFirstLine']}\n
            #{raw_details['bankAddress']['city']}\n
            #{raw_details['bankAddress']['postCode']}\n
            #{raw_details['bankAddress']['country']}\n
          "
        }
      ]
      
      @bank_details
    end
  end
  
  def profile
    @transferwise.profile
  end
  
end