def update_quality(items)
  items.each do |item|
    case(item.name)
    when /Aged Brie/i
      next update_aged_brie(item)
    when /Sulfuras/i
      next
    when /Backstage passes/i
      next update_backstage_passes(item)
    else
      next update_normal_item(item)
    end

    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.quality > 0
        if item.name != 'Sulfuras, Hand of Ragnaros'
          item.quality -= 1
        end
      end
    else
      if item.quality < 50
        item.quality += 1
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in < 11
            if item.quality < 50
              item.quality += 1
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              item.quality += 1
            end
          end
        end
      end
    end
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.sell_in -= 1
    end
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality > 0
            if item.name != 'Sulfuras, Hand of Ragnaros'
              item.quality -= 1
            end
          end
        else
          item.quality = item.quality - item.quality
        end
      else
        if item.quality < 50
          item.quality += 1
        end
      end
    end
  end
end

def update_aged_brie(item)
  item.sell_in -= 1

  if item.quality < 50
    item.quality += 1
  end

  if item.sell_in < 0 && item.quality < 50
    item.quality += 1
  end
end

def update_backstage_passes(item)
  new_quality = case item.sell_in
  when 11..   then item.quality + 1
  when 6..10  then item.quality + 2
  when 1..5   then item.quality + 3
  when ..0    then 0
  end

  item.sell_in -= 1
  item.quality = [new_quality, 50].min
end

def update_normal_item(item)
  item.sell_in -= 1

  if item.sell_in >= 0
    item.quality -= 1
  else
    item.quality -= 2
  end

  item.quality = item.quality.clamp(0, 50)
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]
