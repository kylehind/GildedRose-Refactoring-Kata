require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  # ITEM (name, sell_in, quality)
  # "Aged Brie" - quality-increase item
  # "Backstage passes to a TAFKAL80ETC concert" - concert item
  # "Sulfuras, Hand of Ragnaros" - legendary item
  # "Beer" - non-special item
  # "Soul Stone" - conjured item

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    context "for multiple items" do
      it "decreases quality of all items (except legendary) by 1" do
        items = [Item.new("Beer", 11, 50), Item.new("Sulfuras, Hand of Ragnaros", 11, 80), Item.new("Bread", 11, 50)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 49
        expect(items[1].quality).to eq 80
        expect(items[2].quality).to eq 49
      end
    end

    context "FOR NON-SPECIAL ITEM" do
      context "that has NOT passed its sell by date, and quality is 50 or over" do
        it "decreases quality by 1" do
          items = [Item.new("Beer", 11, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 49
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Beer", 11, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 10
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 11 or greater" do
        it "decreases quality by 1" do
          items = [Item.new("Beer", 11, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 19
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Beer", 11, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 10
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 10 or less" do
        it "decreases quality by 1" do
          items = [Item.new("Beer", 10, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 19
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Beer", 10, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 9
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 5 or less" do
        it "decreases quality by 1" do
          items = [Item.new("Beer", 5, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 19
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Beer", 5, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 4
        end
      end

      context "that has passed its sell by date" do
        it "decreases quality by 2" do
          items = [Item.new("Beer", 0, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 18
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Beer", 0, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq -1
        end
      end
    end

    context "FOR CONJURED ITEM" do
      context "that has NOT passed its sell by date, and quality is 50 or over" do
        it "decreases quality by 2" do
          items = [Item.new("Soul Stone", 11, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 48
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Soul Stone", 11, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 10
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 11 or greater" do
        it "decreases quality by 2" do
          items = [Item.new("Soul Stone", 11, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 18
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Soul Stone", 11, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 10
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 10 or less" do
        it "decreases quality by 2" do
          items = [Item.new("Soul Stone", 10, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 18
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Soul Stone", 10, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 9
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 5 or less" do
        it "decreases quality by 18" do
          items = [Item.new("Soul Stone", 5, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 18
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Soul Stone", 5, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 4
        end
      end

      context "that has passed its sell by date" do
        it "decreases quality by 4" do
          items = [Item.new("Soul Stone", 0, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 16
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Soul Stone", 0, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq -1
        end
      end
    end

    context "FOR QUALITY-INCREASE ITEM" do
      context "that has NOT passed its sell by date, and quality is 50 or over" do
        it "does not increase quality" do
          items = [Item.new("Aged Brie", 11, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 50
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Aged Brie", 11, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 10
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 11 or greater" do
        it "increases quality by 1" do
          items = [Item.new("Aged Brie", 11, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 21
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Aged Brie", 11, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 10
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 10 or less" do
        it "increases quality by 1" do
          items = [Item.new("Aged Brie", 10, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 21
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Aged Brie", 10, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 9
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 5 or less" do
        it "increases quality by 1" do
          items = [Item.new("Aged Brie", 5, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 21
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Aged Brie", 5, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 4
        end
      end

      context "that has passed its sell by date" do
        it "increases quality by 1" do
          items = [Item.new("Aged Brie", 0, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 21
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Aged Brie", 0, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq -1
        end
      end
    end

    context "FOR CONCERT ITEM" do
      context "that has NOT passed its sell by date, and quality is 50 or over" do
        it "does not increase quality" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 50
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 50)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 10
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 11 or greater" do
        it "increases quality by 1" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 21
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 10
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 10 or less" do
        it "increases quality by 2" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 22
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 9
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 5 or less" do
        it "increases quality by 2" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 23
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 4
        end
      end

      context "that has passed its sell by date" do
        it "decreases quality to 0" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 0
        end
        it "decreases sell_in by 1" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 20)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq -1
        end
      end
    end

    context "FOR LEGENDARY ITEM" do
      context "that has NOT passed its sell by date, and quality is 50 or over" do
        it "does not decrease quality" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 11, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 80
        end
        it "does not decrease sell_in" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 11, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 11
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 11 or greater" do
        it "does not decrease quality" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 11, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 80
        end
        it "does not decrease sell_in" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 11, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 11
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 10 or less" do
        it "does not decrease quality" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 10, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 80
        end
        it "does not decrease sell_in" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 10, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 10
        end
      end

      context "that has NOT passed its sell by date, and sell_in is 5 or less" do
        it "does not decrease quality" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 5, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 80
        end
        it "does not decrease sell_in" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 5, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 5
        end
      end

      context "that has passed its sell by date" do
        it "does not decrease quality" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 80
        end
        it "does not decrease sell_in" do
          items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
          GildedRose.new(items).update_quality()
          expect(items[0].sell_in).to eq 0
        end
      end
    end
  end
end
