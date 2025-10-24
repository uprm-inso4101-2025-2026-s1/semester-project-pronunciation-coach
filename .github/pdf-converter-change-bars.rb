# pdf-converter-change-bars.rb
require 'asciidoctor'
require 'asciidoctor-pdf'

class ChangeBarPdfConverter < (Asciidoctor::Converter.for 'pdf')
  register_for 'pdf'

  def convert_paragraph node
    if node.role? 'changed'
      draw_change_bar_for_paragraph(node)
    end
    super
  end

  def convert_table node
    if node.role? 'changed'
      draw_change_bar_for_table(node)
    end
    super
  end

  def convert_section node
    if node.role? 'changed'
      draw_change_bar_for_section(node)
    end
    super
  end

  def convert_ulist node
    if node.role? 'changed'
      draw_change_bar_for_list(node)
    end
    super
  end

  def convert_olist node
    if node.role? 'changed'
      draw_change_bar_for_list(node)
    end
    super
  end

  private

  def draw_change_bar_for_paragraph(node)
    pdf.save_graphics_state
    pdf.stroke_color 'CC0000'  # Red color for changes
    pdf.line_width 4
    
    bar_x = bounds.left - 15
    bar_top = cursor
    bar_bottom = cursor - estimate_paragraph_height(node)
    
    pdf.stroke_line [bar_x, bar_top], [bar_x, bar_bottom]
    pdf.restore_graphics_state
  end

  def draw_change_bar_for_table(node)
    pdf.save_graphics_state
    pdf.stroke_color 'CC0000'
    pdf.line_width 4
    bar_x = bounds.left - 15
    
    # Estimate table height based on rows
    estimated_height = [node.rows.size * 20, 50].max
    bar_top = cursor
    bar_bottom = cursor - estimated_height
    
    pdf.stroke_line [bar_x, bar_top], [bar_x, bar_bottom]
    pdf.restore_graphics_state
  end

  def draw_change_bar_for_section(node)
    pdf.save_graphics_state
    pdf.stroke_color 'CC0000'
    pdf.line_width 4
    bar_x = bounds.left - 12
    bar_top = cursor
    bar_bottom = cursor - 25  # Section header height
    
    pdf.stroke_line [bar_x, bar_top], [bar_x, bar_bottom]
    pdf.restore_graphics_state
  end

  def draw_change_bar_for_list(node)
    pdf.save_graphics_state
    pdf.stroke_color 'CC0000'
    pdf.line_width 4
    bar_x = bounds.left - 15
    
    estimated_height = [node.items.size * 15, 25].max
    bar_top = cursor
    bar_bottom = cursor - estimated_height
    
    pdf.stroke_line [bar_x, bar_top], [bar_x, bar_bottom]
    pdf.restore_graphics_state
  end

  def estimate_paragraph_height(node)
    # Estimate height based on line count
    line_count = node.lines ? node.lines.size : 1
    [line_count * 15, 20].max
  end
end

# Alternative converter for different change types
class AdvancedChangeBarConverter < (Asciidoctor::Converter.for 'pdf')
  register_for 'pdf'

  def convert_paragraph node
    draw_change_bar(node) if node.role?('changed') || node.role?('added') || node.role?('removed')
    super
  end

  def convert_table node
    draw_change_bar(node) if node.role?('changed') || node.role?('added') || node.role?('removed')
    super
  end

  def convert_section node
    draw_change_bar(node) if node.role?('changed') || node.role?('added') || node.role?('removed')
    super
  end

  private

  def draw_change_bar(node)
    pdf.save_graphics_state
    
    # Determine color based on role
    if node.role? 'added'
      color = '1B8E00'  # Green for additions
    elsif node.role? 'removed'
      color = '8E0000'  # Dark red for removals
    else
      color = 'CC0000'  # Red for changes
    end
    
    pdf.stroke_color color
    pdf.line_width 4
    
    bar_x = bounds.left - 15
    bar_top = cursor
    bar_bottom = cursor - estimate_content_height(node)
    
    pdf.stroke_line [bar_x, bar_top], [bar_x, bar_bottom]
    pdf.restore_graphics_state
  end

  def estimate_content_height(node)
    case node.context
    when :paragraph
      node.lines ? [node.lines.size * 15, 20].max : 25
    when :table
      [node.rows.size * 18, 40].max
    when :section
      30
    when :ulist, :olist
      [node.items.size * 16, 25].max
    else
      25
    end
  end
end

# Use the advanced converter for multiple change types
ChangeBarPdfConverter = AdvancedChangeBarConverter