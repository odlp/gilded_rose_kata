def update_quality(items)
  items.each do |item|
    QualityUpdater.update(item)
  end
end

class BackstagePassQualityUpdater
  def self.match?(item)
    item.name.match?(/Backstage passes/i)
  end

  def call(item)
    case item.sell_in
    when 11..   then item.quality += 1
    when 6..10  then item.quality += 2
    when 1..5   then item.quality += 3
    when ..0    then item.quality = 0
    end

    item.sell_in -= 1
    item.quality = item.quality.clamp(0, 50)
  end
end

class ConjuredItemQualityUpdater
  def self.match?(item)
    item.name.match?(/Conjured/i)
  end

  def call(item)
    item.sell_in -= 1
    item.quality -= 2

    if item.sell_in.negative?
      item.quality -= 2
    end

    item.quality = item.quality.clamp(0, 50)
  end
end

class AgedBrieQualityUpdater
  def self.match?(item)
    item.name.match?(/Aged Brie/i)
  end

  def call(item)
    item.sell_in -= 1
    item.quality += 1

    if item.sell_in.negative?
      item.quality += 1
    end

    item.quality = item.quality.clamp(0, 50)
  end
end

class SulfurasQualityUpdater
  def self.match?(item)
    item.name.match?(/Sulfuras/i)
  end

  def call(_); end
end

class QualityUpdater
  SPECIAL_UPDATERS = [
    AgedBrieQualityUpdater,
    BackstagePassQualityUpdater,
    ConjuredItemQualityUpdater,
    SulfurasQualityUpdater,
  ]

  def self.update(item)
    updater = SPECIAL_UPDATERS.detect { |updater| updater.match?(item) } || self
    updater.new.call(item)
  end

  def call(item)
    item.sell_in -= 1
    item.quality -= 1

    if item.sell_in.negative?
      item.quality -= 1
    end

    item.quality = item.quality.clamp(0, 50)
  end
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
