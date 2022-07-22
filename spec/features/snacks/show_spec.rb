require 'rails_helper'

RSpec.describe 'snack show page' do
  it 'has the name and price for the snack' do
    owner = Owner.create(name: "Carl")
    machine_1 = Machine.create(location: "Denver", owner_id: owner.id)

    chips = Snack.create!(name: "chips", price: 1.0)
    donut = Snack.create!(name: "donut", price: 2.0)

    MachineSnack.create!(machine_id: machine_1.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_1.id, snack_id: donut.id)
    
    visit "/snacks/#{chips.id}"
    
    expect(page).to have_content("chips: $1.00")
  end
  
  it 'has a list of locations where the snack is carried' do
    owner = Owner.create(name: "Carl")
    machine_1 = Machine.create(location: "Denver", owner_id: owner.id)
    machine_2 = Machine.create(location: "Aurora", owner_id: owner.id)
    machine_3 = Machine.create(location: "Arvada", owner_id: owner.id)
  
    chips = Snack.create!(name: "chips", price: 1.0)
    donut = Snack.create!(name: "donut", price: 2.0)
  
    MachineSnack.create!(machine_id: machine_1.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_2.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_3.id, snack_id: donut.id)
    
    visit "/snacks/#{chips.id}"

    within "#locations" do
      expect(page).to have_content("Denver")
      expect(page).to have_content("Aurora")
      expect(page).to_not have_content("Arvada")
    end
  end
  
  it 'has the average price for each machine' do
    owner = Owner.create(name: "Carl")
    machine_1 = Machine.create(location: "Denver", owner_id: owner.id)
    machine_2 = Machine.create(location: "Aurora", owner_id: owner.id)
    machine_3 = Machine.create(location: "Arvada", owner_id: owner.id)
  
    chips = Snack.create!(name: "chips", price: 1.0)
    donut = Snack.create!(name: "donut", price: 2.0)
    gold = Snack.create!(name: "gold", price: 3.0)
  
    MachineSnack.create!(machine_id: machine_1.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_1.id, snack_id: donut.id)
    MachineSnack.create!(machine_id: machine_2.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_2.id, snack_id: gold.id)
    
    visit "/snacks/#{chips.id}"

    within "#locations-#{machine_1.id}" do
      expect(page).to have_content("Average Price: $1.50")
    end

    within "#locations-#{machine_2.id}" do
      expect(page).to have_content("Average Price: $2.00")
    end
  end
  
  it 'has the snack count for each snack in the machine' do
    owner = Owner.create(name: "Carl")
    machine_1 = Machine.create(location: "Denver", owner_id: owner.id)
    machine_2 = Machine.create(location: "Aurora", owner_id: owner.id)
    machine_3 = Machine.create(location: "Arvada", owner_id: owner.id)
  
    chips = Snack.create!(name: "chips", price: 1.0)
    donut = Snack.create!(name: "donut", price: 2.0)
    gold = Snack.create!(name: "gold", price: 3.0)
  
    MachineSnack.create!(machine_id: machine_1.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_1.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_1.id, snack_id: donut.id)
    MachineSnack.create!(machine_id: machine_2.id, snack_id: chips.id)
    
    visit "/snacks/#{chips.id}"

    within "#locations-#{machine_1.id}" do
      expect(page).to have_content("Snack Types: 2")
    end
    
    within "#locations-#{machine_2.id}" do
      expect(page).to have_content("Snack Types: 1")
    end
  end
end

# As a visitor
# When I visit a snack show page
# I see the name of that snack
#   and I see the price for that snack
#   and I see a list of locations with vending machines that carry that snack
#   and I see the average price for snacks in those vending machines
#   and I see a count of the different kinds of items in that vending machine.