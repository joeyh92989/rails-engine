class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name

  attribute :revenue, &:total_rev
end
