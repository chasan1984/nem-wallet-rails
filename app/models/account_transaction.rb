class AccountTransaction
  include ActiveModel::Model

  attr_reader :timestamp, :type, :amount, :fee, :message, :sender, :recipient

  def initialize(address, t)
    @timestamp = t.timestamp.to_time

    if t.recipient == address
      @type = "出金"
    else
      @type = "入金"
    end

    @amount = (t.amount.to_f / 1000000).to_s(:delimited)
    @fee = (t.fee.to_f / 1000000).to_s(:delimited)

    unless t.message.blank?
      case t.message.type
      when Nem::Model::Message::TYPE_PLAIN
        @message = [t.message.value].pack("H*").force_encoding("utf-8")
      when Nem::Model::Message::TYPE_ENCRYPTED
        @message = "[暗号化]"
      else
        @message = ""
      end
    end

    # signerに送信者の公開鍵が格納されている
    # @sender = endpoint.find_by_public_key(t.signer).address
    # @recipient = t.recipient
  end
end