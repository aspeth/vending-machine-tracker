require 'rails_helper'

RSpec.describe 'machine show page' do
  it 'has the name and price of each snack in the machine' do
    owner = Owner.create(name: "Carl")
    machine_1 = Machine.create(location: "Denver", owner_id: owner.id)
    machine_2 = Machine.create(location: "Aurora", owner_id: owner.id)

    chips = Snack.create!(name: "chips", price: 1.0)
    donut = Snack.create!(name: "donut", price: 2.0)
    soda = Snack.create!(name: "soda", price: 1.0)

    MachineSnack.create!(machine_id: machine_1.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_1.id, snack_id: donut.id)
    MachineSnack.create!(machine_id: machine_2.id, snack_id: soda.id)

    visit "/machines/#{machine_1.id}"

    expect(page).to have_content("chips: $1.00")
    expect(page).to have_content("donut: $2.00")
    expect(page).to_not have_content("soda: $1.00")
  end

  it "shows the average price for snacks in a machine" do
    owner = Owner.create(name: "Carl")
    machine_1 = Machine.create(location: "Denver", owner_id: owner.id)
    machine_2 = Machine.create(location: "Aurora", owner_id: owner.id)

    chips = Snack.create!(name: "chips", price: 1.0)
    donut = Snack.create!(name: "donut", price: 2.0)
    salsa = Snack.create!(name: "salsa", price: 3.0)
    soda = Snack.create!(name: "soda", price: 1.0)

    MachineSnack.create!(machine_id: machine_1.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_1.id, snack_id: donut.id)
    MachineSnack.create!(machine_id: machine_1.id, snack_id: salsa.id)
    MachineSnack.create!(machine_id: machine_2.id, snack_id: soda.id)

    visit "/machines/#{machine_1.id}"

    expect(page).to have_content("Average Price: $2.00")
  end
end