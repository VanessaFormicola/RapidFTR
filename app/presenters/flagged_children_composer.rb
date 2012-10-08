class FlaggedChildrenComposer

  attr_reader :order

  def initialize(order)
    @order = order
    @order ||= 'most recently flagged'
  end

  def compose(children)
    flagged_children = select(children)
    set_flagged_at(flagged_children)
    sort(flagged_children)
  end

  def sort(children)
    if order == 'most recently flagged'
      children.sort_by{ |child| child['flagged_at'] || Time.now}.reverse!
    else
      children.sort_by{ |child| child['name'] || "" }
    end
  end

  def select(children)
    children.select { |c| c.flag? }
  end

  def set_flagged_at(children)
    children.each { |child|
      child['flagged_at'] = child['histories'].select{ |h| h['changes'].keys.include?('flag') }.map{ |h| h['datetime'] }.max
    }
  end
end
