module PaymentGateway
  class PaymentFailedError < StandardError; end

  def self.create_adapter
    adapter_class.new
  end

  def self.adapter_class
    adapter_name = Rails.application.config.payment_gateway_adapter.capitalize
    "PaymentGateway::#{adapter_name}Adapter".constantize
  end
end
