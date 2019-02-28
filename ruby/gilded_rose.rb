class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"
      daily_update(item)

      item.sell_in -= 1

      expired_update(item) if item.sell_in < 0

      item.quality = 0 if item.quality < 0
      item.quality = 50 if item.quality > 50
    end
  end

  def daily_update(item)
    case item.name
    when "Aged Brie"
      item.quality += 1
    when "Backstage passes to a TAFKAL80ETC concert"
      item.quality += 1
      item.quality += 1 if item.sell_in < 11
      item.quality += 1 if item.sell_in < 6
    when "Soul Stone"
      item.quality -= 2
    else
      item.quality -= 1
    end
  end

  def expired_update(item)
    case item.name
    when "Aged Brie"
      item.quality = item.quality + 1
    when "Backstage passes to a TAFKAL80ETC concert"
      item.quality = 0
    when "Soul Stone"
      item.quality -= 2
    else
      item.quality -= 1
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end