# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
ENV["FIXTURES"] = "groups"
Rake::Task["db:fixtures:load"].invoke()

groups = Group.all

100.times do |num|
  offer = Offer.create(
    name: Faker::Commerce.product_name,
    description: "Price: $" + Faker::Commerce.price(as_string: true) +
                 "\nColor: " + Faker::Commerce.color +
                 "\nMaterial: " + Faker::Commerce.material +
                 "\nBrand: " + Faker::Commerce.brand +
                 "\nVendor: " + Faker::Commerce.vendor +
                 "\nVoucher: " + Faker::Commerce.promotion_code
  )
  offer.groups << if num.even?
                    [groups.sample, groups.sample].uniq
                  else
                    groups.send([:last, :first].sample, [2, 3, 4].sample)
                  end
end
