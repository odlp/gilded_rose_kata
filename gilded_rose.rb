def update_quality(items)
  items.each do |item|
    QUALITY_UPDATERS.detect { |updater| updater.match?(item) }.new.call(item)
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

class NormalQualityUpdater
  def self.match?(item)
    true
  end

  def call(item)
    item.sell_in -= 1
    item.quality += quality_step

    if item.sell_in.negative?
      item.quality += quality_step
    end

    item.quality = item.quality.clamp(0, 50)
  end

  private

  def quality_step
    -1
  end
end

class AgedBrieQualityUpdater < NormalQualityUpdater
  def self.match?(item)
    item.name.match?(/Aged Brie/i)
  end

  private

  def quality_step
    1
  end
end

class ConjuredItemQualityUpdater < NormalQualityUpdater
  def self.match?(item)
    item.name.match?(/Conjured/i)
  end

  private

  def quality_step
    -2
  end
end

class SulfurasQualityUpdater
  def self.match?(item)
    item.name.match?(/Sulfuras/i)
  end

  def call(_); end
end

QUALITY_UPDATERS = [
  AgedBrieQualityUpdater,
  BackstagePassQualityUpdater,
  ConjuredItemQualityUpdater,
  SulfurasQualityUpdater,
  NormalQualityUpdater,
]

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
