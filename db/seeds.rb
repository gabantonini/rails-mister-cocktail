# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'

puts 'Cleaning Cocktails and Doses database...'
Cocktail.destroy_all
puts 'Cocktails and Doses cleaned!'

puts 'Cleaning ingredients database...'

Ingredient.destroy_all

puts 'Ingredients cleaned!'

puts 'Creating 3 ingredients'

Ingredient.create(name: 'lemon')
Ingredient.create(name: 'ice')
Ingredient.create(name: 'mint leaves')

puts 'Creating lots of ingredients with a JSON list'

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'

data = open(url).read
result = JSON.parse(data)
result['drinks'].each do |ingredient|
  new_ingredient = Ingredient.create(name: ingredient["strIngredient1"])
  puts "Creating ingredient #{new_ingredient.name}"
end

puts 'Creating 50 cocktails with doses'

50.times do
  cocktail = Cocktail.create(name: Faker::FunnyName.name)
  puts "Created #{cocktail.name}"
  offset = rand(Ingredient.count)
  puts "Will generate ingredients starting from #{offset}"
  ingredients = Ingredient.limit(5).offset(offset)
  puts 'Listed 5 random ingredients'
  ingredients.each do |ingredient|
    dose = cocktail.doses.build(description: Faker::Food.measurement)
    puts 'Created a dose with a description'
    dose.ingredient = ingredient
    puts 'Linked to a ingredient'
    p cocktail
    puts 'Linked to a cocktail'
    if cocktail.save
      puts 'Cocktail saved!'
    else
      p cocktail.errors.full_messages
    end
  end
  puts 'All doses have been created'
end
puts "Cocktails created: #{Cocktail.count}"
puts "Ingredients created: #{Ingredient.count}"
puts "Doses created: #{Dose.count}"
