class MerchantNameRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  attribute :revenue do |object|
    object.total_rev
  end
end
