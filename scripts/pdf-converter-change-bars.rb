# scripts/pdf-converter-change-bars.rb
require 'asciidoctor'
require 'asciidoctor-pdf'

# Guard against double load
unless defined?(ChangeBarPdfConverter)
  class ChangeBarPdfConverter < Asciidoctor::PDF::Converter
    register_for 'pdf'

    def convert_paragraph node
      draw_change_bar(node) if mark?(node)
      super
    end

    def convert_table node
      draw_change_bar(node) if mark?(node)
      super
    end

    def convert_section node
      draw_change_bar(node) if mark?(node)
      super
    end

    def convert_ulist node
      draw_change_bar(node) if mark?(node)
      super
    end

    def convert_olist node
      draw_change_bar(node) if mark?(node)
      super
    end

    private

    def mark?(node)
      node.role?('changed') || node.role?('change') || node.role?('added') || node.role?('removed')
    end

    def draw_change_bar node
      color =
        if node.role?('added')   then '1B8E00'
        elsif node.role?('removed') then '8E0000'
        else 'CC0000'
        end

      height = estimate_height(node)
      x = bounds.left - 12
      top = cursor
      bottom = cursor - height

      pdf.save_graphics_state
      pdf.stroke_color color
      pdf.line_width 3
      pdf.stroke_line [x, top], [x, bottom]
      pdf.restore_graphics_state
    rescue => e
      warn "change-bar: skipped (#{e.class}: #{e.message})"
    end

    def estimate_height node
      case node.context
      when :paragraph
        lines = node.lines ? node.lines.size : 1
        [lines * 15, 20].max
      when :table
        rows = node.rows && node.rows.body ? node.rows.body.size : 1
        [rows * 18, 40].max
      when :section
        28
      when :ulist, :olist
        items = node.items ? node.items.size : 1
        [items * 16, 24].max
      else
        24
      end
    end
  end
end

