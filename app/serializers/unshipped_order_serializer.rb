class UnshippedOrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes
  attribute :potential_revenue, &:total_rev
end
