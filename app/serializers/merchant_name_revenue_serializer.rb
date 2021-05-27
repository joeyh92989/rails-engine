class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  attribute :revenue, &:total_rev
end
