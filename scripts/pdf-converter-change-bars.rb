# scripts/pdf-converter-change-bars.rb
require 'asciidoctor'
require 'asciidoctor-pdf'

# Guard so if CI accidentally requires the file twice, we don't re-define
unless defined?(ChangeBarPdfConverter)
  # IMPORTANT: inherit from Asciidoctor::PDF::Converter so `pdf`, `cursor`, `bounds` exist
  class ChangeBarPdfConverter < Asciidoctor::PDF::Converter
    register_for 'pdf'

    # Minimal logging so we can see in CI that this actually loaded once
    warn "change-bar: ChangeBarPdfConverter loaded"

    def convert_paragraph node; draw(node); super; end
    def convert_table     node; draw(node); super; end
    def convert_section   node; draw(node); super; end
    def convert_ulist     node; draw(node); super; end
    def convert_olist     node; draw(node); super; end

    private

    def mark?(n)
      n.role?('changed') || n.role?('change') || n.role?('added') || n.role?('removed')
    end

    def draw node
      return unless mark?(node)

      color =
        if node.role?('added')   then '1B8E00'
        elsif node.role?('removed') then '8E0000'
        else 'CC0000'
        end

      height =
        case node.context
        when :paragraph then [ (node.lines&.size || 1) * 15, 20 ].max
        when :table     then [ (node.rows&.body&.size || 1) * 18, 40 ].max
        when :section   then 28
        when :ulist, :olist
          [ (node.items&.size || 1) * 16, 24 ].max
        else 24
        end

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
  end
end
