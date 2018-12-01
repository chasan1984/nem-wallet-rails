class Account
  include ActiveModel::Model

  NODE_HOST = "go.nem.ninja"
  NODE_TIMEOUT = 10

  ADDRESS = "xxxxx"
  P_KEY = "xxxxx"

  def initialize
    @node = Nem::Node.new(host: NODE_HOST, timeout: NODE_TIMEOUT)
  end

  def find
    endpoint = Nem::Endpoint::Account.new(@node)
    endpoint.find(ADDRESS)
  end

  def transfers_all
    endpoint = Nem::Endpoint::Account.new(@node)
    transfers = endpoint.transfers_all(ADDRESS)

    result = []
    transfers.each do |t|
      # 簡潔にするため、マルチシグなどのトランザクションは省く
      next if t.type != 257
      result.push AccountTransaction.new(ADDRESS, t)
    end
    result
  end

  def transfer(params)
    endpoint = Nem::Endpoint::Transaction.new(@node)
    kp = Nem::Keypair.new(P_KEY)
    tx = Nem::Transaction::Transfer.new(params[:address], params[:amount].to_f, params[:message])
    req = Nem::Request::Announce.new(tx, kp)
    res = endpoint.announce(req)


    Rails.logger.debug("Message: #{res.message}")
    Rails.logger.debug("TransactionHash: #{res.transaction_hash}")
  end
end