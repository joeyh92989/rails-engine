class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer

  attribute :revenue, &:total_rev
end
